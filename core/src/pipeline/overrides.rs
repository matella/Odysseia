//! Étape 3 du pipeline : application des corrections de mode (§5.4).
//!
//! `detected_mode` garde **toujours** sa valeur d'origine (§5.1). La
//! correction de l'utilisateur vit dans `user_segment_override` (§5.2) et est
//! appliquée ici, à la lecture — jamais réécrite par-dessus la détection.
//!
//! # Empreinte tolérante (§4)
//!
//! La clé d'appariement est (date locale, extrémités arrondies), **sans les
//! bornes temporelles exactes du segment**. C'est ce qui permet à une
//! correction de survivre à un ré-import qui redécoupe légèrement le trajet :
//! les identifiants ont changé, les horaires ont bougé de quelques minutes,
//! mais l'empreinte, elle, tient.
//!
//! Les corrections orphelines — celles dont le trajet a disparu de l'export —
//! sont **conservées, inactives** (§4). Jamais supprimées automatiquement :
//! un export plus court ne doit pas détruire le travail de l'utilisateur.

use std::collections::HashMap;

use crate::model::{LocalDate, OVERRIDE_COORD_DECIMALS, Segment, TravelMode, UserSegmentOverride};

/// Clé d'appariement d'un trajet, volontairement grossière (§4).
///
/// Coordonnées en virgule fixe : l'arrondi devient exact et comparable, là où
/// deux `f64` « égaux » ne le sont pas toujours.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Fingerprint {
    /// Date locale du trajet.
    pub local_date: LocalDate,
    /// Latitude de départ, en virgule fixe.
    pub start_lat: i64,
    /// Longitude de départ, en virgule fixe.
    pub start_lon: i64,
    /// Latitude d'arrivée, en virgule fixe.
    pub end_lat: i64,
    /// Longitude d'arrivée, en virgule fixe.
    pub end_lon: i64,
}

impl Fingerprint {
    fn fixed(value: f64) -> i64 {
        let factor = 10f64.powi(OVERRIDE_COORD_DECIMALS as i32);
        (value * factor).round() as i64
    }

    /// Empreinte d'un segment importé.
    pub fn of_segment(segment: &Segment) -> Self {
        Self {
            local_date: LocalDate::from_utc_millis(
                segment.start_ts_utc,
                segment.start_tz_offset_minutes,
            ),
            start_lat: Self::fixed(segment.start_lat),
            start_lon: Self::fixed(segment.start_lon),
            end_lat: Self::fixed(segment.end_lat),
            end_lon: Self::fixed(segment.end_lon),
        }
    }

    /// Empreinte d'une correction utilisateur.
    pub fn of_override(correction: &UserSegmentOverride) -> Self {
        Self {
            local_date: correction.local_date,
            start_lat: Self::fixed(correction.start_lat_r),
            start_lon: Self::fixed(correction.start_lon_r),
            end_lat: Self::fixed(correction.end_lat_r),
            end_lon: Self::fixed(correction.end_lon_r),
        }
    }
}

/// Résultat de l'appariement sur un lot de segments.
#[derive(Debug, Clone, PartialEq)]
pub struct OverrideAssignment {
    corrections: Vec<Option<TravelMode>>,
    matched_override_ids: Vec<i64>,
}

impl OverrideAssignment {
    /// Mode corrigé du segment d'indice `index`, s'il y en a un.
    pub fn mode_for(&self, index: usize) -> Option<TravelMode> {
        self.corrections.get(index).copied().flatten()
    }

    /// Identifiants des corrections effectivement appliquées.
    pub fn matched_override_ids(&self) -> &[i64] {
        &self.matched_override_ids
    }

    /// Corrections **orphelines** : conservées, inactives (§4).
    ///
    /// Leur trajet n'existe pas dans le lot analysé — export plus court,
    /// journée absente, trajet supprimé par Google. Elles restent en base et
    /// se réactiveront d'elles-mêmes si un import futur ramène le trajet.
    pub fn orphans<'a>(&self, all: &'a [UserSegmentOverride]) -> Vec<&'a UserSegmentOverride> {
        all.iter()
            .filter(|correction| !self.matched_override_ids.contains(&correction.id))
            .collect()
    }
}

/// Applique les corrections à un lot de segments.
///
/// Travaille par **lot** et non segment par segment : §4 impose, en cas
/// d'empreintes multiples le même jour, d'appliquer la correction au segment
/// temporellement le plus proche — ce qui suppose de voir les candidats
/// ensemble. Le lot naturel est la période affichée (§3.3), toujours bornée.
#[derive(Debug, Clone, Copy)]
pub struct OverrideResolver<'a> {
    overrides: &'a [UserSegmentOverride],
}

impl<'a> OverrideResolver<'a> {
    /// Construit le résolveur.
    pub fn new(overrides: &'a [UserSegmentOverride]) -> Self {
        Self { overrides }
    }

    /// Corrections connues du résolveur.
    pub fn overrides(&self) -> &'a [UserSegmentOverride] {
        self.overrides
    }

    /// Apparie les corrections aux segments du lot.
    pub fn assign(&self, segments: &[Segment]) -> OverrideAssignment {
        let mut by_fingerprint: HashMap<Fingerprint, Vec<usize>> = HashMap::new();
        for (index, segment) in segments.iter().enumerate() {
            by_fingerprint
                .entry(Fingerprint::of_segment(segment))
                .or_default()
                .push(index);
        }

        // Propriétaire courant de chaque segment : (mode, id de la correction,
        // écart temporel). Une correction plus proche déloge la précédente,
        // qui redevient orpheline — d'où le fait de ne dresser la liste des
        // corrections appliquées qu'à la fin.
        let mut owners: Vec<Option<(TravelMode, i64, i64)>> = vec![None; segments.len()];

        for correction in self.overrides {
            let Some(candidates) = by_fingerprint.get(&Fingerprint::of_override(correction)) else {
                continue;
            };

            // §4 : « appliquer au segment temporellement le plus proche ».
            let Some((index, gap)) = candidates
                .iter()
                .map(|&index| {
                    let gap = (segments[index].start_ts_utc - correction.source_start_ts_utc).abs();
                    (index, gap)
                })
                .min_by_key(|(_, gap)| *gap)
            else {
                continue;
            };

            if owners[index].is_none_or(|(_, _, previous)| gap < previous) {
                owners[index] = Some((correction.corrected_mode, correction.id, gap));
            }
        }

        let corrections = owners
            .iter()
            .map(|owner| owner.map(|(mode, _, _)| mode))
            .collect();
        let matched_override_ids = owners
            .iter()
            .filter_map(|owner| owner.map(|(_, id, _)| id))
            .collect();

        OverrideAssignment {
            corrections,
            matched_override_ids,
        }
    }
}
