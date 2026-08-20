//! Génération des frames de la vidéo souvenir (§3.5).
//!
//! Les paramètres de personnalisation sont exposés en entrée **dès la
//! conception** : durée (15/30/45/60/75/90 s), plage de mois/années, style
//! visuel, template de titre.
//!
//! L'entrée provient du pipeline (§5.4) : les zones privées sont donc déjà
//! exclues des frames, pas masquées à l'affichage (§3.7).
