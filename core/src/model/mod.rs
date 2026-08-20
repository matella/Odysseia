//! Modèle de données (§5) : `RawPoint`, `Segment`, `Visit`, `UserPlace`,
//! `PrivateZone`, `ImportBatch`...
//!
//! Deux zones strictement séparées :
//! - **importée** (§5.1) — remplacée à chaque import ;
//! - **utilisateur** (§5.2) — survit à tout ré-import, ne référence jamais un
//!   id de la zone importée.
//!
//! Le modèle n'est pas calqué sur le format Google : une notion de source
//! existe dès le départ (§3.1). Temps stocké en UTC + offset séparé (§5.5).
