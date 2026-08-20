//! `timeline_core` — moteur de calcul d'Odysseia.
//!
//! Squelette : aucun module n'est encore implémenté (§7).
//!
//! Contraintes structurantes (voir `CLAUDE.md` et `docs/specs.md`) :
//! - zéro réseau : ce crate ne fait **aucun** appel réseau (§2) ;
//! - aucune dépendance Flutter/Dart, testable seul via `cargo test` (§6.1) ;
//! - doit compiler pour les cibles natives **et** `wasm32-unknown-unknown` (§6.2) ;
//! - toute lecture de données Timeline passe par [`pipeline`] (§5.4).

pub mod error;
pub mod geocode;
pub mod model;
pub mod parse;
pub mod pipeline;
pub mod render;
pub mod stats;
