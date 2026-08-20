//! Types d'erreur dédiés, **un par cas** (§3.10).
//!
//! Règle : jamais d'erreur générique fourre-tout. Chaque cas (JSON corrompu,
//! export vide, format futur non reconnu, fichier trop volumineux...) a son
//! variant, pour que l'UI Flutter affiche un message spécifique et traduit,
//! et que l'app ne crashe jamais visiblement.
