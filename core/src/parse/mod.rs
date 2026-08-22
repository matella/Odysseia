//! Import de données : trait commun, générique par source (§3.1).
//!
//! Le parsing Google n'est qu'**une** implémentation parmi d'autres
//! (GPX, Strava, fitness plus tard). Parsing en streaming obligatoire :
//! ne jamais charger tout le JSON en mémoire (§4).
//!
//! # Contrat de streaming
//!
//! Un importeur lit une source *au fil de l'eau* et pousse chaque
//! enregistrement dans un [`RecordSink`] au fur et à mesure. Il ne construit
//! jamais de collection de la taille de l'entrée. La mémoire utilisée est
//! bornée par le plus gros enregistrement, pas par la taille du fichier — ce
//! que vérifie `tests/parse_streaming.rs`.
//!
//! # Erreurs
//!
//! Deux niveaux, volontairement distincts (§3.10) :
//! - [`ParseError`] — fatale, l'import s'arrête ;
//! - [`crate::error::RecordError`] — l'enregistrement est ignoré et compté,
//!   l'import continue.

pub mod coords;
pub mod google;
pub mod time;

use std::io::Read;

use crate::error::{ParseError, RecordError};
use crate::model::{RawPoint, Segment, SourceFormat, SourceKind, Visit};

/// Source de données importable (§3.1).
///
/// Object-safe : l'orchestration Dart peut détenir un `Box<dyn TimelineImporter>`
/// choisi à l'exécution selon le type de fichier.
pub trait TimelineImporter {
    /// Origine que produira cet importeur.
    fn source_kind(&self) -> SourceKind;

    /// Lit `reader` de bout en bout et pousse les enregistrements dans `sink`.
    ///
    /// Ne charge jamais la source entière en mémoire (§4).
    fn parse(
        &self,
        reader: &mut dyn Read,
        sink: &mut dyn RecordSink,
        options: &ParseOptions,
    ) -> Result<ImportSummary, ParseError>;
}

/// Réceptacle des enregistrements produits pendant l'import.
///
/// Implémenté côté appelant pour insérer en base par lots (§4). Les méthodes
/// sont appelées au fil de la lecture : accumuler dans un `Vec` annulerait le
/// bénéfice du streaming (voir [`CollectingSink`], réservé aux tests).
pub trait RecordSink {
    /// Une position brute a été lue.
    fn point(&mut self, point: RawPoint);

    /// Un déplacement a été lu.
    fn segment(&mut self, segment: Segment);

    /// Un arrêt a été lu.
    fn visit(&mut self, visit: Visit);

    /// Un enregistrement a été ignoré (§3.10). Jamais silencieux, mais non
    /// fatal.
    fn skipped(&mut self, _skipped: SkippedRecord) {}

    /// Progression de l'import (§4). Appelée selon
    /// [`ParseOptions::progress_every`].
    fn progress(&mut self, _progress: Progress) {}
}

/// Enregistrement ignoré et la raison du rejet.
#[derive(Debug, Clone, PartialEq)]
pub struct SkippedRecord {
    /// Position de l'enregistrement dans la source, à partir de 0.
    pub index: u64,
    /// Raison du rejet.
    pub error: RecordError,
}

/// Étape courante de l'import, affichée à l'utilisateur (§4).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[non_exhaustive]
pub enum ImportStep {
    /// Détection du format de la source.
    DetectingFormat,
    /// Lecture des enregistrements.
    ReadingRecords,
    /// Lecture terminée.
    Done,
}

/// Point de progression remonté au `RecordSink` (§4).
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Progress {
    /// Étape en cours.
    pub step: ImportStep,
    /// Octets consommés depuis le début.
    pub bytes_read: u64,
    /// Taille totale annoncée par l'appelant, si connue.
    pub total_bytes: Option<u64>,
    /// Nombre d'enregistrements produits jusqu'ici.
    pub records_emitted: u64,
}

impl Progress {
    /// Avancement en pourcentage, ou `None` si la taille totale est inconnue.
    ///
    /// Une source en streaming (téléchargement, flux) n'a pas de taille
    /// connue d'avance : l'UI affiche alors l'étape sans pourcentage plutôt
    /// qu'une barre qui ment.
    pub fn percent(&self) -> Option<f32> {
        match self.total_bytes {
            Some(total) if total > 0 => {
                Some(((self.bytes_read as f64 / total as f64) * 100.0).min(100.0) as f32)
            }
            _ => None,
        }
    }
}

/// Réglages d'un import.
#[derive(Debug, Clone)]
pub struct ParseOptions {
    /// Taille maximale acceptée, en octets. Au-delà :
    /// [`ParseError::FileTooLarge`].
    ///
    /// La **politique** appartient à l'appelant (§4) : 500 Mo confortables en
    /// natif, avertissement au-delà de ~200 Mo en web. Le core applique la
    /// limite, il ne la choisit pas.
    pub max_bytes: Option<u64>,

    /// Taille totale de la source, si connue — sert au pourcentage.
    pub total_bytes_hint: Option<u64>,

    /// Nombre d'enregistrements entre deux remontées de progression.
    pub progress_every: u64,
}

impl Default for ParseOptions {
    fn default() -> Self {
        Self {
            max_bytes: None,
            total_bytes_hint: None,
            progress_every: 1000,
        }
    }
}

/// Bilan d'un import — alimente `import_batch` (§5.1).
#[derive(Debug, Clone, PartialEq)]
pub struct ImportSummary {
    /// Origine des données.
    pub source_kind: SourceKind,
    /// Format concret détecté.
    pub format: SourceFormat,
    /// Début de la période couverte, en millisecondes UTC.
    pub period_start_utc: Option<i64>,
    /// Fin de la période couverte, en millisecondes UTC.
    ///
    /// Avec [`Self::period_start_utc`], permet d'avertir avant écrasement si
    /// un nouvel export couvre moins que l'actuel (§4).
    pub period_end_utc: Option<i64>,
    /// Nombre de positions brutes produites.
    pub point_count: u64,
    /// Nombre de déplacements produits.
    pub segment_count: u64,
    /// Nombre d'arrêts produits.
    pub visit_count: u64,
    /// Nombre d'enregistrements ignorés (§3.10).
    pub skipped_count: u64,
    /// Octets lus dans la source.
    pub bytes_read: u64,
}

/// `RecordSink` qui accumule tout en mémoire.
///
/// ⚠️ Réservé aux **tests et aux petits volumes** : accumuler annule le
/// bénéfice du streaming (§4). Un import réel insère en base par lots.
#[derive(Debug, Default)]
pub struct CollectingSink {
    /// Positions brutes reçues.
    pub points: Vec<RawPoint>,
    /// Déplacements reçus.
    pub segments: Vec<Segment>,
    /// Arrêts reçus.
    pub visits: Vec<Visit>,
    /// Enregistrements ignorés.
    pub skipped: Vec<SkippedRecord>,
}

impl RecordSink for CollectingSink {
    fn point(&mut self, point: RawPoint) {
        self.points.push(point);
    }

    fn segment(&mut self, segment: Segment) {
        self.segments.push(segment);
    }

    fn visit(&mut self, visit: Visit) {
        self.visits.push(visit);
    }

    fn skipped(&mut self, skipped: SkippedRecord) {
        self.skipped.push(skipped);
    }
}
