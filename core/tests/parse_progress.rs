//! Remontée de progression pendant l'import (§4) : pourcentage + étape.

mod common;

use common::fixture;
use std::fs::File;
use timeline_core::model::{RawPoint, Segment, Visit};
use timeline_core::parse::{
    ImportStep, ParseOptions, Progress, RecordSink, TimelineImporter, google::GoogleImporter,
};

#[derive(Default)]
struct ProgressSink {
    updates: Vec<Progress>,
}

impl RecordSink for ProgressSink {
    fn point(&mut self, _: RawPoint) {}
    fn segment(&mut self, _: Segment) {}
    fn visit(&mut self, _: Visit) {}
    fn progress(&mut self, update: Progress) {
        self.updates.push(update);
    }
}

fn run(name: &str, options: &ParseOptions) -> ProgressSink {
    let mut file = File::open(fixture(name)).unwrap();
    let mut sink = ProgressSink::default();
    GoogleImporter
        .parse(&mut file, &mut sink, options)
        .expect("import réussi");
    sink
}

#[test]
fn la_progression_est_remontee_avec_une_etape() {
    let options = ParseOptions {
        progress_every: 1,
        ..ParseOptions::default()
    };
    let sink = run("google_direct_array.json", &options);

    assert!(!sink.updates.is_empty());
    assert_eq!(sink.updates.last().unwrap().step, ImportStep::Done);
    assert!(
        sink.updates
            .iter()
            .any(|u| u.step == ImportStep::ReadingRecords)
    );
}

#[test]
fn les_octets_lus_sont_croissants() {
    let options = ParseOptions {
        progress_every: 1,
        ..ParseOptions::default()
    };
    let sink = run("google_direct_array.json", &options);
    let mut previous = 0;
    for update in &sink.updates {
        assert!(update.bytes_read >= previous);
        previous = update.bytes_read;
    }
}

#[test]
fn le_pourcentage_exige_une_taille_totale() {
    let taille = std::fs::metadata(fixture("google_direct_array.json"))
        .unwrap()
        .len();

    let sans_indice = run("google_direct_array.json", &ParseOptions::default());
    assert!(sans_indice.updates.last().unwrap().percent().is_none());

    let options = ParseOptions {
        total_bytes_hint: Some(taille),
        ..ParseOptions::default()
    };
    let avec_indice = run("google_direct_array.json", &options);
    let fin = avec_indice.updates.last().unwrap().percent().unwrap();
    assert!((99.0..=100.0).contains(&fin), "pourcentage final {fin}");
}
