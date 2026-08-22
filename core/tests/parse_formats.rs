//! Les deux formats d'export Google (§5.1) : legacy `semanticSegments` et
//! tableau direct.

mod common;

use chrono::{TimeZone, Utc};
use common::{assert_close, parse};
use timeline_core::model::{SourceFormat, SourceKind, TravelMode};

fn millis(y: i32, mo: u32, d: u32, h: u32, mi: u32) -> i64 {
    Utc.with_ymd_and_hms(y, mo, d, h, mi, 0)
        .unwrap()
        .timestamp_millis()
}

#[test]
fn direct_array_detecte_le_format() {
    let (summary, _) = parse("google_direct_array.json").unwrap();
    assert_eq!(summary.format, SourceFormat::GoogleDirectArray);
    assert_eq!(summary.source_kind, SourceKind::GoogleTimeline);
}

#[test]
fn direct_array_emet_visite_segment_et_points() {
    let (summary, sink) = parse("google_direct_array.json").unwrap();

    assert_eq!(summary.visit_count, 1);
    assert_eq!(summary.segment_count, 1);
    assert_eq!(summary.point_count, 3);
    assert_eq!(summary.skipped_count, 0);

    let visit = &sink.visits[0];
    assert_eq!(visit.arrival_ts_utc, millis(2024, 3, 15, 7, 12));
    assert_eq!(visit.departure_ts_utc, millis(2024, 3, 15, 8, 5));
    assert_eq!(visit.arrival_tz_offset_minutes, 60);
    assert_close(visit.lat, 48.8584);
    assert_close(visit.lon, 2.2945);
    assert_eq!(
        visit.external_place_ref.as_deref(),
        Some("ChIJD7fiBh9u5kcRYJSMaMOCCwQ")
    );
    assert_eq!(visit.detection_confidence, Some(0.94));

    let segment = &sink.segments[0];
    assert_eq!(segment.detected_mode, TravelMode::Walking);
    assert_eq!(segment.mode_confidence, Some(0.78));
    assert_eq!(segment.distance_m, Some(3210.5));
    assert_close(segment.start_lat, 48.8584);
    assert_close(segment.end_lon, 2.3376);

    // timelinePath : horodatage = startTime + offset en minutes.
    assert_eq!(sink.points[0].timestamp_utc, millis(2024, 3, 15, 9, 0));
    assert_eq!(sink.points[1].timestamp_utc, millis(2024, 3, 15, 9, 2));
    assert_eq!(sink.points[2].timestamp_utc, millis(2024, 3, 15, 9, 4));
    assert_eq!(sink.points[0].tz_offset_minutes, 60);
    assert_close(sink.points[2].lat, 48.8635);
}

#[test]
fn semantic_segments_detecte_le_format() {
    let (summary, _) = parse("google_semantic_segments.json").unwrap();
    assert_eq!(summary.format, SourceFormat::GoogleSemanticSegments);
}

#[test]
fn semantic_segments_ignore_les_cles_soeurs_inconnues() {
    // `rawSignals` et `userLocationProfile` ne doivent produire aucun
    // enregistrement ni faire échouer l'import.
    let (summary, sink) = parse("google_semantic_segments.json").unwrap();
    assert_eq!(summary.visit_count, 1);
    assert_eq!(summary.segment_count, 1);
    assert_eq!(summary.point_count, 0);
    assert_eq!(summary.skipped_count, 0);
    assert_eq!(sink.visits.len(), 1);
}

#[test]
fn semantic_segments_conserve_offset_negatif_et_mode() {
    let (_, sink) = parse("google_semantic_segments.json").unwrap();

    let visit = &sink.visits[0];
    assert_eq!(visit.arrival_tz_offset_minutes, -300);
    assert_eq!(visit.arrival_ts_utc, millis(2013, 11, 1, 12, 30));
    assert_close(visit.lon, -73.9857);

    // Le mode est reconnu quelle que soit la casse de la valeur Google.
    assert_eq!(sink.segments[0].detected_mode, TravelMode::InVehicle);
    assert_eq!(sink.segments[0].distance_m, Some(5120.0));
}

#[test]
fn periode_couverte_calculee_sur_tous_les_enregistrements() {
    let (summary, _) = parse("google_direct_array.json").unwrap();
    // Du début de la visite à la fin du dernier point de trajectoire.
    assert_eq!(summary.period_start_utc, Some(millis(2024, 3, 15, 7, 12)));
    assert_eq!(summary.period_end_utc, Some(millis(2024, 3, 15, 9, 4)));
}

#[test]
fn source_kind_est_porte_par_chaque_enregistrement() {
    // §3.1 : le modèle n'est pas calqué sur Google, chaque enregistrement
    // sait d'où il vient.
    let (_, sink) = parse("google_direct_array.json").unwrap();
    assert!(
        sink.points
            .iter()
            .all(|p| p.source_kind == SourceKind::GoogleTimeline)
    );
    assert!(
        sink.visits
            .iter()
            .all(|v| v.source_kind == SourceKind::GoogleTimeline)
    );
    assert!(
        sink.segments
            .iter()
            .all(|s| s.source_kind == SourceKind::GoogleTimeline)
    );
}
