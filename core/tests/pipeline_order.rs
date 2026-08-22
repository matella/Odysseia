//! L'ordre des étapes du pipeline (§5.4) et ce qu'il garantit.
//!
//! 1. zones privées → 2. noms de lieux → 3. corrections → 4. filtres de vue.
//!
//! L'ordre n'est pas cosmétique : il détermine ce qu'une vue peut observer.
//! Ces tests échouent si une étape passe devant une autre.

mod common;

use common::{override_from, point, private_circle, segment, user_place, utc, visit};
use timeline_core::model::TravelMode;
use timeline_core::pipeline::places::NoPlaceLookup;
use timeline_core::pipeline::{Period, Pipeline, PlaceFilter, ViewFilters};

const MAISON: (f64, f64) = (48.8584, 2.2945);
const BUREAU: (f64, f64) = (48.8606, 2.3376);
const SECRET: (f64, f64) = (43.2965, 5.3698);

#[test]
fn etape_1_une_position_privee_est_absente_pas_masquee() {
    // §3.7 : absente des stats, des frames et de l'export — pas `opacity: 0`.
    let zones = [private_circle(1, "Secret", SECRET, 1_000.0)];
    let filters = ViewFilters::default();
    let pipeline = Pipeline::new(&zones, &[], &[], &NoPlaceLookup, &filters);

    let points = [
        point(utc(2024, 3, 15, 8, 0), MAISON),
        point(utc(2024, 3, 15, 9, 0), SECRET),
        point(utc(2024, 3, 15, 10, 0), BUREAU),
    ];

    let kept = pipeline.points(&points);
    assert_eq!(kept.len(), 2);
    assert!(kept.iter().all(|resolved| resolved.point.lat != SECRET.0));
}

#[test]
fn etape_1_un_trajet_qui_touche_une_zone_privee_disparait() {
    // Conserver le trajet publierait l'extrémité que l'utilisateur cache.
    let zones = [private_circle(1, "Secret", SECRET, 1_000.0)];
    let filters = ViewFilters::default();
    let pipeline = Pipeline::new(&zones, &[], &[], &NoPlaceLookup, &filters);

    let segments = [segment(
        utc(2024, 3, 15, 8, 0),
        utc(2024, 3, 15, 12, 0),
        MAISON,
        SECRET,
        TravelMode::InVehicle,
    )];

    assert!(pipeline.segments(&segments).segments.is_empty());
}

#[test]
fn etape_1_precede_le_filtre_de_periode() {
    // Même si la vue demande explicitement cette journée, la donnée privée ne
    // remonte pas : l'étape 1 a déjà tranché.
    let zones = [private_circle(1, "Secret", SECRET, 1_000.0)];
    let filters = ViewFilters {
        period: Some(Period {
            start_utc: utc(2024, 3, 15, 0, 0),
            end_utc: utc(2024, 3, 15, 23, 59),
        }),
        ..ViewFilters::default()
    };
    let pipeline = Pipeline::new(&zones, &[], &[], &NoPlaceLookup, &filters);

    let prive = visit(utc(2024, 3, 15, 9, 0), utc(2024, 3, 15, 11, 0), SECRET);
    assert!(pipeline.visit(&prive).is_none());
}

#[test]
fn etape_3_precede_le_filtre_de_mode() {
    // Filtrer « à vélo » doit ramener le trajet corrigé en vélo, alors que la
    // détection dit « à pied ». Si le filtre passait avant la correction, ce
    // trajet serait perdu.
    let segments = [segment(
        utc(2024, 3, 15, 8, 5),
        utc(2024, 3, 15, 8, 41),
        MAISON,
        BUREAU,
        TravelMode::Walking,
    )];
    let corrections = [override_from(1, &segments[0], TravelMode::Cycling)];
    let filters = ViewFilters {
        modes: Some(vec![TravelMode::Cycling]),
        ..ViewFilters::default()
    };
    let pipeline = Pipeline::new(&[], &[], &corrections, &NoPlaceLookup, &filters);

    let batch = pipeline.segments(&segments);
    assert_eq!(batch.segments.len(), 1);
    assert_eq!(batch.segments[0].mode, TravelMode::Cycling);
}

#[test]
fn etape_3_le_filtre_de_mode_ecarte_la_detection_corrigee() {
    // Réciproque : filtrer « à pied » ne doit PAS ramener un trajet que
    // l'utilisateur a corrigé en vélo.
    let segments = [segment(
        utc(2024, 3, 15, 8, 5),
        utc(2024, 3, 15, 8, 41),
        MAISON,
        BUREAU,
        TravelMode::Walking,
    )];
    let corrections = [override_from(1, &segments[0], TravelMode::Cycling)];
    let filters = ViewFilters {
        modes: Some(vec![TravelMode::Walking]),
        ..ViewFilters::default()
    };
    let pipeline = Pipeline::new(&[], &[], &corrections, &NoPlaceLookup, &filters);

    assert!(pipeline.segments(&segments).segments.is_empty());
}

#[test]
fn etape_2_precede_le_filtre_de_lieu() {
    // Le filtre porte sur le lieu *résolu* : on filtre « Maison », pas des
    // coordonnées.
    let places = [user_place(7, "Maison", MAISON, 200.0)];
    let filters = ViewFilters {
        place: Some(PlaceFilter::UserPlace(7)),
        ..ViewFilters::default()
    };
    let pipeline = Pipeline::new(&[], &places, &[], &NoPlaceLookup, &filters);

    let chez_soi = visit(utc(2024, 3, 15, 7, 0), utc(2024, 3, 15, 8, 0), MAISON);
    let ailleurs = visit(utc(2024, 3, 15, 9, 0), utc(2024, 3, 15, 17, 0), BUREAU);

    assert!(pipeline.visit(&chez_soi).is_some());
    assert!(pipeline.visit(&ailleurs).is_none());
}

#[test]
fn etape_4_les_filtres_sont_combinables() {
    // §3.4 : période + lieu + mode se combinent.
    let places = [user_place(7, "Maison", MAISON, 200.0)];
    let segments = [
        segment(
            utc(2024, 3, 15, 8, 5),
            utc(2024, 3, 15, 8, 41),
            MAISON,
            BUREAU,
            TravelMode::Cycling,
        ),
        segment(
            utc(2024, 3, 15, 18, 0),
            utc(2024, 3, 15, 18, 40),
            BUREAU,
            MAISON,
            TravelMode::Walking,
        ),
        segment(
            utc(2024, 3, 20, 8, 5),
            utc(2024, 3, 20, 8, 41),
            MAISON,
            BUREAU,
            TravelMode::Cycling,
        ),
    ];
    let filters = ViewFilters {
        period: Some(Period {
            start_utc: utc(2024, 3, 15, 0, 0),
            end_utc: utc(2024, 3, 15, 23, 59),
        }),
        place: Some(PlaceFilter::UserPlace(7)),
        modes: Some(vec![TravelMode::Cycling]),
    };
    let pipeline = Pipeline::new(&[], &places, &[], &NoPlaceLookup, &filters);

    let batch = pipeline.segments(&segments);
    assert_eq!(batch.segments.len(), 1);
    assert_eq!(
        batch.segments[0].start_ts_utc_for_test(),
        utc(2024, 3, 15, 8, 5)
    );
}

#[test]
fn sans_filtre_rien_nest_ecarte() {
    let filters = ViewFilters::default();
    let pipeline = Pipeline::new(&[], &[], &[], &NoPlaceLookup, &filters);

    let points = [
        point(utc(2024, 3, 15, 8, 0), MAISON),
        point(utc(2024, 3, 15, 9, 0), SECRET),
    ];
    assert_eq!(pipeline.points(&points).len(), 2);
}

#[test]
fn le_filtre_de_mode_ne_sapplique_pas_aux_visites() {
    // Décision documentée : un arrêt n'a pas de mode de transport, le filtrer
    // par mode viderait la vue Récit au lieu de la restreindre.
    let filters = ViewFilters {
        modes: Some(vec![TravelMode::Cycling]),
        ..ViewFilters::default()
    };
    let pipeline = Pipeline::new(&[], &[], &[], &NoPlaceLookup, &filters);

    let arret = visit(utc(2024, 3, 15, 7, 0), utc(2024, 3, 15, 8, 0), MAISON);
    assert!(pipeline.visit(&arret).is_some());
}

/// Petit confort de lecture pour les assertions ci-dessus.
trait SegmentStart {
    fn start_ts_utc_for_test(&self) -> i64;
}

impl SegmentStart for timeline_core::pipeline::ResolvedSegment {
    fn start_ts_utc_for_test(&self) -> i64 {
        self.segment.start_ts_utc
    }
}
