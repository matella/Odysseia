//! Zone **importée** (§5.1) — remplacée intégralement à chaque import.
//!
//! Ces structures sont **pré-persistance** : elles n'ont ni `id` ni
//! `batch_id`, attribués par la base au moment de l'insertion par lots (§4).
//!
//! Le modèle n'est pas calqué sur le format Google (§3.1) : chaque
//! enregistrement porte son [`SourceKind`], et les identifiants propres à une
//! source restent dans des champs `external_*`.
//!
//! Temps : UTC + offset stockés **séparément** (§5.5), jamais l'heure locale
//! seule — les patterns horaires et les trajets qui traversent un fuseau en
//! dépendent.

/// Origine d'un enregistrement (§3.1).
///
/// Point d'extension : GPX, Strava et les données de fitness viendront après
/// la v1, derrière la même interface d'import.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
#[non_exhaustive]
pub enum SourceKind {
    /// Export Google Timeline.
    GoogleTimeline,
}

/// Format concret détecté dans la source — `import_batch.source_format_detected`
/// (§5.1).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[non_exhaustive]
pub enum SourceFormat {
    /// Objet de premier niveau contenant `semanticSegments` (legacy).
    GoogleSemanticSegments,
    /// Tableau de premier niveau (format actuel).
    GoogleDirectArray,
}

/// Mode de transport détecté par la source (§5.1).
///
/// `detected_mode` conserve **toujours** la valeur d'origine : une correction
/// utilisateur vit dans `user_segment_override` (§5.2) et est appliquée par le
/// pipeline (§5.4), elle n'écrase jamais cette valeur.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[non_exhaustive]
pub enum TravelMode {
    /// À pied.
    Walking,
    /// Course à pied.
    Running,
    /// À vélo.
    Cycling,
    /// En véhicule particulier.
    InVehicle,
    /// En bus.
    InBus,
    /// En train, métro ou tram.
    InTrain,
    /// En bateau.
    Boat,
    /// À moto.
    Motorcycling,
    /// En avion.
    Flight,
    /// Non détecté ou valeur inconnue de la source.
    Unknown,
}

/// Position brute — `raw_point` (§5.1).
#[derive(Debug, Clone, PartialEq)]
pub struct RawPoint {
    /// Instant UTC, en millisecondes depuis l'epoch.
    pub timestamp_utc: i64,
    /// Décalage du fuseau local au moment de la mesure, en minutes (§5.5).
    pub tz_offset_minutes: i16,
    /// Latitude décimale, dans [-90, 90].
    pub lat: f64,
    /// Longitude décimale, dans [-180, 180].
    pub lon: f64,
    /// Précision annoncée, en mètres.
    pub accuracy_m: Option<f32>,
    /// Altitude, en mètres.
    pub altitude_m: Option<f32>,
    /// Vitesse instantanée, en mètres par seconde.
    pub speed_ms: Option<f32>,
    /// Origine de l'enregistrement.
    pub source_kind: SourceKind,
}

/// Déplacement détecté entre deux visites — `segment` (§5.1).
#[derive(Debug, Clone, PartialEq)]
pub struct Segment {
    /// Début, en millisecondes UTC depuis l'epoch.
    pub start_ts_utc: i64,
    /// Décalage local au départ, en minutes.
    pub start_tz_offset_minutes: i16,
    /// Fin, en millisecondes UTC depuis l'epoch.
    pub end_ts_utc: i64,
    /// Décalage local à l'arrivée, en minutes — différent du départ si le
    /// trajet traverse un fuseau (§5.5).
    pub end_tz_offset_minutes: i16,
    /// Latitude de départ.
    pub start_lat: f64,
    /// Longitude de départ.
    pub start_lon: f64,
    /// Latitude d'arrivée.
    pub end_lat: f64,
    /// Longitude d'arrivée.
    pub end_lon: f64,
    /// Distance annoncée par la source, en mètres.
    pub distance_m: Option<f64>,
    /// Mode détecté par la source — jamais écrasé par une correction (§5.1).
    pub detected_mode: TravelMode,
    /// Confiance annoncée par la source, dans [0, 1].
    pub mode_confidence: Option<f32>,
    /// Origine de l'enregistrement.
    pub source_kind: SourceKind,
}

/// Arrêt détecté à un endroit — `visit` (§5.1).
#[derive(Debug, Clone, PartialEq)]
pub struct Visit {
    /// Arrivée, en millisecondes UTC depuis l'epoch.
    pub arrival_ts_utc: i64,
    /// Décalage local à l'arrivée, en minutes.
    pub arrival_tz_offset_minutes: i16,
    /// Départ, en millisecondes UTC depuis l'epoch.
    pub departure_ts_utc: i64,
    /// Décalage local au départ, en minutes.
    pub departure_tz_offset_minutes: i16,
    /// Latitude du lieu.
    pub lat: f64,
    /// Longitude du lieu.
    pub lon: f64,
    /// Rayon annoncé, en mètres.
    pub radius_m: Option<f64>,
    /// Identifiant de lieu **propre à la source** (`placeId` Google).
    ///
    /// Volontairement distinct de `visit.place_id` (§5.1), qui référence le
    /// référentiel embarqué `geo_place` (§5.3) et est résolu plus tard par le
    /// pipeline. Recopier l'identifiant Google dans `place_id` calquerait le
    /// modèle sur Google (§3.1).
    pub external_place_ref: Option<String>,
    /// Confiance de détection annoncée par la source, dans [0, 1].
    pub detection_confidence: Option<f32>,
    /// Origine de l'enregistrement.
    pub source_kind: SourceKind,
}

/// Un import = un enregistrement — `import_batch` (§5.1).
///
/// Permet d'afficher « vos données couvrent telle période » et d'avertir
/// avant écrasement si le nouvel export couvre moins que l'ancien (§4).
#[derive(Debug, Clone, PartialEq)]
pub struct ImportBatch {
    /// Identifiant en base.
    pub id: i64,
    /// Instant de l'import, en millisecondes UTC.
    pub imported_at: i64,
    /// Origine des données.
    pub source_kind: SourceKind,
    /// Chemin du fichier source conservé (§3.2).
    pub source_file_path: String,
    /// Format concret détecté à l'analyse.
    pub source_format_detected: SourceFormat,
    /// Début de la période couverte, en millisecondes UTC.
    pub period_start: Option<i64>,
    /// Fin de la période couverte, en millisecondes UTC.
    pub period_end: Option<i64>,
    /// Nombre de positions brutes importées.
    pub point_count: i64,
}
