//! Variantes de coordonnées (§5.1) : E7, `geo:`, degrés, `latLng`.
//!
//! Les quatre fixtures encodent exactement les mêmes deux visites : la
//! normalisation doit produire une sortie identique.

mod common;

use common::{assert_close, parse};

const VARIANTES: [&str; 4] = [
    "coords_degrees.json",
    "coords_geo_uri.json",
    "coords_e7.json",
    "coords_lat_lng_object.json",
];

#[test]
fn les_quatre_variantes_donnent_les_memes_coordonnees() {
    for fixture in VARIANTES {
        let (summary, sink) = parse(fixture).unwrap_or_else(|e| panic!("{fixture} : {e:?}"));

        assert_eq!(summary.visit_count, 2, "{fixture}");
        assert_eq!(summary.skipped_count, 0, "{fixture}");

        assert_close(sink.visits[0].lat, 48.8584);
        assert_close(sink.visits[0].lon, 2.2945);
        assert_close(sink.visits[1].lat, -33.4489);
        assert_close(sink.visits[1].lon, -70.6693);
    }
}

#[test]
fn les_quatre_variantes_donnent_les_memes_horodatages() {
    for fixture in VARIANTES {
        let (_, sink) = parse(fixture).unwrap();
        assert_eq!(sink.visits[0].arrival_tz_offset_minutes, 0, "{fixture}");
        assert_eq!(
            sink.visits[1].arrival_ts_utc - sink.visits[0].arrival_ts_utc,
            2 * 3_600_000,
            "{fixture}"
        );
    }
}

#[test]
fn les_quatre_variantes_sont_bit_a_bit_identiques() {
    let reference = parse(VARIANTES[0]).unwrap().1;
    for fixture in &VARIANTES[1..] {
        let (_, sink) = parse(fixture).unwrap();
        for (a, b) in reference.visits.iter().zip(sink.visits.iter()) {
            assert_close(a.lat, b.lat);
            assert_close(a.lon, b.lon);
            assert_eq!(a.arrival_ts_utc, b.arrival_ts_utc, "{fixture}");
        }
    }
}
