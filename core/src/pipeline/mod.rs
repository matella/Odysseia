//! Pipeline de lecture — **point de passage unique** vers les données (§5.4).
//!
//! Ordre imposé, avant toute exploitation :
//! 1. filtrage des zones privées — **en amont de tout** ([`zones`], §3.7) ;
//! 2. résolution du nom de lieu : `user_place` → `geo_place` → coordonnées
//!    ([`places`]) ;
//! 3. application des `user_segment_override` sur `detected_mode`
//!    ([`overrides`]) ;
//! 4. filtres de la vue courante (période / lieu / mode — §3.4).
//!
//! Les trois vues (Récit, Stats, Vidéo) consomment la **même** sortie. Aucune
//! vue, aucun export, aucun rendu ne contourne les étapes 1 à 3.
//!
//! # Pourquoi cet ordre n'est pas négociable
//!
//! Le filtrage des zones privées vient en premier pour que rien en aval — pas
//! même un total de statistiques ou une frame vidéo — ne puisse observer une
//! donnée que l'utilisateur a exclue (§3.7). Les étapes 2 et 3 précèdent les
//! filtres de vue parce qu'on filtre sur les valeurs *résolues* : demander
//! « mes trajets à vélo » doit tenir compte des corrections manuelles, et
//! « à la Maison » du nom donné par l'utilisateur.
//!
//! # Granularité
//!
//! Les points et les visites se traitent un par un : c'est du streaming.
//! Les segments se traitent **par lot**, parce que l'appariement des
//! corrections a besoin de voir les candidats d'une même journée ensemble
//! (§4) — voir [`overrides::OverrideResolver::assign`]. Le lot naturel est la
//! période affichée (§3.3), toujours bornée.

pub mod geometry;
pub mod overrides;
pub mod places;
pub mod zones;

use crate::model::{
    PrivateZone, RawPoint, Segment, TravelMode, UserPlace, UserSegmentOverride, Visit,
};

use overrides::OverrideResolver;
use places::{PlaceLookup, PlaceResolver, PlaceSource, ResolvedPlace};
use zones::ZoneFilter;

/// Fenêtre temporelle d'une vue, en millisecondes UTC.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Period {
    /// Début inclus.
    pub start_utc: i64,
    /// Fin incluse.
    pub end_utc: i64,
}

impl Period {
    /// L'instant tombe-t-il dans la période ?
    pub fn contains(&self, utc_millis: i64) -> bool {
        (self.start_utc..=self.end_utc).contains(&utc_millis)
    }

    /// La période recouvre-t-elle l'intervalle ?
    pub fn overlaps(&self, start_utc: i64, end_utc: i64) -> bool {
        start_utc <= self.end_utc && end_utc >= self.start_utc
    }
}

/// Filtre par lieu — sur le lieu **résolu**, pas sur des coordonnées.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PlaceFilter {
    /// Un lieu nommé par l'utilisateur (§5.2).
    UserPlace(i64),
    /// Un lieu du référentiel embarqué (§5.3).
    GeoPlace(i64),
}

impl PlaceFilter {
    fn matches(&self, place: &ResolvedPlace) -> bool {
        match (self, &place.source) {
            (Self::UserPlace(wanted), PlaceSource::UserPlace { id }) => wanted == id,
            (Self::GeoPlace(wanted), PlaceSource::GeoPlace { id }) => wanted == id,
            _ => false,
        }
    }
}

/// Filtres de la vue courante (§3.4), combinables entre eux.
#[derive(Debug, Default, Clone)]
pub struct ViewFilters {
    /// Restriction temporelle.
    pub period: Option<Period>,
    /// Restriction géographique, sur le lieu résolu.
    pub place: Option<PlaceFilter>,
    /// Restriction par mode de transport.
    ///
    /// Ne s'applique **qu'aux segments** : un mode n'a pas de sens pour un
    /// arrêt. « Mon temps passé à la Maison, à vélo » n'aurait aucun sens et
    /// viderait la vue Récit ; les visites traversent donc ce filtre.
    pub modes: Option<Vec<TravelMode>>,
}

impl ViewFilters {
    fn allows_mode(&self, mode: TravelMode) -> bool {
        self.modes
            .as_ref()
            .is_none_or(|allowed| allowed.contains(&mode))
    }

    fn allows_place(&self, place: &ResolvedPlace) -> bool {
        self.place
            .as_ref()
            .is_none_or(|filter| filter.matches(place))
    }
}

/// Position après passage du pipeline.
#[derive(Debug, Clone, PartialEq)]
pub struct ResolvedPoint {
    /// Position brute d'origine.
    pub point: RawPoint,
}

/// Arrêt après passage du pipeline.
#[derive(Debug, Clone, PartialEq)]
pub struct ResolvedVisit {
    /// Arrêt d'origine.
    pub visit: Visit,
    /// Nom résolu selon l'ordre §5.4.
    pub place: ResolvedPlace,
}

/// Trajet après passage du pipeline.
#[derive(Debug, Clone, PartialEq)]
pub struct ResolvedSegment {
    /// Trajet d'origine — `detected_mode` y garde sa valeur importée (§5.1).
    pub segment: Segment,
    /// Mode à afficher : la correction utilisateur si elle existe, sinon la
    /// détection.
    pub mode: TravelMode,
    /// Une correction utilisateur a-t-elle été appliquée ?
    pub corrected: bool,
    /// Nom résolu du départ.
    pub start_place: ResolvedPlace,
    /// Nom résolu de l'arrivée.
    pub end_place: ResolvedPlace,
}

/// Sortie de l'étape 3 pour un lot de segments, corrections orphelines
/// comprises.
#[derive(Debug, Clone, PartialEq)]
pub struct SegmentBatch {
    /// Trajets retenus, dans l'ordre d'entrée.
    pub segments: Vec<ResolvedSegment>,
    /// Identifiants des corrections restées **inactives** sur ce lot (§4) —
    /// conservées en base, jamais supprimées.
    pub orphan_override_ids: Vec<i64>,
}

/// Le pipeline §5.4.
///
/// Construit à partir de la zone utilisateur (§5.2) et du référentiel (§5.3),
/// puis appliqué aux données importées (§5.1). C'est le **seul** chemin
/// légitime vers les données Timeline.
pub struct Pipeline<'a> {
    zones: ZoneFilter<'a>,
    resolver: PlaceResolver<'a>,
    overrides: OverrideResolver<'a>,
    filters: &'a ViewFilters,
}

impl<'a> Pipeline<'a> {
    /// Construit le pipeline.
    pub fn new(
        private_zones: &'a [PrivateZone],
        user_places: &'a [UserPlace],
        segment_overrides: &'a [UserSegmentOverride],
        lookup: &'a dyn PlaceLookup,
        filters: &'a ViewFilters,
    ) -> Self {
        Self {
            zones: ZoneFilter::new(private_zones),
            resolver: PlaceResolver::new(user_places, lookup),
            overrides: OverrideResolver::new(segment_overrides),
            filters,
        }
    }

    /// Traite une position. `None` = écartée.
    pub fn point(&self, point: &RawPoint) -> Option<ResolvedPoint> {
        // 1. zones privées, avant tout le reste
        if !self.zones.allows(point.lat, point.lon) {
            return None;
        }
        // 4. filtres de vue (2 et 3 ne s'appliquent pas à un point brut)
        if let Some(period) = self.filters.period
            && !period.contains(point.timestamp_utc)
        {
            return None;
        }
        if self.filters.place.is_some() {
            let place = self.resolver.resolve(point.lat, point.lon);
            if !self.filters.allows_place(&place) {
                return None;
            }
        }
        Some(ResolvedPoint {
            point: point.clone(),
        })
    }

    /// Traite un arrêt. `None` = écarté.
    pub fn visit(&self, visit: &Visit) -> Option<ResolvedVisit> {
        if !self.zones.allows(visit.lat, visit.lon) {
            return None;
        }
        let place = self.resolver.resolve(visit.lat, visit.lon);

        if let Some(period) = self.filters.period
            && !period.overlaps(visit.arrival_ts_utc, visit.departure_ts_utc)
        {
            return None;
        }
        if !self.filters.allows_place(&place) {
            return None;
        }

        Some(ResolvedVisit {
            visit: visit.clone(),
            place,
        })
    }

    /// Traite un lot de trajets.
    ///
    /// Le lot est nécessaire à l'étape 3 : voir
    /// [`overrides::OverrideResolver::assign`].
    pub fn segments(&self, segments: &[Segment]) -> SegmentBatch {
        // 1. zones privées, avant tout le reste. Le filtrage précède
        //    l'appariement des corrections : une correction portant sur un
        //    trajet privé ne doit pas ressortir dans les orphelines pour
        //    autant — elle est simplement sans objet dans cette vue.
        let visible: Vec<Segment> = segments
            .iter()
            .filter(|segment| {
                self.zones.allows_segment(
                    segment.start_lat,
                    segment.start_lon,
                    segment.end_lat,
                    segment.end_lon,
                )
            })
            .cloned()
            .collect();

        // 3. corrections utilisateur
        let assignment = self.overrides.assign(&visible);

        let mut resolved = Vec::with_capacity(visible.len());
        for (index, segment) in visible.iter().enumerate() {
            let correction = assignment.mode_for(index);
            let mode = correction.unwrap_or(segment.detected_mode);

            // 2. noms de lieux
            let start_place = self.resolver.resolve(segment.start_lat, segment.start_lon);
            let end_place = self.resolver.resolve(segment.end_lat, segment.end_lon);

            // 4. filtres de vue, sur les valeurs résolues
            if let Some(period) = self.filters.period
                && !period.overlaps(segment.start_ts_utc, segment.end_ts_utc)
            {
                continue;
            }
            if !self.filters.allows_mode(mode) {
                continue;
            }
            if self.filters.place.is_some()
                && !(self.filters.allows_place(&start_place)
                    || self.filters.allows_place(&end_place))
            {
                continue;
            }

            resolved.push(ResolvedSegment {
                segment: segment.clone(),
                mode,
                corrected: correction.is_some(),
                start_place,
                end_place,
            });
        }

        let orphan_override_ids = assignment
            .orphans(self.overrides_slice())
            .iter()
            .map(|correction| correction.id)
            .collect();

        SegmentBatch {
            segments: resolved,
            orphan_override_ids,
        }
    }

    /// Traite un lot de positions.
    pub fn points(&self, points: &[RawPoint]) -> Vec<ResolvedPoint> {
        points
            .iter()
            .filter_map(|point| self.point(point))
            .collect()
    }

    /// Traite un lot d'arrêts.
    pub fn visits(&self, visits: &[Visit]) -> Vec<ResolvedVisit> {
        visits
            .iter()
            .filter_map(|visit| self.visit(visit))
            .collect()
    }

    fn overrides_slice(&self) -> &'a [UserSegmentOverride] {
        self.overrides.overrides()
    }
}
