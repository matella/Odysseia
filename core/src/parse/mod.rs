//! Import de données : trait commun, générique par source (§3.1).
//!
//! Le parsing Google n'est qu'**une** implémentation parmi d'autres
//! (GPX, Strava, fitness plus tard). Parsing en streaming obligatoire :
//! ne jamais charger tout le JSON en mémoire (§4).

pub mod coords;
pub mod google;
