//! Reverse geocoding **offline** dans `geo_place` (§3.2, §5.3).
//!
//! Recherche du plus proche voisin dans un extrait GeoNames filtré et embarqué
//! (villes ≥ 1000 hab. + POI notables). Précision « ville + POI majeurs » : les
//! lieux du quotidien sont nommés par l'utilisateur (`user_place`, §5.2).
//! Aucun appel réseau.
