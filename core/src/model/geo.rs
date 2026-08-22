//! Référentiel de lieux embarqué (§5.3) — lecture seule.
//!
//! Extrait GeoNames filtré (villes ≥ 1000 habitants + POI notables), livré
//! avec l'app pour un reverse geocoding **offline** (§4). Aucun appel réseau :
//! c'est ce qui permet à la résolution de noms de tenir la promesse zéro
//! réseau (§2).
//!
//! Précision « ville + POI majeurs » assumée : le commerce du coin ne sera pas
//! résolu automatiquement, c'est exactement ce que
//! [`super::user::UserPlace`] vient compenser (§3.2).

/// Entrée du référentiel de lieux (§5.3).
#[derive(Debug, Clone, PartialEq)]
pub struct GeoPlace {
    /// Identifiant dans le référentiel embarqué.
    pub id: i64,
    /// Nom du lieu.
    pub name: String,
    /// Code pays ISO.
    pub country_code: String,
    /// Première subdivision administrative.
    pub admin1: Option<String>,
    /// Population, quand elle est connue — sert à départager deux lieux
    /// proches en faveur du plus notable.
    pub population: Option<i64>,
    /// Latitude.
    pub lat: f64,
    /// Longitude.
    pub lon: f64,
}
