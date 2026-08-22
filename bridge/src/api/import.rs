//! Import d'un export Timeline (§3.1, §4).
//!
//! # Streaming de bout en bout
//!
//! Le fichier n'est jamais chargé en entier, **ni côté Rust, ni côté Dart** :
//! le parseur pousse des lots au fil de la lecture, envoyés à Dart par un
//! `StreamSink`, et Dart les insère par transactions groupées (§4). Un export
//! de 500 Mo ne fait donc jamais grossir la mémoire au-delà d'un lot.
//!
//! Renvoyer un `Vec` de tous les enregistrements aurait été plus simple à
//! écrire et aurait annulé tout le travail de streaming du parseur.
//!
//! # Ce qui n'est pas ici
//!
//! L'insertion en base, l'archivage du fichier source (§3.2) et
//! l'avertissement de période plus courte (§4) appartiennent à l'appelant :
//! ce sont des décisions de stockage et d'UI, pas de parsing.

use std::fs::File;

use crate::frb_generated::StreamSink;
use timeline_core::error::ParseError;
use timeline_core::model::{
    RawPoint as CoreRawPoint, Segment as CoreSegment, SourceFormat, Visit as CoreVisit,
};
use timeline_core::parse::google::GoogleImporter;
use timeline_core::parse::{
    ImportStep, ParseOptions, Progress as CoreProgress, RecordSink, TimelineImporter,
};

use super::timeline::mode_key;

/// Nombre d'enregistrements par lot envoyé à Dart.
///
/// Compromis : assez gros pour que l'insertion se fasse par transactions
/// groupées (§4), assez petit pour que la mémoire reste bornée et la
/// progression fluide sur un export de 500 Mo.
const CHUNK_SIZE: usize = 2_000;

/// Position importée, avant insertion en base.
#[derive(Debug, Clone)]
pub struct ImportedPoint {
    /// Instant UTC, en millisecondes.
    pub timestamp_utc: i64,
    /// Décalage local, en minutes (§5.5).
    pub tz_offset_minutes: i32,
    /// Latitude.
    pub lat: f64,
    /// Longitude.
    pub lon: f64,
}

/// Arrêt importé, avant insertion en base.
#[derive(Debug, Clone)]
pub struct ImportedVisit {
    /// Arrivée, en millisecondes UTC.
    pub arrival_ts_utc: i64,
    /// Décalage local à l'arrivée.
    pub arrival_tz_offset_minutes: i32,
    /// Départ, en millisecondes UTC.
    pub departure_ts_utc: i64,
    /// Décalage local au départ.
    pub departure_tz_offset_minutes: i32,
    /// Latitude.
    pub lat: f64,
    /// Longitude.
    pub lon: f64,
    /// Rayon annoncé, en mètres.
    pub radius_m: Option<f64>,
    /// Identifiant de lieu propre à la source (§3.1).
    pub external_place_ref: Option<String>,
}

/// Trajet importé, avant insertion en base.
#[derive(Debug, Clone)]
pub struct ImportedSegment {
    /// Début, en millisecondes UTC.
    pub start_ts_utc: i64,
    /// Décalage local au départ.
    pub start_tz_offset_minutes: i32,
    /// Fin, en millisecondes UTC.
    pub end_ts_utc: i64,
    /// Décalage local à l'arrivée.
    pub end_tz_offset_minutes: i32,
    /// Latitude de départ.
    pub start_lat: f64,
    /// Longitude de départ.
    pub start_lon: f64,
    /// Latitude d'arrivée.
    pub end_lat: f64,
    /// Longitude d'arrivée.
    pub end_lon: f64,
    /// Distance annoncée, en mètres.
    pub distance_m: Option<f64>,
    /// Mode détecté — clé stable, traduite par l'UI (§3.9).
    pub detected_mode: String,
}

/// Lot d'enregistrements, envoyé au fil de la lecture.
#[derive(Debug, Clone, Default)]
pub struct ImportChunk {
    /// Positions du lot.
    pub points: Vec<ImportedPoint>,
    /// Arrêts du lot.
    pub visits: Vec<ImportedVisit>,
    /// Trajets du lot.
    pub segments: Vec<ImportedSegment>,
}

/// Étape en cours, affichée à l'utilisateur (§4).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ImportStepKind {
    /// Détection du format.
    DetectingFormat,
    /// Lecture des enregistrements.
    ReadingRecords,
    /// Lecture terminée.
    Done,
}

/// Progression, remontée au fil de la lecture (§4).
#[derive(Debug, Clone, Copy)]
pub struct ImportProgress {
    /// Étape en cours.
    pub step: ImportStepKind,
    /// Avancement, de 0 à 100, si la taille totale est connue.
    pub percent: Option<f64>,
    /// Enregistrements produits jusqu'ici.
    pub records: u32,
}

/// Cause d'échec (§3.10) — un cas, un variant, un message traduit.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ImportErrorKind {
    /// L'export ne contient aucune donnée.
    EmptyExport,
    /// Le fichier n'est pas du JSON valide.
    CorruptJson,
    /// Format inconnu — souvent une version future de Google Timeline.
    UnrecognisedFormat,
    /// Fichier au-delà de la limite fixée par l'appelant (§4).
    FileTooLarge,
    /// Échec de lecture.
    Io,
}

/// Bilan d'un import réussi — alimente `import_batch` (§5.1).
#[derive(Debug, Clone)]
pub struct ImportSummaryOutput {
    /// Format concret détecté.
    pub format: String,
    /// Début de la période couverte, en millisecondes UTC.
    pub period_start_utc: Option<i64>,
    /// Fin de la période couverte, en millisecondes UTC.
    ///
    /// Avec le début, permet d'avertir avant écrasement si le nouvel export
    /// couvre moins que l'actuel (§4).
    pub period_end_utc: Option<i64>,
    /// Nombre de positions.
    pub point_count: u32,
    /// Nombre de trajets.
    pub segment_count: u32,
    /// Nombre d'arrêts.
    pub visit_count: u32,
    /// Enregistrements ignorés — comptés, jamais silencieux (§3.10).
    pub skipped_count: u32,
    /// Octets lus.
    pub bytes_read: i64,
}

/// Événement émis pendant l'import.
#[derive(Debug, Clone)]
pub enum ImportEvent {
    /// Avancement.
    Progress(ImportProgress),
    /// Lot d'enregistrements à insérer.
    Chunk(ImportChunk),
    /// Import terminé.
    Finished(ImportSummaryOutput),
    /// Import échoué.
    Failed(ImportErrorKind),
}

/// Importe un export Timeline en streaming (§4).
///
/// `max_bytes` applique la limite de taille : la **politique** appartient à
/// l'appelant (500 Mo confortables en natif, avertissement au-delà de
/// ~200 Mo en web, §4), le cœur ne fait que l'appliquer.
pub fn import_timeline(path: String, max_bytes: Option<i64>, sink: StreamSink<ImportEvent>) {
    let Ok(mut file) = File::open(&path) else {
        let _ = sink.add(ImportEvent::Failed(ImportErrorKind::Io));
        return;
    };
    let total_bytes = file.metadata().ok().map(|meta| meta.len());

    let options = ParseOptions {
        max_bytes: max_bytes.map(|value| value as u64),
        total_bytes_hint: total_bytes,
        progress_every: CHUNK_SIZE as u64,
    };

    let mut streaming = StreamingSink::new(sink);
    let outcome = GoogleImporter.parse(&mut file, &mut streaming, &options);
    streaming.flush();

    let event = match outcome {
        Ok(summary) => ImportEvent::Finished(ImportSummaryOutput {
            format: match summary.format {
                SourceFormat::GoogleSemanticSegments => "google_semantic_segments",
                _ => "google_direct_array",
            }
            .to_string(),
            period_start_utc: summary.period_start_utc,
            period_end_utc: summary.period_end_utc,
            point_count: summary.point_count as u32,
            segment_count: summary.segment_count as u32,
            visit_count: summary.visit_count as u32,
            skipped_count: summary.skipped_count as u32,
            bytes_read: summary.bytes_read as i64,
        }),
        Err(error) => ImportEvent::Failed(match error {
            ParseError::EmptyExport => ImportErrorKind::EmptyExport,
            ParseError::CorruptJson { .. } => ImportErrorKind::CorruptJson,
            ParseError::UnrecognisedFormat { .. } => ImportErrorKind::UnrecognisedFormat,
            ParseError::FileTooLarge { .. } => ImportErrorKind::FileTooLarge,
            ParseError::Io { .. } => ImportErrorKind::Io,
        }),
    };
    let _ = streaming.sink.add(event);
}

/// `RecordSink` qui pousse des lots vers Dart au lieu de tout accumuler.
struct StreamingSink {
    sink: StreamSink<ImportEvent>,
    pending: ImportChunk,
    pending_len: usize,
}

impl StreamingSink {
    fn new(sink: StreamSink<ImportEvent>) -> Self {
        Self {
            sink,
            pending: ImportChunk::default(),
            pending_len: 0,
        }
    }

    fn flush(&mut self) {
        if self.pending_len == 0 {
            return;
        }
        let chunk = std::mem::take(&mut self.pending);
        self.pending_len = 0;
        let _ = self.sink.add(ImportEvent::Chunk(chunk));
    }

    fn bump(&mut self) {
        self.pending_len += 1;
        if self.pending_len >= CHUNK_SIZE {
            self.flush();
        }
    }
}

impl RecordSink for StreamingSink {
    fn point(&mut self, point: CoreRawPoint) {
        self.pending.points.push(ImportedPoint {
            timestamp_utc: point.timestamp_utc,
            tz_offset_minutes: i32::from(point.tz_offset_minutes),
            lat: point.lat,
            lon: point.lon,
        });
        self.bump();
    }

    fn visit(&mut self, visit: CoreVisit) {
        self.pending.visits.push(ImportedVisit {
            arrival_ts_utc: visit.arrival_ts_utc,
            arrival_tz_offset_minutes: i32::from(visit.arrival_tz_offset_minutes),
            departure_ts_utc: visit.departure_ts_utc,
            departure_tz_offset_minutes: i32::from(visit.departure_tz_offset_minutes),
            lat: visit.lat,
            lon: visit.lon,
            radius_m: visit.radius_m,
            external_place_ref: visit.external_place_ref,
        });
        self.bump();
    }

    fn segment(&mut self, segment: CoreSegment) {
        self.pending.segments.push(ImportedSegment {
            start_ts_utc: segment.start_ts_utc,
            start_tz_offset_minutes: i32::from(segment.start_tz_offset_minutes),
            end_ts_utc: segment.end_ts_utc,
            end_tz_offset_minutes: i32::from(segment.end_tz_offset_minutes),
            start_lat: segment.start_lat,
            start_lon: segment.start_lon,
            end_lat: segment.end_lat,
            end_lon: segment.end_lon,
            distance_m: segment.distance_m,
            detected_mode: mode_key(segment.detected_mode).to_string(),
        });
        self.bump();
    }

    fn progress(&mut self, progress: CoreProgress) {
        // Les lots partent avant la progression : l'UI ne doit jamais afficher
        // « 100 % » alors que des enregistrements sont encore en attente.
        self.flush();
        let _ = self.sink.add(ImportEvent::Progress(ImportProgress {
            step: match progress.step {
                ImportStep::DetectingFormat => ImportStepKind::DetectingFormat,
                ImportStep::Done => ImportStepKind::Done,
                _ => ImportStepKind::ReadingRecords,
            },
            percent: progress.percent().map(f64::from),
            records: progress.records_emitted as u32,
        }));
    }
}
