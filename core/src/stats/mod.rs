//! Agrégations composables (§3.4).
//!
//! Une couche générique, pas six calculs ad hoc : heatmap de densité,
//! classement des lieux, temps par lieu, patterns horaires/jour de semaine,
//! distance totale, répartition par mode.
//!
//! Les stats sont des requêtes sur le flux filtré du pipeline (§5.4), pas des
//! tables pré-calculées figées — les filtres (période / lieu / mode) sont
//! combinables.
