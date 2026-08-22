//! Cas limites (§3.10) : export vide, JSON corrompu, format futur non
//! reconnu, ligne de changement de date, fichier trop volumineux.
//!
//! Chaque cas a son type d'erreur dédié — jamais d'erreur générique — pour que
//! l'UI puisse afficher un message spécifique et traduit.

mod common;

use common::{assert_close, parse, parse_with};
use timeline_core::error::{CoordError, ParseError, RecordError};
use timeline_core::parse::ParseOptions;

#[test]
fn export_vide_tableau_direct() {
    assert!(matches!(
        parse("empty_direct_array.json"),
        Err(ParseError::EmptyExport)
    ));
}

#[test]
fn export_vide_semantic_segments() {
    assert!(matches!(
        parse("empty_semantic_segments.json"),
        Err(ParseError::EmptyExport)
    ));
}

#[test]
fn fichier_de_zero_octet() {
    // Un fichier vide est un export vide, pas un JSON corrompu : le message
    // utilisateur « votre export ne contient aucune donnée » est plus juste.
    assert!(matches!(
        parse("empty_file.json"),
        Err(ParseError::EmptyExport)
    ));
}

#[test]
fn fichier_blanc() {
    assert!(matches!(
        parse("whitespace_only.json"),
        Err(ParseError::EmptyExport)
    ));
}

#[test]
fn json_tronque() {
    let err = parse("corrupt_truncated.json").unwrap_err();
    match err {
        ParseError::CorruptJson { line, .. } => assert!(line > 0),
        other => panic!("attendu CorruptJson, obtenu {other:?}"),
    }
}

#[test]
fn jeton_json_invalide() {
    assert!(matches!(
        parse("corrupt_invalid_token.json"),
        Err(ParseError::CorruptJson { .. })
    ));
}

#[test]
fn format_futur_non_reconnu() {
    // JSON valide, structure inconnue : ni tableau direct, ni semanticSegments.
    match parse("future_format.json").unwrap_err() {
        ParseError::UnrecognisedFormat { found } => {
            // Les clés rencontrées sont remontées pour rendre le cas diagnosticable.
            assert!(found.iter().any(|k| k == "timelineSchemaVersion"));
        }
        other => panic!("attendu UnrecognisedFormat, obtenu {other:?}"),
    }
}

#[test]
fn scalaire_au_premier_niveau() {
    assert!(matches!(
        parse("future_format_scalar.json"),
        Err(ParseError::UnrecognisedFormat { .. })
    ));
}

#[test]
fn fichier_trop_volumineux() {
    // §4 : la limite est une politique de l'appelant (500 Mo natif,
    // avertissement ~200 Mo en web) — le core l'applique, il ne la choisit pas.
    let options = ParseOptions {
        max_bytes: Some(64),
        ..ParseOptions::default()
    };
    match parse_with("google_direct_array.json", &options).unwrap_err() {
        ParseError::FileTooLarge { limit_bytes, .. } => assert_eq!(limit_bytes, 64),
        other => panic!("attendu FileTooLarge, obtenu {other:?}"),
    }
}

#[test]
fn ligne_de_changement_de_date_preservee() {
    let (summary, sink) = parse("dateline.json").unwrap();
    assert_eq!(summary.skipped_count, 0);

    // Longitudes de part et d'autre de l'antiméridien : aucune normalisation
    // parasite, aucun repliement.
    assert_close(sink.visits[0].lon, 179.9999);
    assert_close(sink.segments[0].start_lon, 179.95);
    assert_close(sink.segments[0].end_lon, -170.1322);

    // Le segment traverse la ligne de date : offsets de part et d'autre.
    assert_eq!(sink.segments[0].start_tz_offset_minutes, 720);
    assert_eq!(sink.segments[0].end_tz_offset_minutes, -660);
    assert!(sink.segments[0].end_ts_utc > sink.segments[0].start_ts_utc);
}

#[test]
fn bornes_de_coordonnees_acceptees() {
    let (_, sink) = parse("dateline.json").unwrap();
    assert_close(sink.points[0].lat, -90.0);
    assert_close(sink.points[0].lon, -180.0);
    assert_close(sink.points[1].lat, 90.0);
    assert_close(sink.points[1].lon, 180.0);
}

#[test]
fn enregistrements_invalides_ignores_sans_perdre_les_valides() {
    // Un enregistrement corrompu ne doit pas faire échouer tout l'import :
    // §3.10 « jamais de crash visible ». Les rejets sont comptés et
    // remontés, pas silencieux.
    let (summary, sink) = parse("mixed_invalid_records.json").unwrap();

    assert_eq!(summary.visit_count, 2);
    assert_eq!(summary.skipped_count, 3);
    assert_close(sink.visits[0].lat, 48.8584);
    assert_close(sink.visits[1].lat, 45.7640);

    let raisons: Vec<&RecordError> = sink.skipped.iter().map(|s| &s.error).collect();
    assert!(
        raisons
            .iter()
            .any(|e| matches!(e, RecordError::Coord(CoordError::LatitudeOutOfRange(_))))
    );
    assert!(raisons.iter().any(|e| matches!(e, RecordError::Time(_))));
    assert!(
        raisons
            .iter()
            .any(|e| matches!(e, RecordError::UnknownShape))
    );
}

#[test]
fn index_de_lenregistrement_rejete_est_remonte() {
    let (_, sink) = parse("mixed_invalid_records.json").unwrap();
    assert_eq!(sink.skipped[0].index, 1);
    assert_eq!(sink.skipped[1].index, 2);
    assert_eq!(sink.skipped[2].index, 3);
}
