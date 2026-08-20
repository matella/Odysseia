# CLAUDE.md — Odysseia

Google Timeline visualiser. Flutter UI + Rust compute core (`timeline_core`),
native and WASM. Monorepo.

**`docs/specs.md` is the source of truth.** Every decision in it was deliberate
and justified. Read the relevant section before implementing anything; if
something here and the spec disagree, the spec wins and this file is stale —
say so rather than guessing.

---

## Non-negotiable constraints

These are architectural invariants, not preferences. Violating any of them is a
bug even if the code compiles, the tests pass, and the feature works.

### 1. Zero network for Timeline data (§2)

No Timeline data — raw points, visits, segments, derived aggregates, file
contents — ever leaves the device. Parsing, clustering, stats and video frame
generation all run locally.

Exactly three network exceptions exist, and no fourth may be added without an
explicit decision recorded in the spec:

| Exception | Default | What crosses the wire |
| --- | --- | --- |
| OSM map tiles (§2) | off until explicit consent | viewport tile coordinates only — **never** Timeline data |
| Immich photo server (§3.1) | **off** | user's own server; derived Timeline data (dates, coordinates) |
| Historical weather API (§3.3) | **off** | coordinates **rounded to 2 decimals** (~1.1 km) + date |

Rules that follow:
- Each optional integration gets its own switch in Settings and its own privacy
  warning that states **explicitly what Timeline-derived data is transmitted** —
  "requires a connection" is not an acceptable warning (§2).
- Weather coordinates are rounded to 2 decimals *before* any call, and cached
  locally per (cell, day) so the same cell is never queried twice (§4).
- Crash logs are local only, never auto-transmitted; manual export only (§3.10).
- No telemetry, no analytics, no crash reporting SDK, no remote config, no
  auto-update check. Ever.

### 2. `core/` has no Flutter and no Dart dependency (§6.1)

`timeline_core` is a plain Rust crate. It must build and be fully testable with
`cargo test` alone — no emulator, no device, no Flutter SDK.

- No `flutter_rust_bridge` types, no Dart FFI concerns, no UI concepts leaking
  into the core's public API.
- It must compile for native targets **and** `wasm32-unknown-unknown` (§6.2).
  Do not reach for anything unavailable on WASM (threads, blocking I/O,
  arbitrary filesystem access) without a WASM-safe path.

### 3. `app/` contains no business logic (§6.1)

Parsing, coordinate normalisation, clustering, place resolution, stats
aggregation and video frame generation live in `core/`. Dart orchestrates UI,
the local database, and bridge calls — nothing more.

If you find yourself writing a distance computation, a mode-detection heuristic,
a date-bucketing rule or a "just this once" parse in Dart: stop, it belongs in
Rust. Duplicated logic between the two sides is the failure mode this rule
exists to prevent.

Generated `flutter_rust_bridge` files are committed but **never hand-edited**
(§6.1) — regenerate instead.

### 4. All data access goes through the pipeline (§5.4)

The §5.4 pipeline is the single gateway to Timeline data. In order, always:

1. **Private-zone filtering** — before anything else
2. Place-name resolution: `user_place` → `geo_place` → raw coordinates
3. `user_segment_override` applied over `detected_mode`
4. Current view's filters (period / place / mode)

All three views (Story §3.3, Stats §3.4, Video §3.5) consume **the same pipeline
output**. No view, export, stat or renderer queries the database directly and
bypasses steps 1–3. Stats are composable queries over that filtered stream, not
frozen precomputed tables (§3.4).

### 5. Private zones are applied at the source (§3.7)

Private zones are filtered inside the pipeline, at the data source — not hidden
at render time, not skipped by a widget, not `opacity: 0`.

A point inside a private zone must be absent from stats totals, from the video
frames, and from the data export — not merely invisible on screen. If a code
path can observe raw data before step 1 of the pipeline ran, that path is wrong.

---

## Data-model rules that fall out of the above (§5)

- **Imported zone (§5.1) is disposable; user zone (§5.2) is sacred.** A re-import
  wipes and rebuilds `import_batch` / `raw_point` / `segment` / `visit`. It must
  **never** touch `user_place`, `user_segment_override`, `private_zone`,
  `app_setting`.
- **Nothing in §5.2 may reference an id from §5.1.** User data is attached
  geographically (a visit falls within a `user_place` radius) or by tolerant
  fingerprint (local date + rounded start/end coordinates for transport-mode
  overrides, §4) — never by import id, which changes on every import.
- `detected_mode` always keeps its original imported value. A user correction
  lives in `user_segment_override` and is applied by the pipeline, never written
  back over the detection.
- Orphan overrides are **kept, inactive** — never auto-deleted (§4).
- Store UTC + `tz_offset_minutes` separately. Never local time alone: hour-of-day
  patterns and timezone-crossing trips depend on it (§5.5).
- One dataset at a time (§3.6); a new import replaces the previous one, with the
  source file archived and an explicit warning if the new export covers a
  shorter period than the current one (§4).

## Behavioural rules

- **Never a visible crash** (§3.10). Every failure mode gets its own error type
  in `timeline_core` — corrupt JSON, empty export, unrecognised future format,
  file too large — so the UI can show a specific, translated message. A generic
  catch-all error is a spec violation.
- **Every user-facing string is localised, English + French, from v1** (§3.9).
- **Streaming parse, always** (§4). Never load the whole Timeline.json in
  memory. Runs in an Isolate (native) / Web Worker (web), reports progress
  (percent + current step), inserts in batched transactions.
- **Degraded platform capabilities are surfaced, not silently dropped** (§2) —
  they belong in the Settings/capabilities screen.
- Design target: **10 years, ~5M raw points**, 500 MB Timeline.json native,
  warning past ~200 MB on web (§4). Past that, the app warns rather than
  silently crawling.
- The Google parser is *one* implementation behind a common import trait — the
  model is never shaped around Google's format (§3.1).

## Layout & tooling

Structure is fixed by §6 — follow it rather than inventing new top-level
directories.

```
core/     Rust crate timeline_core — model, parse, pipeline, stats, geocode, render
bridge/   flutter_rust_bridge config + generated files (never hand-edited)
app/      Flutter app — lib/{data,features,l10n,shared}
assets/   embedded filtered GeoNames geo_place base
docs/     specs.md (source of truth), privacy.md, data-model.md
```

- Licence: MIT (§3.9).
- CI is deliberately light (§3.9): `cargo test` + `cargo clippy`, `flutter test`
  (unit + golden), Android + web verification builds. No release pipeline, no
  signing, no auto-publishing. Desktop/iOS binaries are built locally on demand.
- Tests: fixtures + systematic unit tests in `core/fixtures` and `core/tests`,
  covering legacy and current formats, coordinate variants, and edge cases
  (empty file, very large file, dateline). Golden tests for Flutter UI (§3.10).
