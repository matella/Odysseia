#![allow(dead_code)]

//! Helpers partagés par les tests d'intégration.

use chrono::TimeZone;
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

// ---------------------------------------------------------------------------
// Constructeurs pour les tests de pipeline (§5)
// ---------------------------------------------------------------------------

use timeline_core::model::{
    LocalDate, PrivateZone, RawPoint, Segment, SourceKind, TravelMode, UserPlace,
    UserSegmentOverride, Visit, ZoneShape,
};

/// Millisecondes UTC pour une date/heure.
pub fn utc(y: i32, mo: u32, d: u32, h: u32, mi: u32) -> i64 {
    chrono::Utc
        .with_ymd_and_hms(y, mo, d, h, mi, 0)
        .unwrap()
        .timestamp_millis()
}

/// Segment de test.
pub fn segment(
    start_ts_utc: i64,
    end_ts_utc: i64,
    start: (f64, f64),
    end: (f64, f64),
    detected_mode: TravelMode,
) -> Segment {
    Segment {
        start_ts_utc,
        start_tz_offset_minutes: 60,
        end_ts_utc,
        end_tz_offset_minutes: 60,
        start_lat: start.0,
        start_lon: start.1,
        end_lat: end.0,
        end_lon: end.1,
        distance_m: Some(3210.5),
        detected_mode,
        mode_confidence: Some(0.8),
        source_kind: SourceKind::GoogleTimeline,
    }
}

/// Visite de test.
pub fn visit(arrival_ts_utc: i64, departure_ts_utc: i64, at: (f64, f64)) -> Visit {
    Visit {
        arrival_ts_utc,
        arrival_tz_offset_minutes: 60,
        departure_ts_utc,
        departure_tz_offset_minutes: 60,
        lat: at.0,
        lon: at.1,
        radius_m: Some(50.0),
        external_place_ref: None,
        detection_confidence: Some(0.9),
        source_kind: SourceKind::GoogleTimeline,
    }
}

/// Position brute de test.
pub fn point(timestamp_utc: i64, at: (f64, f64)) -> RawPoint {
    RawPoint {
        timestamp_utc,
        tz_offset_minutes: 60,
        lat: at.0,
        lon: at.1,
        accuracy_m: None,
        altitude_m: None,
        speed_ms: None,
        source_kind: SourceKind::GoogleTimeline,
    }
}

/// Lieu nommé par l'utilisateur.
pub fn user_place(id: i64, label: &str, at: (f64, f64), radius_m: f64) -> UserPlace {
    UserPlace {
        id,
        label: label.to_string(),
        lat: at.0,
        lon: at.1,
        radius_m,
    }
}

/// Zone privée circulaire.
pub fn private_circle(id: i64, label: &str, at: (f64, f64), radius_m: f64) -> PrivateZone {
    PrivateZone {
        id,
        label: label.to_string(),
        shape: ZoneShape::Circle {
            lat: at.0,
            lon: at.1,
            radius_m,
        },
    }
}

/// Correction de mode, telle que l'app la fabriquerait depuis un segment
/// affiché : empreinte tolérante dérivée du segment corrigé (§4).
pub fn override_from(id: i64, source: &Segment, corrected_mode: TravelMode) -> UserSegmentOverride {
    UserSegmentOverride {
        id,
        local_date: LocalDate::from_utc_millis(source.start_ts_utc, source.start_tz_offset_minutes),
        start_lat_r: UserSegmentOverride::round_coord(source.start_lat),
        start_lon_r: UserSegmentOverride::round_coord(source.start_lon),
        end_lat_r: UserSegmentOverride::round_coord(source.end_lat),
        end_lon_r: UserSegmentOverride::round_coord(source.end_lon),
        corrected_mode,
        source_start_ts_utc: source.start_ts_utc,
    }
}
