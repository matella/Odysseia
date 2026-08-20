//! Pipeline de lecture — **point de passage unique** vers les données (§5.4).
//!
//! Ordre imposé, avant toute exploitation :
//! 1. filtrage des zones privées — **en amont de tout** (§3.7) ;
//! 2. résolution du nom de lieu : `user_place` → `geo_place` → coordonnées ;
//! 3. application des `user_segment_override` sur `detected_mode` ;
//! 4. filtres de la vue courante (période / lieu / mode — §3.4).
//!
//! Les trois vues (Récit, Stats, Vidéo) consomment la **même** sortie. Aucune
//! vue, aucun export, aucun rendu ne contourne les étapes 1 à 3.
