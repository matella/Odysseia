//! Génération des frames de la vidéo souvenir (§3.5).
//!
//! Les paramètres de personnalisation sont exposés en entrée **dès la
//! conception** (§3.5) : durée (15/30/45/60/75/90 s), plage de mois/années,
//! style visuel, template de titre.
//!
//! # Ce que ce module produit — et ne produit pas
//!
//! Il produit un **plan de frames** : pour chaque image, l'instant couvert et
//! la géométrie cumulée à afficher. Il ne produit pas de pixels et n'encode
//! pas de MP4 : le rendu graphique appartient à l'UI, et l'encodage à ffmpeg
//! (natif) ou `ffmpeg.wasm` (web), qui ne sont pas branchés.
//!
//! Ce découpage rend le plan **déterministe et testable sans encodeur** : à
//! données et paramètres égaux, deux exécutions donnent le même plan, ce qui
//! est exactement ce qu'exige un golden test (§3.10).
//!
//! # Entrée
//!
//! Le plan se calcule sur la sortie du pipeline (§5.4). Les zones privées sont
//! donc déjà exclues **des frames elles-mêmes** (§3.7) — pas masquées au
//! rendu.

use crate::pipeline::{ResolvedPoint, ResolvedSegment};

/// Durées proposées par l'UI, en secondes (§3.5).
pub const SUPPORTED_DURATIONS_S: [u32; 6] = [15, 30, 45, 60, 75, 90];

/// Images par seconde du plan.
pub const FRAMES_PER_SECOND: u32 = 30;

/// Style visuel demandé (§3.5).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[non_exhaustive]
pub enum VisualStyle {
    /// Rendu clair par défaut.
    Classic,
    /// Rendu sombre.
    Night,
    /// Trait seul, sans décor.
    Minimal,
}

/// Paramètres de génération (§3.5).
#[derive(Debug, Clone, PartialEq)]
pub struct RenderParams {
    /// Durée cible, en secondes.
    pub duration_s: u32,
    /// Début de la plage couverte, en millisecondes UTC.
    pub period_start_utc: i64,
    /// Fin de la plage couverte, en millisecondes UTC.
    pub period_end_utc: i64,
    /// Style visuel.
    pub style: VisualStyle,
    /// Titre, déjà interpolé par l'UI — le cœur ne fabrique pas de texte
    /// destiné à l'utilisateur (§3.9).
    pub title: String,
}

impl Default for RenderParams {
    fn default() -> Self {
        Self {
            duration_s: 30,
            period_start_utc: 0,
            period_end_utc: 0,
            style: VisualStyle::Classic,
            title: String::new(),
        }
    }
}

/// Erreurs de paramétrage (§3.10) — un cas, un variant.
#[derive(Debug, Clone, PartialEq, Eq)]
#[non_exhaustive]
pub enum RenderError {
    /// La durée demandée n'est pas dans [`SUPPORTED_DURATIONS_S`].
    UnsupportedDuration(u32),
    /// La plage demandée est vide ou inversée.
    EmptyPeriod,
    /// Aucune donnée à animer sur la plage.
    NothingToRender,
}

/// Une image du plan.
#[derive(Debug, Clone, PartialEq)]
pub struct Frame {
    /// Index, à partir de 0.
    pub index: u32,
    /// Instant couvert par cette image, en millisecondes UTC.
    pub timestamp_utc: i64,
    /// Nombre de positions révélées jusqu'ici — l'animation est cumulative,
    /// le tracé se dessine progressivement.
    pub revealed_points: u32,
    /// Nombre de trajets révélés jusqu'ici.
    pub revealed_segments: u32,
}

/// Plan complet.
#[derive(Debug, Clone, PartialEq)]
pub struct FramePlan {
    /// Images, dans l'ordre.
    pub frames: Vec<Frame>,
    /// Cadence.
    pub fps: u32,
    /// Style retenu.
    pub style: VisualStyle,
    /// Titre retenu.
    pub title: String,
}

impl FramePlan {
    /// Nombre d'images.
    pub fn len(&self) -> usize {
        self.frames.len()
    }

    /// Plan sans image.
    pub fn is_empty(&self) -> bool {
        self.frames.is_empty()
    }
}

/// Calcule le plan de frames.
///
/// L'animation est **cumulative** : chaque image révèle ce qui s'est produit
/// jusqu'à son instant, de sorte que le trajet se dessine au fil de la vidéo
/// plutôt que de clignoter.
pub fn plan(
    points: &[ResolvedPoint],
    segments: &[ResolvedSegment],
    params: &RenderParams,
) -> Result<FramePlan, RenderError> {
    if !SUPPORTED_DURATIONS_S.contains(&params.duration_s) {
        return Err(RenderError::UnsupportedDuration(params.duration_s));
    }
    if params.period_end_utc <= params.period_start_utc {
        return Err(RenderError::EmptyPeriod);
    }
    if points.is_empty() && segments.is_empty() {
        return Err(RenderError::NothingToRender);
    }

    let frame_count = params.duration_s * FRAMES_PER_SECOND;
    let span = params.period_end_utc - params.period_start_utc;

    // Tri par instant : les données arrivent du pipeline dans l'ordre de la
    // requête, pas forcément chronologique.
    let mut point_times: Vec<i64> = points
        .iter()
        .map(|resolved| resolved.point.timestamp_utc)
        .collect();
    point_times.sort_unstable();

    let mut segment_times: Vec<i64> = segments
        .iter()
        .map(|resolved| resolved.segment.start_ts_utc)
        .collect();
    segment_times.sort_unstable();

    let frames = (0..frame_count)
        .map(|index| {
            // `index + 1` sur `frame_count` : la dernière image couvre la fin
            // de la période, sinon la vidéo s'arrête juste avant.
            let progress = f64::from(index + 1) / f64::from(frame_count);
            let timestamp_utc = params.period_start_utc + (span as f64 * progress) as i64;

            Frame {
                index,
                timestamp_utc,
                revealed_points: count_until(&point_times, timestamp_utc),
                revealed_segments: count_until(&segment_times, timestamp_utc),
            }
        })
        .collect();

    Ok(FramePlan {
        frames,
        fps: FRAMES_PER_SECOND,
        style: params.style,
        title: params.title.clone(),
    })
}

/// Nombre d'instants triés situés à `limit` ou avant.
fn count_until(sorted: &[i64], limit: i64) -> u32 {
    sorted.partition_point(|instant| *instant <= limit) as u32
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::model::{RawPoint, SourceKind};

    fn point_at(timestamp_utc: i64) -> ResolvedPoint {
        ResolvedPoint {
            point: RawPoint {
                timestamp_utc,
                tz_offset_minutes: 0,
                lat: 48.0,
                lon: 2.0,
                accuracy_m: None,
                altitude_m: None,
                speed_ms: None,
                source_kind: SourceKind::GoogleTimeline,
            },
        }
    }

    fn params() -> RenderParams {
        RenderParams {
            duration_s: 15,
            period_start_utc: 0,
            period_end_utc: 1_000,
            style: VisualStyle::Classic,
            title: "Test".to_string(),
        }
    }

    #[test]
    fn nombre_dimages_suit_la_duree() {
        let plan = plan(&[point_at(500)], &[], &params()).unwrap();
        assert_eq!(plan.len() as u32, 15 * FRAMES_PER_SECOND);
    }

    #[test]
    fn la_revelation_est_cumulative_et_monotone() {
        let points = [point_at(100), point_at(500), point_at(900)];
        let plan = plan(&points, &[], &params()).unwrap();

        let mut previous = 0;
        for frame in &plan.frames {
            assert!(frame.revealed_points >= previous);
            previous = frame.revealed_points;
        }
        assert_eq!(plan.frames.last().unwrap().revealed_points, 3);
    }

    #[test]
    fn la_derniere_image_couvre_la_fin_de_periode() {
        let plan = plan(&[point_at(1_000)], &[], &params()).unwrap();
        assert_eq!(plan.frames.last().unwrap().timestamp_utc, 1_000);
    }

    #[test]
    fn plan_deterministe() {
        let points = [point_at(100), point_at(900)];
        assert_eq!(
            plan(&points, &[], &params()).unwrap(),
            plan(&points, &[], &params()).unwrap()
        );
    }

    #[test]
    fn duree_non_supportee_rejetee() {
        let mut params = params();
        params.duration_s = 42;
        assert_eq!(
            plan(&[point_at(1)], &[], &params),
            Err(RenderError::UnsupportedDuration(42))
        );
    }

    #[test]
    fn periode_vide_rejetee() {
        let mut params = params();
        params.period_end_utc = params.period_start_utc;
        assert_eq!(
            plan(&[point_at(1)], &[], &params),
            Err(RenderError::EmptyPeriod)
        );
    }

    #[test]
    fn absence_de_donnees_rejetee() {
        assert_eq!(plan(&[], &[], &params()), Err(RenderError::NothingToRender));
    }

    #[test]
    fn ordre_dentree_sans_importance() {
        // Le pipeline ne garantit pas l'ordre chronologique.
        let desordre = [point_at(900), point_at(100), point_at(500)];
        let ordre = [point_at(100), point_at(500), point_at(900)];
        assert_eq!(
            plan(&desordre, &[], &params()).unwrap(),
            plan(&ordre, &[], &params()).unwrap()
        );
    }
}
