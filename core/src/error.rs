//! Types d'erreur dédiés, **un par cas** (§3.10).
//!
//! Règle : jamais d'erreur générique fourre-tout. Chaque cas (JSON corrompu,
//! export vide, format futur non reconnu, fichier trop volumineux...) a son
//! variant, pour que l'UI Flutter affiche un message spécifique et traduit,
//! et que l'app ne crashe jamais visiblement.
//!
//! Les messages `Display` portés ici sont destinés aux logs et au crash log
//! local (§3.10) : **ce ne sont pas** les messages affichés à l'utilisateur.
//! L'UI traduit par variant (§3.9), elle ne recopie jamais ce texte.

use thiserror::Error;

/// Erreur **fatale** : l'import ne peut pas aboutir.
#[derive(Debug, Clone, PartialEq, Eq, Error)]
pub enum ParseError {
    /// L'export ne contient aucune donnée exploitable (fichier vide, tableau
    /// vide, `semanticSegments` vide).
    #[error("l'export ne contient aucune donnée")]
    EmptyExport,

    /// Le fichier n'est pas du JSON valide.
    #[error("JSON invalide (ligne {line}, colonne {column}) : {detail}")]
    CorruptJson {
        /// Ligne où l'analyse a échoué, à partir de 1.
        line: usize,
        /// Colonne où l'analyse a échoué, à partir de 1.
        column: usize,
        /// Détail technique renvoyé par l'analyseur, pour le crash log.
        detail: String,
    },

    /// JSON valide, mais aucune structure d'export connue — typiquement un
    /// format Google futur.
    #[error("format d'export non reconnu (clés de premier niveau : {found:?})")]
    UnrecognisedFormat {
        /// Clés de premier niveau rencontrées, tronquées, pour diagnostic.
        found: Vec<String>,
    },

    /// Le fichier dépasse la limite fixée par l'appelant (§4).
    #[error("fichier trop volumineux : {size_bytes} octets (limite {limit_bytes})")]
    FileTooLarge {
        /// Nombre d'octets lus au moment du dépassement.
        size_bytes: u64,
        /// Limite appliquée.
        limit_bytes: u64,
    },

    /// Échec de lecture de la source.
    #[error("erreur de lecture : {detail}")]
    Io {
        /// Détail technique, pour le crash log.
        detail: String,
    },
}

/// Erreur **non fatale** : l'enregistrement est ignoré, l'import continue.
///
/// Un export réel contient des enregistrements aberrants ; les rejeter un par
/// un vaut mieux que faire échouer tout l'import (§3.10). Chaque rejet est
/// compté et remonté au `RecordSink`, jamais silencieux.
#[derive(Debug, Clone, PartialEq, Error)]
pub enum RecordError {
    /// Coordonnées absentes ou invalides.
    #[error(transparent)]
    Coord(#[from] CoordError),

    /// Horodatage absent ou invalide.
    #[error(transparent)]
    Time(#[from] TimeError),

    /// Enregistrement dont la forme n'est reconnue par aucun convertisseur.
    #[error("forme d'enregistrement inconnue")]
    UnknownShape,
}

/// Échec de normalisation d'une coordonnée (§5.1).
#[derive(Debug, Clone, PartialEq, Error)]
pub enum CoordError {
    /// Latitude hors de l'intervalle [-90, 90].
    #[error("latitude hors bornes : {0}")]
    LatitudeOutOfRange(f64),

    /// Longitude hors de l'intervalle [-180, 180].
    #[error("longitude hors bornes : {0}")]
    LongitudeOutOfRange(f64),

    /// Chaîne présente mais non interprétable (`geo:`, degrés, paire brute).
    #[error("coordonnée illisible : {0}")]
    Malformed(String),

    /// Aucune coordonnée trouvée dans l'enregistrement.
    #[error("coordonnée absente")]
    Missing,
}

/// Échec de normalisation d'un horodatage (§5.5).
#[derive(Debug, Clone, PartialEq, Error)]
pub enum TimeError {
    /// Chaîne présente mais non interprétable (ni RFC 3339, ni epoch).
    #[error("horodatage illisible : {0}")]
    Malformed(String),

    /// Horodatage absent de l'enregistrement.
    #[error("horodatage absent")]
    Missing,
}
