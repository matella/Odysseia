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
- Modèle §5 complet dans `core/src/model/` : zone importée (§5.1), zone
  utilisateur (§5.2) et référentiel embarqué (§5.3), séparés en modules
  distincts — aucune structure de §5.2 ne porte d'identifiant de §5.1.
- Pipeline §5.4 dans `core/src/pipeline/` : zones privées → noms de lieux
  → corrections de mode → filtres de vue, dans cet ordre.
- Schéma drift dans `app/lib/data/` : les neuf tables de §5, index de
  volume, ré-import transactionnel qui ne touche jamais la zone
  utilisateur, et suppression totale explicite (§3.7).
- Tests de survie au ré-import, côté base (`app/test/data/`) et côté sens
  (`core/tests/pipeline_reimport.rs`).
- Pont `flutter_rust_bridge` (`bridge/`) : `timeline_core` reste sans
  dépendance Flutter/Dart (§6.1), toute la glue vit dans un crate séparé.
  L'API n'expose aucune fonction renvoyant de la donnée non filtrée.
- Statistiques §3.4 dans `core/src/stats/` : un seul mécanisme d'histogramme,
  six choix de clé — pas six calculs ad hoc.
- Plan de frames §3.5 dans `core/src/render/` : déterministe, sans encodeur.
- Les trois vues (§3.3–3.5) et leur navigation, alimentées par
  `TimelineRepository` — seul chemin vers les données.
- Internationalisation anglais + français (§3.9) et 18 golden tests, une
  image par vue **et par locale** (§3.10).
