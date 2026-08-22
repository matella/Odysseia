#![allow(dead_code)]

//! Helpers partagés par les tests d'intégration.

use std::fs::File;
use std::path::PathBuf;

use timeline_core::error::ParseError;
use timeline_core::parse::ImportSummary;
use timeline_core::parse::{
    CollectingSink, ParseOptions, TimelineImporter, google::GoogleImporter,
};

/// Chemin d'une fixture (§3.10).
pub fn fixture(name: &str) -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("fixtures")
        .join(name)
}

/// Parse une fixture avec les options par défaut.
pub fn parse(name: &str) -> Result<(ImportSummary, CollectingSink), ParseError> {
    parse_with(name, &ParseOptions::default())
}

/// Parse une fixture avec des options explicites.
pub fn parse_with(
    name: &str,
    options: &ParseOptions,
) -> Result<(ImportSummary, CollectingSink), ParseError> {
    let mut file = File::open(fixture(name)).expect("fixture lisible");
    let mut sink = CollectingSink::default();
    let summary = GoogleImporter.parse(&mut file, &mut sink, options)?;
    Ok((summary, sink))
}

/// Comparaison de flottants tolérante — les variantes E7 et degrés ne
/// produisent pas le même dernier ulp.
#[track_caller]
pub fn assert_close(actual: f64, expected: f64) {
    assert!(
        (actual - expected).abs() < 1e-9,
        "attendu {expected}, obtenu {actual}"
    );
}
