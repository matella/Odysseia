//! Pont entre `timeline_core` et l'application Flutter (§6.1).
//!
//! Ce crate existe pour une seule raison : `timeline_core` ne doit dépendre ni
//! de Flutter, ni de Dart, ni de `flutter_rust_bridge` (§6.1). Toute la glue
//! vit donc ici, et le cœur reste un crate Rust ordinaire, testable seul.
//!
//! `frb_generated.rs` est **généré** — jamais édité à la main (§6.1).

pub mod api;
mod frb_generated;
