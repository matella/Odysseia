//! La garantie centrale du schéma (§5.2) : **un ré-import n'efface rien de ce
//! que l'utilisateur a produit**.
//!
//! Un ré-import vide et reconstruit toute la zone §5.1 — nouveaux
//! identifiants, bornes de segments légèrement différentes, journées parfois
//! absentes. Les tests ci-dessous rejouent ce scénario et vérifient que les
//! lieux nommés, les zones privées et les corrections de mode continuent de
//! s'appliquer **aux nouvelles données**, sans qu'aucune d'elles n'ait jamais
//! référencé un identifiant de la zone importée.
//!
//! La survie des *lignes* en base est vérifiée côté Dart
//! (`app/test/data/reimport_test.dart`) ; ici on vérifie la survie du *sens* :
//! après ré-import, la correction retrouve son trajet.

mod common;

use common::{override_from, private_circle, segment, user_place, utc, visit};
use timeline_core::model::TravelMode;
use timeline_core::pipeline::places::{NoPlaceLookup, PlaceSource};
use timeline_core::pipeline::{Pipeline, ViewFilters};

/// Coordonnées utilisées par les deux imports.
const MAISON: (f64, f64) = (48.8584, 2.2945);
const BUREAU: (f64, f64) = (48.8606, 2.3376);
const MARSEILLE: (f64, f64) = (43.2965, 5.3698);
const LYON: (f64, f64) = (45.7640, 4.8357);

/// Premier export : le trajet tel que Google l'a découpé la première fois.
fn import_initial() -> Vec<timeline_core::model::Segment> {
    vec![
        segment(
            utc(2024, 3, 15, 8, 5),
            utc(2024, 3, 15, 8, 41),
            MAISON,
            BUREAU,
            TravelMode::Walking,
        ),
        segment(
            utc(2024, 3, 16, 10, 0),
            utc(2024, 3, 16, 11, 0),
            LYON,
            MARSEILLE,
            TravelMode::InVehicle,
        ),
    ]
}

/// Second export : **le même trajet, redécoupé**.
///
/// Google ne garantit pas la stabilité de son découpage (§3.1) : les bornes
/// ont bougé de quelques minutes et les extrémités de quelques dizaines de
/// mètres. C'est précisément le cas que l'empreinte tolérante doit encaisser
/// (§4).
fn import_apres_redecoupage() -> Vec<timeline_core::model::Segment> {
    vec![
        segment(
            utc(2024, 3, 15, 8, 2),
            utc(2024, 3, 15, 8, 45),
            (48.8586, 2.2949),
            (48.8601, 2.3372),
            TravelMode::Walking,
        ),
        segment(
            utc(2024, 3, 16, 10, 0),
            utc(2024, 3, 16, 11, 0),
            LYON,
            MARSEILLE,
            TravelMode::InVehicle,
        ),
    ]
}

#[test]
fn la_correction_de_mode_survit_au_redecoupage() {
    let avant = import_initial();
    // L'utilisateur corrige le trajet domicile-bureau : à vélo, pas à pied.
    let corrections = [override_from(1, &avant[0], TravelMode::Cycling)];
    let filters = ViewFilters::default();

    // Avant ré-import : la correction s'applique.
    let pipeline = Pipeline::new(&[], &[], &corrections, &NoPlaceLookup, &filters);
    let batch = pipeline.segments(&avant);
    assert_eq!(batch.segments[0].mode, TravelMode::Cycling);
    assert!(batch.segments[0].corrected);

    // Ré-import : identifiants perdus, bornes déplacées, coordonnées jitterées.
    let apres = import_apres_redecoupage();
    let batch = pipeline.segments(&apres);

    assert_eq!(
        batch.segments[0].mode,
        TravelMode::Cycling,
        "la correction doit retrouver son trajet malgré le redécoupage (§4)"
    );
    assert!(batch.segments[0].corrected);
    assert!(batch.orphan_override_ids.is_empty());
}

#[test]
fn la_correction_ne_deborde_pas_sur_un_autre_trajet() {
    let apres = import_apres_redecoupage();
    let corrections = [override_from(1, &import_initial()[0], TravelMode::Cycling)];
    let filters = ViewFilters::default();
    let pipeline = Pipeline::new(&[], &[], &corrections, &NoPlaceLookup, &filters);

    let batch = pipeline.segments(&apres);
    assert_eq!(batch.segments[1].mode, TravelMode::InVehicle);
    assert!(!batch.segments[1].corrected);
}

#[test]
fn le_mode_detecte_nest_jamais_ecrase() {
    // §5.1 : `detected_mode` garde toujours sa valeur d'origine ; la
    // correction vit à côté et n'est appliquée qu'à la lecture.
    let segments = import_initial();
    let corrections = [override_from(1, &segments[0], TravelMode::Cycling)];
    let filters = ViewFilters::default();
    let pipeline = Pipeline::new(&[], &[], &corrections, &NoPlaceLookup, &filters);

    let batch = pipeline.segments(&segments);
    assert_eq!(batch.segments[0].mode, TravelMode::Cycling);
    assert_eq!(
        batch.segments[0].segment.detected_mode,
        TravelMode::Walking,
        "la détection importée doit rester intacte"
    );
}

#[test]
fn une_correction_orpheline_est_conservee_inactive() {
    // Export plus court : la journée du 16 a disparu. §4 interdit de supprimer
    // la correction — elle est simplement inactive, et se réactivera si un
    // import futur ramène le trajet.
    let initial = import_initial();
    let corrections = [
        override_from(1, &initial[0], TravelMode::Cycling),
        override_from(2, &initial[1], TravelMode::InTrain),
    ];
    let filters = ViewFilters::default();
    let pipeline = Pipeline::new(&[], &[], &corrections, &NoPlaceLookup, &filters);

    let export_court = vec![initial[0].clone()];
    let batch = pipeline.segments(&export_court);

    assert_eq!(batch.segments.len(), 1);
    assert_eq!(batch.orphan_override_ids, vec![2]);
}

#[test]
fn une_correction_orpheline_se_reactive_au_retour_du_trajet() {
    let initial = import_initial();
    let corrections = [override_from(2, &initial[1], TravelMode::InTrain)];
    let filters = ViewFilters::default();
    let pipeline = Pipeline::new(&[], &[], &corrections, &NoPlaceLookup, &filters);

    assert_eq!(
        pipeline.segments(&[initial[0].clone()]).orphan_override_ids,
        vec![2]
    );

    let retour = pipeline.segments(&import_apres_redecoupage());
    assert!(retour.orphan_override_ids.is_empty());
    assert_eq!(retour.segments[1].mode, TravelMode::InTrain);
}

#[test]
fn le_lieu_nomme_survit_au_reimport() {
    let places = [user_place(1, "Maison", MAISON, 200.0)];
    let filters = ViewFilters::default();
    let pipeline = Pipeline::new(&[], &places, &[], &NoPlaceLookup, &filters);

    // Deux imports successifs produisent des visites différentes au même
    // endroit : le rattachement est géographique, pas par identifiant (§5.2).
    let premiere = visit(utc(2024, 3, 15, 7, 12), utc(2024, 3, 15, 8, 5), MAISON);
    let seconde = visit(
        utc(2024, 3, 20, 6, 40),
        utc(2024, 3, 20, 7, 55),
        (48.8585, 2.2946),
    );

    for candidate in [premiere, seconde] {
        let resolved = pipeline.visit(&candidate).expect("visite conservée");
        assert_eq!(resolved.place.label.as_deref(), Some("Maison"));
        assert_eq!(resolved.place.source, PlaceSource::UserPlace { id: 1 });
    }
}

#[test]
fn la_zone_privee_survit_au_reimport() {
    let zones = [private_circle(1, "Chez mes parents", MARSEILLE, 1_000.0)];
    let filters = ViewFilters::default();
    let pipeline = Pipeline::new(&zones, &[], &[], &NoPlaceLookup, &filters);

    // Une visite au même endroit, importée à deux dates différentes, reste
    // exclue les deux fois.
    let premiere = visit(utc(2024, 3, 16, 12, 0), utc(2024, 3, 16, 14, 0), MARSEILLE);
    let seconde = visit(
        utc(2024, 8, 2, 12, 0),
        utc(2024, 8, 2, 14, 0),
        (43.2970, 5.3701),
    );

    assert!(pipeline.visit(&premiere).is_none());
    assert!(pipeline.visit(&seconde).is_none());
}

#[test]
fn les_trois_zones_utilisateur_cohabitent_apres_reimport() {
    // Scénario complet : lieu nommé + zone privée + correction, appliqués aux
    // données d'un second import qui ne partage aucun identifiant avec le
    // premier.
    let initial = import_initial();
    let places = [user_place(1, "Maison", MAISON, 200.0)];
    let zones = [private_circle(1, "Chez mes parents", MARSEILLE, 1_000.0)];
    let corrections = [override_from(1, &initial[0], TravelMode::Cycling)];
    let filters = ViewFilters::default();

    let pipeline = Pipeline::new(&zones, &places, &corrections, &NoPlaceLookup, &filters);
    let batch = pipeline.segments(&import_apres_redecoupage());

    // Le trajet vers Marseille finit dans une zone privée : écarté à la source.
    assert_eq!(batch.segments.len(), 1, "le trajet privé doit disparaître");
    assert_eq!(batch.segments[0].mode, TravelMode::Cycling);
    assert_eq!(
        batch.segments[0].start_place.label.as_deref(),
        Some("Maison")
    );
}
