# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/1.1.0/).
Versioning: [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Monorepo skeleton (§6) : `core/`, `bridge/`, `app/`, `assets/`, `docs/`.
- CI légère (§3.9) : `cargo test` + `cargo clippy`, `flutter test`,
  builds de vérification Android + web.
- `CLAUDE.md` — contraintes non négociables pour l'implémentation.
- Couche de parsing `core/src/parse/` (§3.10, §5.1) : trait d'import
  générique, parseur Google en streaming (formats `semanticSegments` et
  tableau direct), normalisation des coordonnées (E7, `geo:`, degrés,
  `latLng`) et des horodatages (UTC + offset séparés, §5.5).
- Types d'erreur dédiés par cas (§3.10) : `EmptyExport`, `CorruptJson`,
  `UnrecognisedFormat`, `FileTooLarge`, `Io`, plus les rejets non fatals
  `CoordError` / `TimeError`.
- Fixtures et tests de la couche de parsing : 48 tests, dont une preuve
  de mémoire bornée sur un export généré de 5 Mo (§4).
