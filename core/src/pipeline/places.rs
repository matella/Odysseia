//! Étape 2 du pipeline : résolution du nom de lieu (§5.4).
//!
//! Ordre imposé : `user_place` (prioritaire) → `geo_place` → coordonnées
//! brutes en dernier recours. Le nom donné par l'utilisateur gagne toujours —
//! c'est ce qui rend « Maison » stable d'un import à l'autre (§5.2).

use crate::model::UserPlace;

use super::geometry::haversine_m;

/// Distance maximale au-delà de laquelle un lieu du référentiel embarqué
/// n'est plus pertinent, en mètres.
///
/// Le référentiel est filtré « villes ≥ 1000 habitants + POI notables »
/// (§5.3) : en zone peu dense, le plus proche voisin peut être à des dizaines
/// de kilomètres. Mieux vaut alors afficher les coordonnées que d'affirmer une
/// ville où l'utilisateur n'est jamais allé.
pub const MAX_GEO_PLACE_DISTANCE_M: f64 = 25_000.0;

/// D'où vient le nom retenu.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PlaceSource {
    /// Nommé par l'utilisateur (§5.2).
    UserPlace {
        /// Identifiant du lieu utilisateur.
        id: i64,
    },
    /// Issu du référentiel embarqué (§5.3).
    GeoPlace {
        /// Identifiant dans le référentiel.
        id: i64,
    },
    /// Aucun nom : coordonnées brutes, dernier recours (§5.4).
    Coordinates,
}

/// Nom de lieu résolu.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ResolvedPlace {
    /// Libellé affichable, absent si l'on retombe sur les coordonnées.
    pub label: Option<String>,
    /// Provenance du libellé.
    pub source: PlaceSource,
}

impl ResolvedPlace {
    /// Résolution par défaut, sans nom.
    pub fn coordinates() -> Self {
        Self {
            label: None,
            source: PlaceSource::Coordinates,
        }
    }
}

/// Accès au référentiel embarqué (§5.3).
///
/// Déclaré ici et implémenté par [`crate::geocode`] : le pipeline dépend d'un
/// contrat, pas d'une structure d'index. Cela permet aussi de tester les
/// étapes 2 à 4 sans embarquer la base GeoNames.
pub trait PlaceLookup {
    /// Lieu du référentiel le plus proche, avec sa distance en mètres.
    fn nearest(&self, lat: f64, lon: f64) -> Option<(i64, String, f64)>;
}

/// Référentiel vide — utile tant que la base GeoNames n'est pas branchée, et
/// pour les tests qui ne portent pas sur le geocoding.
#[derive(Debug, Default, Clone, Copy)]
pub struct NoPlaceLookup;

impl PlaceLookup for NoPlaceLookup {
    fn nearest(&self, _lat: f64, _lon: f64) -> Option<(i64, String, f64)> {
        None
    }
}

/// Résolveur de noms, dans l'ordre imposé par §5.4.
pub struct PlaceResolver<'a> {
    places: &'a [UserPlace],
    lookup: &'a dyn PlaceLookup,
}

impl<'a> PlaceResolver<'a> {
    /// Construit le résolveur.
    pub fn new(places: &'a [UserPlace], lookup: &'a dyn PlaceLookup) -> Self {
        Self { places, lookup }
    }

    /// Résout le nom d'une position.
    pub fn resolve(&self, lat: f64, lon: f64) -> ResolvedPlace {
        if let Some(place) = self.nearest_user_place(lat, lon) {
            return ResolvedPlace {
                label: Some(place.label.clone()),
                source: PlaceSource::UserPlace { id: place.id },
            };
        }

        if let Some((id, name, distance)) = self.lookup.nearest(lat, lon)
            && distance <= MAX_GEO_PLACE_DISTANCE_M
        {
            return ResolvedPlace {
                label: Some(name),
                source: PlaceSource::GeoPlace { id },
            };
        }

        ResolvedPlace::coordinates()
    }

    /// Lieu utilisateur contenant la position — le plus proche centre si
    /// plusieurs rayons se chevauchent.
    fn nearest_user_place(&self, lat: f64, lon: f64) -> Option<&'a UserPlace> {
        self.places
            .iter()
            .filter_map(|place| {
                let distance = haversine_m(lat, lon, place.lat, place.lon);
                (distance <= place.radius_m).then_some((place, distance))
            })
            .min_by(|(_, a), (_, b)| a.total_cmp(b))
            .map(|(place, _)| place)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    struct FixedLookup(f64);

    impl PlaceLookup for FixedLookup {
        fn nearest(&self, _lat: f64, _lon: f64) -> Option<(i64, String, f64)> {
            Some((7, "Paris".to_string(), self.0))
        }
    }

    fn user_place(id: i64, label: &str, lat: f64, lon: f64, radius_m: f64) -> UserPlace {
        UserPlace {
            id,
            label: label.to_string(),
            lat,
            lon,
            radius_m,
        }
    }

    #[test]
    fn le_lieu_utilisateur_prime_sur_le_referentiel() {
        let places = [user_place(1, "Maison", 48.8584, 2.2945, 200.0)];
        let lookup = FixedLookup(10.0);
        let resolver = PlaceResolver::new(&places, &lookup);

        let resolved = resolver.resolve(48.8584, 2.2945);
        assert_eq!(resolved.label.as_deref(), Some("Maison"));
        assert_eq!(resolved.source, PlaceSource::UserPlace { id: 1 });
    }

    #[test]
    fn le_referentiel_prend_le_relais_hors_rayon() {
        let places = [user_place(1, "Maison", 48.8584, 2.2945, 50.0)];
        let lookup = FixedLookup(120.0);
        let resolver = PlaceResolver::new(&places, &lookup);

        let resolved = resolver.resolve(45.7640, 4.8357);
        assert_eq!(resolved.source, PlaceSource::GeoPlace { id: 7 });
    }

    #[test]
    fn les_coordonnees_sont_le_dernier_recours() {
        let lookup = FixedLookup(MAX_GEO_PLACE_DISTANCE_M + 1.0);
        let resolver = PlaceResolver::new(&[], &lookup);

        let resolved = resolver.resolve(0.0, 0.0);
        assert_eq!(resolved, ResolvedPlace::coordinates());
    }

    #[test]
    fn rayons_qui_se_chevauchent_le_plus_proche_gagne() {
        let places = [
            user_place(1, "Quartier", 48.8600, 2.2945, 5_000.0),
            user_place(2, "Maison", 48.8584, 2.2945, 5_000.0),
        ];
        let resolver = PlaceResolver::new(&places, &NoPlaceLookup);

        let resolved = resolver.resolve(48.8584, 2.2945);
        assert_eq!(resolved.label.as_deref(), Some("Maison"));
    }
}
