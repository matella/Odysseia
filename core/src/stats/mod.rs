//! Agrégations composables (§3.4).
//!
//! §3.4 met en garde contre « six calculs ad hoc » : chaque filtre devrait
//! alors être réimplémenté six fois. Ce module s'en tient donc à **un seul
//! mécanisme** — un [`Histogram`] de [`Bucket`] indexé par une clé — dont les
//! six statistiques demandées ne sont que six choix de clé :
//!
//! | Statistique (§3.4) | Clé |
//! | --- | --- |
//! | heatmap de densité | [`GridCell`] |
//! | lieux les plus visités | [`PlaceKey`] |
//! | temps passé par lieu | [`PlaceKey`] (même histogramme) |
//! | patterns horaires | heure locale |
//! | patterns jour de semaine | [`Weekday`] |
//! | répartition par mode | [`TravelMode`] |
//!
//! La distance totale est la seule à ne pas être un histogramme : c'est une
//! somme.
//!
//! # Filtres
//!
//! Aucun filtre n'est implémenté ici. Les statistiques consomment la sortie du
//! pipeline (§5.4), déjà filtrée par période, lieu et mode — et déjà purgée
//! des zones privées (§3.7). C'est ce qui rend les agrégations composables
//! sans les réécrire par filtre : un total de stats ne peut pas, par
//! construction, inclure une donnée que l'utilisateur a exclue.

use std::collections::BTreeMap;

use crate::model::{LocalDate, TravelMode};
use crate::pipeline::places::PlaceSource;
use crate::pipeline::{ResolvedPoint, ResolvedSegment, ResolvedVisit};

/// Ce qu'un enregistrement apporte à une case d'histogramme.
#[derive(Debug, Default, Clone, Copy, PartialEq)]
pub struct Sample {
    /// Durée, en millisecondes.
    pub duration_ms: i64,
    /// Distance, en mètres.
    pub distance_m: f64,
}

impl Sample {
    /// Échantillon ne comptant qu'une occurrence.
    pub fn counted() -> Self {
        Self::default()
    }

    /// Échantillon portant une durée.
    pub fn lasting(duration_ms: i64) -> Self {
        Self {
            duration_ms,
            distance_m: 0.0,
        }
    }
}

/// Case d'histogramme : ce qu'on sait d'un groupe.
#[derive(Debug, Default, Clone, Copy, PartialEq)]
pub struct Bucket {
    /// Nombre d'enregistrements.
    pub count: u64,
    /// Durée cumulée, en millisecondes.
    pub duration_ms: i64,
    /// Distance cumulée, en mètres.
    pub distance_m: f64,
}

impl Bucket {
    fn absorb(&mut self, sample: Sample) {
        self.count += 1;
        self.duration_ms += sample.duration_ms;
        self.distance_m += sample.distance_m;
    }
}

/// Histogramme générique — le seul mécanisme d'agrégation du module.
///
/// `BTreeMap` et non `HashMap` : l'ordre de parcours doit être déterministe,
/// sans quoi deux exécutions produiraient deux vidéos ou deux golden tests
/// différents à données égales.
#[derive(Debug, Clone, PartialEq)]
pub struct Histogram<K: Ord> {
    buckets: BTreeMap<K, Bucket>,
}

impl<K: Ord> Default for Histogram<K> {
    fn default() -> Self {
        Self {
            buckets: BTreeMap::new(),
        }
    }
}

impl<K: Ord + Clone> Histogram<K> {
    /// Ajoute un échantillon à la case `key`.
    pub fn add(&mut self, key: K, sample: Sample) {
        self.buckets.entry(key).or_default().absorb(sample);
    }

    /// Cases par ordre de clé.
    pub fn entries(&self) -> impl Iterator<Item = (&K, &Bucket)> {
        self.buckets.iter()
    }

    /// Nombre de cases non vides.
    pub fn len(&self) -> usize {
        self.buckets.len()
    }

    /// Aucun échantillon.
    pub fn is_empty(&self) -> bool {
        self.buckets.is_empty()
    }

    /// Case la plus fournie, s'il y en a une.
    pub fn peak(&self) -> Option<(&K, &Bucket)> {
        self.buckets.iter().max_by_key(|(_, bucket)| bucket.count)
    }

    /// Cases classées par nombre décroissant, à égalité par ordre de clé.
    pub fn ranked_by_count(&self) -> Vec<(K, Bucket)> {
        let mut ranked: Vec<(K, Bucket)> = self
            .buckets
            .iter()
            .map(|(key, bucket)| (key.clone(), *bucket))
            .collect();
        ranked
            .sort_by(|(key_a, a), (key_b, b)| b.count.cmp(&a.count).then_with(|| key_a.cmp(key_b)));
        ranked
    }

    /// Cases classées par durée décroissante, à égalité par ordre de clé.
    pub fn ranked_by_duration(&self) -> Vec<(K, Bucket)> {
        let mut ranked: Vec<(K, Bucket)> = self
            .buckets
            .iter()
            .map(|(key, bucket)| (key.clone(), *bucket))
            .collect();
        ranked.sort_by(|(key_a, a), (key_b, b)| {
            b.duration_ms
                .cmp(&a.duration_ms)
                .then_with(|| key_a.cmp(key_b))
        });
        ranked
    }
}

/// Identité d'un lieu, telle que le pipeline l'a résolue (§5.4, étape 2).
///
/// Volontairement fondée sur le lieu **résolu** et non sur des coordonnées :
/// deux visites à cinquante mètres d'écart au même endroit doivent compter
/// pour le même lieu si l'utilisateur l'a nommé.
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub enum PlaceKey {
    /// Lieu nommé par l'utilisateur (§5.2).
    User(i64),
    /// Lieu du référentiel embarqué (§5.3).
    Geo(i64),
    /// Sans nom : regroupé par cellule, faute de mieux.
    Unnamed(GridCell),
}

/// Cellule de la grille spatiale.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct GridCell {
    /// Index de latitude.
    pub lat_index: i32,
    /// Index de longitude.
    pub lon_index: i32,
}

impl GridCell {
    /// Cellule contenant la position, pour une taille de maille en degrés.
    pub fn of(lat: f64, lon: f64, cell_size_deg: f64) -> Self {
        Self {
            lat_index: (lat / cell_size_deg).floor() as i32,
            lon_index: (lon / cell_size_deg).floor() as i32,
        }
    }

    /// Coin sud-ouest de la cellule, en degrés.
    pub fn south_west(&self, cell_size_deg: f64) -> (f64, f64) {
        (
            f64::from(self.lat_index) * cell_size_deg,
            f64::from(self.lon_index) * cell_size_deg,
        )
    }
}

/// Taille de maille par défaut de la heatmap, en degrés (~1,1 km).
pub const DEFAULT_CELL_SIZE_DEG: f64 = 0.01;

/// Jour de la semaine, lundi en premier.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
#[non_exhaustive]
pub enum Weekday {
    /// Lundi.
    Monday,
    /// Mardi.
    Tuesday,
    /// Mercredi.
    Wednesday,
    /// Jeudi.
    Thursday,
    /// Vendredi.
    Friday,
    /// Samedi.
    Saturday,
    /// Dimanche.
    Sunday,
}

impl Weekday {
    /// Jour de la semaine d'une date locale.
    ///
    /// Le 1ᵉʳ janvier 1970 était un jeudi : d'où le décalage de 3 pour que
    /// lundi tombe à l'index 0.
    pub fn of(date: LocalDate) -> Self {
        match (date.0 + 3).rem_euclid(7) {
            0 => Self::Monday,
            1 => Self::Tuesday,
            2 => Self::Wednesday,
            3 => Self::Thursday,
            4 => Self::Friday,
            5 => Self::Saturday,
            _ => Self::Sunday,
        }
    }

    /// Index, lundi = 0.
    pub fn index(self) -> u8 {
        self as u8
    }
}

/// Heure locale d'un instant, dans 0..24 (§5.5).
///
/// Calculée depuis UTC + offset : c'est précisément pour cette statistique que
/// §5.5 impose de stocker les deux séparément.
pub fn local_hour(utc_millis: i64, tz_offset_minutes: i16) -> u8 {
    let local = utc_millis + i64::from(tz_offset_minutes) * 60_000;
    let millis_in_day = local.rem_euclid(86_400_000);
    (millis_in_day / 3_600_000) as u8
}

/// Entrée des statistiques : la sortie du pipeline (§5.4), rien d'autre.
#[derive(Debug, Default, Clone, Copy)]
pub struct StatsInput<'a> {
    /// Positions retenues.
    pub points: &'a [ResolvedPoint],
    /// Arrêts retenus.
    pub visits: &'a [ResolvedVisit],
    /// Trajets retenus.
    pub segments: &'a [ResolvedSegment],
}

/// Heatmap de densité (§3.4).
pub fn density(input: StatsInput<'_>, cell_size_deg: f64) -> Histogram<GridCell> {
    let mut histogram = Histogram::default();
    for resolved in input.points {
        histogram.add(
            GridCell::of(resolved.point.lat, resolved.point.lon, cell_size_deg),
            Sample::counted(),
        );
    }
    histogram
}

/// Lieux visités : nombre de passages **et** temps passé (§3.4).
///
/// Les deux statistiques demandées séparément sortent du même histogramme —
/// `ranked_by_count` pour le classement, `ranked_by_duration` pour le temps.
pub fn places(input: StatsInput<'_>, cell_size_deg: f64) -> Histogram<PlaceKey> {
    let mut histogram = Histogram::default();
    for resolved in input.visits {
        let key = match resolved.place.source {
            PlaceSource::UserPlace { id } => PlaceKey::User(id),
            PlaceSource::GeoPlace { id } => PlaceKey::Geo(id),
            PlaceSource::Coordinates => PlaceKey::Unnamed(GridCell::of(
                resolved.visit.lat,
                resolved.visit.lon,
                cell_size_deg,
            )),
        };
        let duration = resolved.visit.departure_ts_utc - resolved.visit.arrival_ts_utc;
        histogram.add(key, Sample::lasting(duration.max(0)));
    }
    histogram
}

/// Répartition par mode de transport (§3.4).
///
/// Utilise le mode **résolu** — donc corrigé par l'utilisateur le cas échéant
/// (§5.4, étape 3), jamais la détection brute.
pub fn modes(input: StatsInput<'_>) -> Histogram<TravelMode> {
    let mut histogram = Histogram::default();
    for resolved in input.segments {
        histogram.add(
            resolved.mode,
            Sample {
                duration_ms: (resolved.segment.end_ts_utc - resolved.segment.start_ts_utc).max(0),
                distance_m: resolved.segment.distance_m.unwrap_or_default(),
            },
        );
    }
    histogram
}

/// Patterns horaires (§3.4), indexés par heure locale.
pub fn hours(input: StatsInput<'_>) -> Histogram<u8> {
    let mut histogram = Histogram::default();
    for resolved in input.segments {
        histogram.add(
            local_hour(
                resolved.segment.start_ts_utc,
                resolved.segment.start_tz_offset_minutes,
            ),
            Sample::lasting((resolved.segment.end_ts_utc - resolved.segment.start_ts_utc).max(0)),
        );
    }
    for resolved in input.visits {
        histogram.add(
            local_hour(
                resolved.visit.arrival_ts_utc,
                resolved.visit.arrival_tz_offset_minutes,
            ),
            Sample::lasting(
                (resolved.visit.departure_ts_utc - resolved.visit.arrival_ts_utc).max(0),
            ),
        );
    }
    histogram
}

/// Patterns par jour de semaine (§3.4).
pub fn weekdays(input: StatsInput<'_>) -> Histogram<Weekday> {
    let mut histogram = Histogram::default();
    for resolved in input.segments {
        let date = LocalDate::from_utc_millis(
            resolved.segment.start_ts_utc,
            resolved.segment.start_tz_offset_minutes,
        );
        histogram.add(
            Weekday::of(date),
            Sample {
                duration_ms: (resolved.segment.end_ts_utc - resolved.segment.start_ts_utc).max(0),
                distance_m: resolved.segment.distance_m.unwrap_or_default(),
            },
        );
    }
    histogram
}

/// Distance totale parcourue, en mètres (§3.4).
///
/// La seule des six à ne pas être un histogramme : c'est une somme.
pub fn total_distance_m(input: StatsInput<'_>) -> f64 {
    input
        .segments
        .iter()
        .filter_map(|resolved| resolved.segment.distance_m)
        .sum()
}

/// Les six statistiques de §3.4, calculées d'un coup.
#[derive(Debug, Clone, PartialEq)]
pub struct StatsReport {
    /// Heatmap de densité.
    pub density: Histogram<GridCell>,
    /// Lieux visités : passages et temps passé.
    pub places: Histogram<PlaceKey>,
    /// Répartition par mode.
    pub modes: Histogram<TravelMode>,
    /// Patterns horaires.
    pub hours: Histogram<u8>,
    /// Patterns par jour de semaine.
    pub weekdays: Histogram<Weekday>,
    /// Distance totale, en mètres.
    pub total_distance_m: f64,
    /// Nombre d'arrêts retenus.
    pub visit_count: u64,
    /// Nombre de trajets retenus.
    pub segment_count: u64,
}

/// Calcule le rapport complet.
pub fn report(input: StatsInput<'_>, cell_size_deg: f64) -> StatsReport {
    StatsReport {
        density: density(input, cell_size_deg),
        places: places(input, cell_size_deg),
        modes: modes(input),
        hours: hours(input),
        weekdays: weekdays(input),
        total_distance_m: total_distance_m(input),
        visit_count: input.visits.len() as u64,
        segment_count: input.segments.len() as u64,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn jour_de_semaine_reference() {
        // 1970-01-01 était un jeudi.
        assert_eq!(Weekday::of(LocalDate(0)), Weekday::Thursday);
        assert_eq!(Weekday::of(LocalDate(3)), Weekday::Sunday);
        assert_eq!(Weekday::of(LocalDate(4)), Weekday::Monday);
    }

    #[test]
    fn jour_de_semaine_avant_1970() {
        assert_eq!(Weekday::of(LocalDate(-1)), Weekday::Wednesday);
    }

    #[test]
    fn heure_locale_depend_de_loffset() {
        // 2024-01-02T22:00Z : 23 h à Paris, 7 h à Tokyo.
        let utc = 1_704_232_800_000;
        assert_eq!(local_hour(utc, 60), 23);
        assert_eq!(local_hour(utc, 540), 7);
    }

    #[test]
    fn cellule_de_grille() {
        let cell = GridCell::of(48.8584, 2.2945, 0.01);
        assert_eq!(cell.lat_index, 4885);
        assert_eq!(cell.lon_index, 229);
    }

    #[test]
    fn cellule_de_grille_negative() {
        // L'arrondi doit aller vers le bas, pas vers zéro, sinon deux
        // positions de part et d'autre de l'équateur tombent dans la même case.
        let cell = GridCell::of(-0.005, -0.005, 0.01);
        assert_eq!(cell.lat_index, -1);
        assert_eq!(cell.lon_index, -1);
    }

    #[test]
    fn histogramme_cumule() {
        let mut histogram = Histogram::default();
        histogram.add("a", Sample::lasting(100));
        histogram.add("a", Sample::lasting(50));
        histogram.add("b", Sample::lasting(10));

        let ranked = histogram.ranked_by_duration();
        assert_eq!(ranked[0].0, "a");
        assert_eq!(ranked[0].1.count, 2);
        assert_eq!(ranked[0].1.duration_ms, 150);
    }

    #[test]
    fn classement_deterministe_a_egalite() {
        let mut histogram = Histogram::default();
        histogram.add("b", Sample::counted());
        histogram.add("a", Sample::counted());

        // À égalité de compte, l'ordre de clé tranche — sans quoi deux
        // exécutions produiraient deux classements.
        assert_eq!(histogram.ranked_by_count()[0].0, "a");
    }
}
