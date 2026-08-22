//! Surface exposée à Dart.
//!
//! # Ce que cette API garantit
//!
//! **Aucune fonction ne renvoie de donnée Timeline non filtrée.** Tout ce qui
//! sort d'ici est passé par le pipeline §5.4 : zones privées écartées, noms
//! résolus, corrections appliquées, filtres de vue appliqués. Il n'existe
//! volontairement pas de `get_raw_points` — l'absence de cette fonction est ce
//! qui empêche une vue de contourner les zones privées (§3.7).
//!
//! Les statistiques sont calculées **ici**, en Rust, à partir de la sortie du
//! pipeline. Exposer les données résolues et laisser Dart agréger aurait
//! remis de la logique métier dans `app/` (§6.1).
//!
//! # Pourquoi des DTO plutôt que les types de `timeline_core`
//!
//! `timeline_core` ne porte aucune annotation `flutter_rust_bridge` (§6.1) :
//! il doit rester un crate Rust ordinaire, testable sans Flutter. Les
//! structures ci-dessous en sont donc des copies, converties à la frontière.
//! C'est le prix — assumé — de garder le cœur pur.

use timeline_core::model::{
    LocalDate, PrivateZone as CorePrivateZone, RawPoint as CoreRawPoint, Segment as CoreSegment,
    SourceKind, TravelMode as CoreTravelMode, UserPlace as CoreUserPlace,
    UserSegmentOverride as CoreOverride, Visit as CoreVisit, ZoneShape,
};
use timeline_core::pipeline::places::{NoPlaceLookup, PlaceSource};
use timeline_core::pipeline::{
    Period as CorePeriod, Pipeline, PlaceFilter as CorePlaceFilter, ViewFilters,
};
use timeline_core::render::{
    self, RenderError, RenderParams as CoreRenderParams, VisualStyle as CoreVisualStyle,
};
use timeline_core::stats::{self, PlaceKey, StatsInput, Weekday};

// ---------------------------------------------------------------------------
// Types échangés
// ---------------------------------------------------------------------------

/// Mode de transport (§5.1).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
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
    /// Inconnu.
    Unknown,
}

impl From<CoreTravelMode> for TravelMode {
    fn from(mode: CoreTravelMode) -> Self {
        match mode {
            CoreTravelMode::Walking => Self::Walking,
            CoreTravelMode::Running => Self::Running,
            CoreTravelMode::Cycling => Self::Cycling,
            CoreTravelMode::InVehicle => Self::InVehicle,
            CoreTravelMode::InBus => Self::InBus,
            CoreTravelMode::InTrain => Self::InTrain,
            CoreTravelMode::Boat => Self::Boat,
            CoreTravelMode::Motorcycling => Self::Motorcycling,
            CoreTravelMode::Flight => Self::Flight,
            _ => Self::Unknown,
        }
    }
}

impl From<TravelMode> for CoreTravelMode {
    fn from(mode: TravelMode) -> Self {
        match mode {
            TravelMode::Walking => Self::Walking,
            TravelMode::Running => Self::Running,
            TravelMode::Cycling => Self::Cycling,
            TravelMode::InVehicle => Self::InVehicle,
            TravelMode::InBus => Self::InBus,
            TravelMode::InTrain => Self::InTrain,
            TravelMode::Boat => Self::Boat,
            TravelMode::Motorcycling => Self::Motorcycling,
            TravelMode::Flight => Self::Flight,
            TravelMode::Unknown => Self::Unknown,
        }
    }
}

/// Position brute à traiter (§5.1).
#[derive(Debug, Clone)]
pub struct PointInput {
    /// Instant UTC, en millisecondes.
    pub timestamp_utc: i64,
    /// Décalage local, en minutes.
    pub tz_offset_minutes: i32,
    /// Latitude.
    pub lat: f64,
    /// Longitude.
    pub lon: f64,
}

/// Arrêt à traiter (§5.1).
#[derive(Debug, Clone)]
pub struct VisitInput {
    /// Identifiant en base, remonté tel quel pour que l'UI puisse agir dessus.
    pub id: i64,
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
}

/// Trajet à traiter (§5.1).
#[derive(Debug, Clone)]
pub struct SegmentInput {
    /// Identifiant en base.
    pub id: i64,
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
    /// Mode détecté — jamais écrasé (§5.1).
    pub detected_mode: TravelMode,
}

/// Lieu nommé par l'utilisateur (§5.2).
#[derive(Debug, Clone)]
pub struct UserPlaceInput {
    /// Identifiant.
    pub id: i64,
    /// Nom.
    pub label: String,
    /// Latitude.
    pub lat: f64,
    /// Longitude.
    pub lon: f64,
    /// Rayon, en mètres.
    pub radius_m: f64,
}

/// Zone privée (§3.7).
#[derive(Debug, Clone)]
pub struct PrivateZoneInput {
    /// Identifiant.
    pub id: i64,
    /// Nom.
    pub label: String,
    /// Centre, pour un cercle.
    pub lat: Option<f64>,
    /// Centre, pour un cercle.
    pub lon: Option<f64>,
    /// Rayon, pour un cercle.
    pub radius_m: Option<f64>,
    /// Sommets (latitude, longitude) pour un polygone, aplatis deux à deux.
    pub polygon: Vec<f64>,
}

/// Correction de mode (§5.2).
#[derive(Debug, Clone)]
pub struct OverrideInput {
    /// Identifiant.
    pub id: i64,
    /// Date locale, en jours depuis l'epoch.
    pub local_date: i32,
    /// Latitude de départ arrondie.
    pub start_lat_r: f64,
    /// Longitude de départ arrondie.
    pub start_lon_r: f64,
    /// Latitude d'arrivée arrondie.
    pub end_lat_r: f64,
    /// Longitude d'arrivée arrondie.
    pub end_lon_r: f64,
    /// Mode corrigé.
    pub corrected_mode: TravelMode,
    /// Début du segment au moment de la correction — départage seulement (§4).
    pub source_start_ts_utc: i64,
}

/// Filtres de la vue courante (§3.4).
#[derive(Debug, Clone, Default)]
pub struct FiltersInput {
    /// Début de période, en millisecondes UTC.
    pub period_start_utc: Option<i64>,
    /// Fin de période, en millisecondes UTC.
    pub period_end_utc: Option<i64>,
    /// Filtre sur un lieu utilisateur.
    pub user_place_id: Option<i64>,
    /// Filtre sur un lieu du référentiel.
    pub geo_place_id: Option<i64>,
    /// Modes retenus ; vide = tous.
    pub modes: Vec<TravelMode>,
}

/// Tout ce dont le pipeline a besoin pour une vue.
///
/// Les données §5.1 viennent de la base, les données §5.2 aussi — mais elles
/// entrent **ensemble**, en une seule fois : il n'existe pas d'appel qui
/// traiterait les unes sans les autres, donc pas de fenêtre où une donnée
/// privée pourrait ressortir.
#[derive(Debug, Clone, Default)]
pub struct PipelineRequest {
    /// Positions brutes de la période.
    pub points: Vec<PointInput>,
    /// Arrêts de la période.
    pub visits: Vec<VisitInput>,
    /// Trajets de la période.
    pub segments: Vec<SegmentInput>,
    /// Lieux nommés (§5.2), en entier.
    pub user_places: Vec<UserPlaceInput>,
    /// Zones privées (§3.7), en entier.
    pub private_zones: Vec<PrivateZoneInput>,
    /// Corrections de mode (§5.2), en entier.
    pub overrides: Vec<OverrideInput>,
    /// Filtres de la vue.
    pub filters: FiltersInput,
}

/// D'où vient le nom d'un lieu (§5.4, étape 2).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PlaceOrigin {
    /// Nommé par l'utilisateur.
    UserPlace,
    /// Issu du référentiel embarqué.
    GeoPlace,
    /// Aucun nom : coordonnées brutes.
    Coordinates,
}

/// Arrêt après pipeline.
#[derive(Debug, Clone)]
pub struct ResolvedVisitOutput {
    /// Identifiant d'origine.
    pub id: i64,
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
    /// Nom résolu, absent si l'on retombe sur les coordonnées.
    pub place_label: Option<String>,
    /// Provenance du nom.
    pub place_origin: PlaceOrigin,
    /// Identifiant du lieu résolu, s'il y en a un.
    pub place_id: Option<i64>,
}

/// Trajet après pipeline.
#[derive(Debug, Clone)]
pub struct ResolvedSegmentOutput {
    /// Identifiant d'origine.
    pub id: i64,
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
    /// Distance, en mètres.
    pub distance_m: Option<f64>,
    /// Mode à afficher : corrigé si l'utilisateur l'a corrigé (§5.4, étape 3).
    pub mode: TravelMode,
    /// Le mode affiché vient-il d'une correction ?
    pub corrected: bool,
    /// Nom résolu du départ.
    pub start_place_label: Option<String>,
    /// Nom résolu de l'arrivée.
    pub end_place_label: Option<String>,
}

/// Position après pipeline.
#[derive(Debug, Clone)]
pub struct ResolvedPointOutput {
    /// Instant UTC, en millisecondes.
    pub timestamp_utc: i64,
    /// Latitude.
    pub lat: f64,
    /// Longitude.
    pub lon: f64,
}

/// Sortie du pipeline pour une vue.
#[derive(Debug, Clone, Default)]
pub struct PipelineResponse {
    /// Positions retenues.
    pub points: Vec<ResolvedPointOutput>,
    /// Arrêts retenus.
    pub visits: Vec<ResolvedVisitOutput>,
    /// Trajets retenus.
    pub segments: Vec<ResolvedSegmentOutput>,
    /// Corrections restées inactives sur ce lot (§4) — conservées en base.
    pub orphan_override_ids: Vec<i64>,
}

// ---------------------------------------------------------------------------
// Conversions vers le cœur
// ---------------------------------------------------------------------------

fn to_core_point(input: &PointInput) -> CoreRawPoint {
    CoreRawPoint {
        timestamp_utc: input.timestamp_utc,
        tz_offset_minutes: input.tz_offset_minutes as i16,
        lat: input.lat,
        lon: input.lon,
        accuracy_m: None,
        altitude_m: None,
        speed_ms: None,
        source_kind: SourceKind::GoogleTimeline,
    }
}

fn to_core_visit(input: &VisitInput) -> CoreVisit {
    CoreVisit {
        arrival_ts_utc: input.arrival_ts_utc,
        arrival_tz_offset_minutes: input.arrival_tz_offset_minutes as i16,
        departure_ts_utc: input.departure_ts_utc,
        departure_tz_offset_minutes: input.departure_tz_offset_minutes as i16,
        lat: input.lat,
        lon: input.lon,
        radius_m: None,
        external_place_ref: None,
        detection_confidence: None,
        source_kind: SourceKind::GoogleTimeline,
    }
}

fn to_core_segment(input: &SegmentInput) -> CoreSegment {
    CoreSegment {
        start_ts_utc: input.start_ts_utc,
        start_tz_offset_minutes: input.start_tz_offset_minutes as i16,
        end_ts_utc: input.end_ts_utc,
        end_tz_offset_minutes: input.end_tz_offset_minutes as i16,
        start_lat: input.start_lat,
        start_lon: input.start_lon,
        end_lat: input.end_lat,
        end_lon: input.end_lon,
        distance_m: input.distance_m,
        detected_mode: input.detected_mode.into(),
        mode_confidence: None,
        source_kind: SourceKind::GoogleTimeline,
    }
}

fn to_core_place(input: &UserPlaceInput) -> CoreUserPlace {
    CoreUserPlace {
        id: input.id,
        label: input.label.clone(),
        lat: input.lat,
        lon: input.lon,
        radius_m: input.radius_m,
    }
}

fn to_core_zone(input: &PrivateZoneInput) -> CorePrivateZone {
    let shape = match (input.lat, input.lon, input.radius_m) {
        (Some(lat), Some(lon), Some(radius_m)) if input.polygon.is_empty() => {
            ZoneShape::Circle { lat, lon, radius_m }
        }
        _ => ZoneShape::Polygon {
            // `as_chunks` plutôt que `chunks_exact(2)` : la taille est
            // constante, le compilateur en tire un tableau de taille connue.
            vertices: input
                .polygon
                .as_chunks::<2>()
                .0
                .iter()
                .map(|[lat, lon]| (*lat, *lon))
                .collect(),
        },
    };
    CorePrivateZone {
        id: input.id,
        label: input.label.clone(),
        shape,
    }
}

fn to_core_override(input: &OverrideInput) -> CoreOverride {
    CoreOverride {
        id: input.id,
        local_date: LocalDate(input.local_date),
        start_lat_r: input.start_lat_r,
        start_lon_r: input.start_lon_r,
        end_lat_r: input.end_lat_r,
        end_lon_r: input.end_lon_r,
        corrected_mode: input.corrected_mode.into(),
        source_start_ts_utc: input.source_start_ts_utc,
    }
}

fn to_core_filters(input: &FiltersInput) -> ViewFilters {
    ViewFilters {
        period: match (input.period_start_utc, input.period_end_utc) {
            (Some(start_utc), Some(end_utc)) => Some(CorePeriod { start_utc, end_utc }),
            _ => None,
        },
        place: match (input.user_place_id, input.geo_place_id) {
            (Some(id), _) => Some(CorePlaceFilter::UserPlace(id)),
            (None, Some(id)) => Some(CorePlaceFilter::GeoPlace(id)),
            _ => None,
        },
        modes: if input.modes.is_empty() {
            None
        } else {
            Some(input.modes.iter().copied().map(Into::into).collect())
        },
    }
}

fn place_parts(
    place: &timeline_core::pipeline::places::ResolvedPlace,
) -> (PlaceOrigin, Option<i64>) {
    match place.source {
        PlaceSource::UserPlace { id } => (PlaceOrigin::UserPlace, Some(id)),
        PlaceSource::GeoPlace { id } => (PlaceOrigin::GeoPlace, Some(id)),
        PlaceSource::Coordinates => (PlaceOrigin::Coordinates, None),
    }
}

// ---------------------------------------------------------------------------
// API
// ---------------------------------------------------------------------------

/// Applique le pipeline §5.4 et renvoie ce qu'une vue a le droit d'afficher.
///
/// Seule porte d'entrée vers les données Timeline côté Dart (§5.4). Les trois
/// vues consomment cette sortie, ce qui garantit qu'un lieu renommé ou une
/// zone privée se comporte identiquement partout.
pub fn run_pipeline(request: PipelineRequest) -> PipelineResponse {
    let zones: Vec<CorePrivateZone> = request.private_zones.iter().map(to_core_zone).collect();
    let places: Vec<CoreUserPlace> = request.user_places.iter().map(to_core_place).collect();
    let overrides: Vec<CoreOverride> = request.overrides.iter().map(to_core_override).collect();
    let filters = to_core_filters(&request.filters);

    let pipeline = Pipeline::new(&zones, &places, &overrides, &NoPlaceLookup, &filters);

    let core_points: Vec<CoreRawPoint> = request.points.iter().map(to_core_point).collect();
    let core_visits: Vec<CoreVisit> = request.visits.iter().map(to_core_visit).collect();
    let core_segments: Vec<CoreSegment> = request.segments.iter().map(to_core_segment).collect();

    let resolved_points = pipeline.points(&core_points);
    let resolved_visits = pipeline.visits(&core_visits);
    let batch = pipeline.segments(&core_segments);

    // Les identifiants d'origine sont réattachés par correspondance
    // géométrique et temporelle : le pipeline ne les transporte pas, puisque
    // le cœur ignore tout de la base (§6.1).
    let visits = resolved_visits
        .iter()
        .map(|resolved| {
            let (origin, place_id) = place_parts(&resolved.place);
            let id = request
                .visits
                .iter()
                .find(|candidate| {
                    candidate.arrival_ts_utc == resolved.visit.arrival_ts_utc
                        && candidate.lat == resolved.visit.lat
                        && candidate.lon == resolved.visit.lon
                })
                .map_or(0, |candidate| candidate.id);

            ResolvedVisitOutput {
                id,
                arrival_ts_utc: resolved.visit.arrival_ts_utc,
                arrival_tz_offset_minutes: i32::from(resolved.visit.arrival_tz_offset_minutes),
                departure_ts_utc: resolved.visit.departure_ts_utc,
                departure_tz_offset_minutes: i32::from(resolved.visit.departure_tz_offset_minutes),
                lat: resolved.visit.lat,
                lon: resolved.visit.lon,
                place_label: resolved.place.label.clone(),
                place_origin: origin,
                place_id,
            }
        })
        .collect();

    let segments = batch
        .segments
        .iter()
        .map(|resolved| {
            let id = request
                .segments
                .iter()
                .find(|candidate| {
                    candidate.start_ts_utc == resolved.segment.start_ts_utc
                        && candidate.start_lat == resolved.segment.start_lat
                        && candidate.end_lat == resolved.segment.end_lat
                })
                .map_or(0, |candidate| candidate.id);

            ResolvedSegmentOutput {
                id,
                start_ts_utc: resolved.segment.start_ts_utc,
                start_tz_offset_minutes: i32::from(resolved.segment.start_tz_offset_minutes),
                end_ts_utc: resolved.segment.end_ts_utc,
                end_tz_offset_minutes: i32::from(resolved.segment.end_tz_offset_minutes),
                start_lat: resolved.segment.start_lat,
                start_lon: resolved.segment.start_lon,
                end_lat: resolved.segment.end_lat,
                end_lon: resolved.segment.end_lon,
                distance_m: resolved.segment.distance_m,
                mode: resolved.mode.into(),
                corrected: resolved.corrected,
                start_place_label: resolved.start_place.label.clone(),
                end_place_label: resolved.end_place.label.clone(),
            }
        })
        .collect();

    PipelineResponse {
        points: resolved_points
            .iter()
            .map(|resolved| ResolvedPointOutput {
                timestamp_utc: resolved.point.timestamp_utc,
                lat: resolved.point.lat,
                lon: resolved.point.lon,
            })
            .collect(),
        visits,
        segments,
        orphan_override_ids: batch.orphan_override_ids,
    }
}

/// Case d'histogramme, telle qu'affichée par la vue Stats.
#[derive(Debug, Clone)]
pub struct BucketOutput {
    /// Libellé de la case — dépend de la statistique.
    pub key: String,
    /// Identifiant du lieu, pour le classement des lieux.
    pub place_id: Option<i64>,
    /// Nombre d'enregistrements.
    pub count: u32,
    /// Durée cumulée, en millisecondes.
    pub duration_ms: i64,
    /// Distance cumulée, en mètres.
    pub distance_m: f64,
}

/// Case de heatmap (§3.4).
#[derive(Debug, Clone)]
pub struct HeatCellOutput {
    /// Latitude du coin sud-ouest.
    pub lat: f64,
    /// Longitude du coin sud-ouest.
    pub lon: f64,
    /// Nombre de positions dans la case.
    pub count: u32,
}

/// Les six statistiques de §3.4.
#[derive(Debug, Clone, Default)]
pub struct StatsOutput {
    /// Heatmap de densité.
    pub density: Vec<HeatCellOutput>,
    /// Lieux, classés par temps passé décroissant.
    pub places: Vec<BucketOutput>,
    /// Répartition par mode.
    pub modes: Vec<BucketOutput>,
    /// Patterns horaires, 24 cases, heure locale en clé.
    pub hours: Vec<BucketOutput>,
    /// Patterns par jour de semaine, lundi en premier.
    pub weekdays: Vec<BucketOutput>,
    /// Distance totale, en mètres.
    pub total_distance_m: f64,
    /// Nombre d'arrêts retenus.
    pub visit_count: u32,
    /// Nombre de trajets retenus.
    pub segment_count: u32,
}

/// Calcule les statistiques §3.4 **sur la sortie du pipeline**.
///
/// Prend la même requête que [`run_pipeline`] et refait passer les données par
/// le pipeline : il n'existe aucun chemin par lequel une statistique pourrait
/// porter sur des données non filtrées (§3.7).
pub fn compute_stats(request: PipelineRequest, cell_size_deg: f64) -> StatsOutput {
    let zones: Vec<CorePrivateZone> = request.private_zones.iter().map(to_core_zone).collect();
    let places: Vec<CoreUserPlace> = request.user_places.iter().map(to_core_place).collect();
    let overrides: Vec<CoreOverride> = request.overrides.iter().map(to_core_override).collect();
    let filters = to_core_filters(&request.filters);
    let pipeline = Pipeline::new(&zones, &places, &overrides, &NoPlaceLookup, &filters);

    let core_points: Vec<CoreRawPoint> = request.points.iter().map(to_core_point).collect();
    let core_visits: Vec<CoreVisit> = request.visits.iter().map(to_core_visit).collect();
    let core_segments: Vec<CoreSegment> = request.segments.iter().map(to_core_segment).collect();

    let resolved_points = pipeline.points(&core_points);
    let resolved_visits = pipeline.visits(&core_visits);
    let batch = pipeline.segments(&core_segments);

    let input = StatsInput {
        points: &resolved_points,
        visits: &resolved_visits,
        segments: &batch.segments,
    };
    let report = stats::report(input, cell_size_deg);

    let place_labels: Vec<(PlaceKey, Option<String>)> = resolved_visits
        .iter()
        .map(|resolved| {
            let key = match resolved.place.source {
                PlaceSource::UserPlace { id } => PlaceKey::User(id),
                PlaceSource::GeoPlace { id } => PlaceKey::Geo(id),
                PlaceSource::Coordinates => PlaceKey::Unnamed(stats::GridCell::of(
                    resolved.visit.lat,
                    resolved.visit.lon,
                    cell_size_deg,
                )),
            };
            (key, resolved.place.label.clone())
        })
        .collect();

    StatsOutput {
        density: report
            .density
            .entries()
            .map(|(cell, bucket)| {
                let (lat, lon) = cell.south_west(cell_size_deg);
                HeatCellOutput {
                    lat,
                    lon,
                    count: bucket.count as u32,
                }
            })
            .collect(),
        places: report
            .places
            .ranked_by_duration()
            .into_iter()
            .map(|(key, bucket)| {
                let label = place_labels
                    .iter()
                    .find(|(candidate, _)| candidate == &key)
                    .and_then(|(_, label)| label.clone());
                BucketOutput {
                    key: label.unwrap_or_default(),
                    place_id: match key {
                        PlaceKey::User(id) | PlaceKey::Geo(id) => Some(id),
                        PlaceKey::Unnamed(_) => None,
                    },
                    count: bucket.count as u32,
                    duration_ms: bucket.duration_ms,
                    distance_m: bucket.distance_m,
                }
            })
            .collect(),
        modes: report
            .modes
            .entries()
            .map(|(mode, bucket)| BucketOutput {
                key: mode_key(*mode).to_string(),
                place_id: None,
                count: bucket.count as u32,
                duration_ms: bucket.duration_ms,
                distance_m: bucket.distance_m,
            })
            .collect(),
        hours: report
            .hours
            .entries()
            .map(|(hour, bucket)| BucketOutput {
                key: hour.to_string(),
                place_id: None,
                count: bucket.count as u32,
                duration_ms: bucket.duration_ms,
                distance_m: bucket.distance_m,
            })
            .collect(),
        weekdays: report
            .weekdays
            .entries()
            .map(|(weekday, bucket)| BucketOutput {
                key: weekday_key(*weekday).to_string(),
                place_id: None,
                count: bucket.count as u32,
                duration_ms: bucket.duration_ms,
                distance_m: bucket.distance_m,
            })
            .collect(),
        total_distance_m: report.total_distance_m,
        visit_count: report.visit_count as u32,
        segment_count: report.segment_count as u32,
    }
}

/// Clé stable d'un mode, pour que Dart la traduise (§3.9).
///
/// Volontairement une clé et non un libellé : le cœur ne produit **jamais** de
/// texte destiné à l'utilisateur, c'est l'UI qui traduit.
pub(crate) fn mode_key(mode: CoreTravelMode) -> &'static str {
    match mode {
        CoreTravelMode::Walking => "walking",
        CoreTravelMode::Running => "running",
        CoreTravelMode::Cycling => "cycling",
        CoreTravelMode::InVehicle => "in_vehicle",
        CoreTravelMode::InBus => "in_bus",
        CoreTravelMode::InTrain => "in_train",
        CoreTravelMode::Boat => "boat",
        CoreTravelMode::Motorcycling => "motorcycling",
        CoreTravelMode::Flight => "flight",
        _ => "unknown",
    }
}

/// Clé stable d'un jour de semaine, pour que Dart la traduise (§3.9).
fn weekday_key(weekday: Weekday) -> &'static str {
    match weekday {
        Weekday::Monday => "monday",
        Weekday::Tuesday => "tuesday",
        Weekday::Wednesday => "wednesday",
        Weekday::Thursday => "thursday",
        Weekday::Friday => "friday",
        Weekday::Saturday => "saturday",
        _ => "sunday",
    }
}

// ---------------------------------------------------------------------------
// Vidéo souvenir (§3.5)
// ---------------------------------------------------------------------------

/// Style visuel demandé (§3.5).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum VideoStyle {
    /// Rendu clair.
    Classic,
    /// Rendu sombre.
    Night,
    /// Trait seul.
    Minimal,
}

impl From<VideoStyle> for CoreVisualStyle {
    fn from(style: VideoStyle) -> Self {
        match style {
            VideoStyle::Classic => Self::Classic,
            VideoStyle::Night => Self::Night,
            VideoStyle::Minimal => Self::Minimal,
        }
    }
}

/// Paramètres de génération (§3.5).
#[derive(Debug, Clone)]
pub struct VideoParams {
    /// Durée, en secondes : 15, 30, 45, 60, 75 ou 90.
    pub duration_s: u32,
    /// Début de la plage, en millisecondes UTC.
    pub period_start_utc: i64,
    /// Fin de la plage, en millisecondes UTC.
    pub period_end_utc: i64,
    /// Style visuel.
    pub style: VideoStyle,
    /// Titre déjà interpolé par l'UI — le cœur ne fabrique pas de texte
    /// affiché (§3.9).
    pub title: String,
}

/// Une image du plan.
#[derive(Debug, Clone)]
pub struct FrameOutput {
    /// Index, à partir de 0.
    pub index: u32,
    /// Instant couvert, en millisecondes UTC.
    pub timestamp_utc: i64,
    /// Positions révélées jusqu'ici.
    pub revealed_points: u32,
    /// Trajets révélés jusqu'ici.
    pub revealed_segments: u32,
}

/// Cas d'échec du plan (§3.10) — un cas, un variant, un message traduit.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum VideoPlanErrorKind {
    /// Durée hors de la liste supportée.
    UnsupportedDuration,
    /// Plage vide ou inversée.
    EmptyPeriod,
    /// Aucune donnée à animer — souvent parce que les zones privées ont tout
    /// écarté (§3.7).
    NothingToRender,
}

/// Résultat du plan.
#[derive(Debug, Clone, Default)]
pub struct VideoPlanResult {
    /// Cause de l'échec, le cas échéant.
    pub error: Option<VideoPlanErrorKind>,
    /// Images du plan.
    pub frames: Vec<FrameOutput>,
    /// Cadence.
    pub fps: u32,
}

/// Calcule le plan de frames **sur la sortie du pipeline** (§3.5).
///
/// Comme [`compute_stats`], repasse par le pipeline : une zone privée est donc
/// absente des images elles-mêmes, pas masquée au rendu (§3.7).
pub fn plan_video(request: PipelineRequest, params: VideoParams) -> VideoPlanResult {
    let zones: Vec<CorePrivateZone> = request.private_zones.iter().map(to_core_zone).collect();
    let places: Vec<CoreUserPlace> = request.user_places.iter().map(to_core_place).collect();
    let overrides: Vec<CoreOverride> = request.overrides.iter().map(to_core_override).collect();
    let filters = to_core_filters(&request.filters);
    let pipeline = Pipeline::new(&zones, &places, &overrides, &NoPlaceLookup, &filters);

    let core_points: Vec<CoreRawPoint> = request.points.iter().map(to_core_point).collect();
    let core_segments: Vec<CoreSegment> = request.segments.iter().map(to_core_segment).collect();
    let resolved_points = pipeline.points(&core_points);
    let batch = pipeline.segments(&core_segments);

    let core_params = CoreRenderParams {
        duration_s: params.duration_s,
        period_start_utc: params.period_start_utc,
        period_end_utc: params.period_end_utc,
        style: params.style.into(),
        title: params.title,
    };

    match render::plan(&resolved_points, &batch.segments, &core_params) {
        Ok(plan) => VideoPlanResult {
            error: None,
            frames: plan
                .frames
                .iter()
                .map(|frame| FrameOutput {
                    index: frame.index,
                    timestamp_utc: frame.timestamp_utc,
                    revealed_points: frame.revealed_points,
                    revealed_segments: frame.revealed_segments,
                })
                .collect(),
            fps: plan.fps,
        },
        Err(error) => VideoPlanResult {
            error: Some(match error {
                RenderError::UnsupportedDuration(_) => VideoPlanErrorKind::UnsupportedDuration,
                RenderError::EmptyPeriod => VideoPlanErrorKind::EmptyPeriod,
                _ => VideoPlanErrorKind::NothingToRender,
            }),
            frames: Vec::new(),
            fps: 0,
        },
    }
}
