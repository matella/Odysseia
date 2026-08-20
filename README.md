# Odysseia (Ὀδύσσεια)

Visualiseur de Google Timeline — multi-plateforme, **zéro transfert réseau**.

> Squelette de projet. Aucune fonctionnalité n'est encore implémentée.

Trois angles d'exploration de son export Google Timeline : récit jour par jour,
stats & patterns, et vidéo souvenir animée. Tout le traitement se fait
localement sur l'appareil — aucune donnée Timeline n'est envoyée à un serveur.

## Statut

| Étape | État |
| --- | --- |
| Arborescence §6 + CI légère | fait |
| Parsing streaming + fixtures (§3.10) | à faire |
| Schéma §5 en base + pipeline §5.4 | à faire |
| Vues Récit / Stats / Vidéo | à faire |

## Structure

| Dossier | Rôle |
| --- | --- |
| `core/` | crate Rust `timeline_core` — parsing, pipeline, stats, rendu |
| `bridge/` | configuration et fichiers générés `flutter_rust_bridge` |
| `app/` | application Flutter (Android, iOS, web, desktop) |
| `assets/geo_place/` | base GeoNames filtrée, embarquée (§5.3) |
| `docs/` | [specs.md](docs/specs.md), [privacy.md](docs/privacy.md), [data-model.md](docs/data-model.md) |

## Prérequis

- Rust stable + target `wasm32-unknown-unknown`
- Flutter stable

## Documentation

- [`docs/specs.md`](docs/specs.md) — spécification complète (source de vérité)
- [`CLAUDE.md`](CLAUDE.md) — contraintes non négociables pour l'implémentation
- [`docs/privacy.md`](docs/privacy.md) — politique de confidentialité

## Export de son Timeline.json

_À documenter._

## Licence

[MIT](LICENSE).
