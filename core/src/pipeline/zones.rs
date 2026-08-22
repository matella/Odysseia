//! Étape 1 du pipeline : filtrage des zones privées (§3.7, §5.4).
//!
//! **En amont de tout.** Une donnée située dans une zone privée n'existe pas
//! pour la suite de la chaîne : elle est absente des stats, des frames vidéo
//! et de l'export, pas seulement masquée à l'écran. Si un chemin de code peut
//! observer une donnée avant cette étape, ce chemin est faux.

use crate::model::{PrivateZone, ZoneShape};

use super::geometry::{in_circle, in_polygon};

/// Ensemble des zones privées, prêt à filtrer.
#[derive(Debug, Default, Clone)]
pub struct ZoneFilter<'a> {
    zones: &'a [PrivateZone],
}

impl<'a> ZoneFilter<'a> {
    /// Construit le filtre à partir des zones de l'utilisateur.
    pub fn new(zones: &'a [PrivateZone]) -> Self {
        Self { zones }
    }

    /// La position est-elle dans une zone privée ?
    pub fn is_private(&self, lat: f64, lon: f64) -> bool {
        self.zones.iter().any(|zone| match &zone.shape {
            ZoneShape::Circle {
                lat: clat,
                lon: clon,
                radius_m,
            } => in_circle(lat, lon, *clat, *clon, *radius_m),
            ZoneShape::Polygon { vertices } => in_polygon(lat, lon, vertices),
        })
    }

    /// La position est-elle exploitable ?
    pub fn allows(&self, lat: f64, lon: f64) -> bool {
        !self.is_private(lat, lon)
    }

    /// Le trajet est-il exploitable ?
    ///
    /// Un segment dont **une seule** extrémité tombe dans une zone privée est
    /// écarté en entier : le conserver publierait la coordonnée que
    /// l'utilisateur a précisément demandé de cacher. Perdre le trajet est le
    /// prix de la garantie « appliquée à la source » (§3.7).
    pub fn allows_segment(
        &self,
        start_lat: f64,
        start_lon: f64,
        end_lat: f64,
        end_lon: f64,
    ) -> bool {
        self.allows(start_lat, start_lon) && self.allows(end_lat, end_lon)
    }

    /// Nombre de zones actives.
    pub fn len(&self) -> usize {
        self.zones.len()
    }

    /// Aucune zone privée définie.
    pub fn is_empty(&self) -> bool {
        self.zones.is_empty()
    }
}
