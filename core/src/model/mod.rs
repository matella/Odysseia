//! Modèle de données (§5).
//!
//! Le principe directeur du schéma est une **frontière**, pas une
//! convention de nommage :
//!
//! | Zone | Module | Ré-import |
//! | --- | --- | --- |
//! | importée (§5.1) | [`imported`] | vidée et reconstruite |
//! | utilisateur (§5.2) | [`user`] | **jamais touchée** |
//! | référentiel (§5.3) | [`geo`] | embarqué, lecture seule |
//!
//! Cette séparation est vérifiable au niveau du type : **aucune structure de
//! [`user`] ne contient d'identifiant issu de [`imported`]**. Un ré-import
//! change tous les identifiants de la zone importée (§3.1) ; une donnée
//! utilisateur qui en référencerait un serait cassée à chaque mise à jour de
//! l'export. Le rattachement est donc géographique ([`user::UserPlace`],
//! [`user::PrivateZone`]) ou par empreinte tolérante
//! ([`user::UserSegmentOverride`], §4).
//!
//! Toute la lecture de ces données passe par [`crate::pipeline`] (§5.4).

pub mod geo;
pub mod imported;
pub mod user;

pub use geo::GeoPlace;
pub use imported::{ImportBatch, RawPoint, Segment, SourceFormat, SourceKind, TravelMode, Visit};
pub use user::{
    AppSetting, LocalDate, OVERRIDE_COORD_DECIMALS, PrivateZone, UserPlace, UserSegmentOverride,
    ZoneShape,
};
