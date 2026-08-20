# `bridge/` — flutter_rust_bridge

Configuration de génération et fichiers générés reliant `core/` (Rust) à
`app/` (Dart).

## Règles (§6.1)

- Les fichiers générés sont **commités** mais **jamais édités à la main** —
  toute modification passe par une régénération.
- Le bridge ne contient aucune logique métier : il expose l'API publique de
  `core/src/lib.rs`, rien de plus.

## À mettre en place (§6.2)

- Configuration `flutter_rust_bridge_codegen` + targets natifs
  (Android, iOS, Windows, macOS, Linux).
- Build **WASM** distinct du build natif pour le web
  (`wasm32-unknown-unknown`) — historiquement le point le plus pénible à
  configurer, à faire tôt.
