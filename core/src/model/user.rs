//! Zone **utilisateur** (§5.2) — précieuse, jamais écrasée.
//!
//! Ces structures survivent à tout ré-import. C'est la conséquence directe de
//! « un nouvel import remplace tout » (§3.1) : si l'utilisateur perdait ses
//! lieux nommés et ses zones privées à chaque mise à jour de son export, la
//! fonctionnalité serait inutilisable.
//!
//! # Règle structurante
//!
//! **Rien ici ne référence un identifiant de [`super::imported`]**, qui change
//! à chaque import. Le rattachement se fait :
//!
//! - **géographiquement** — une visite appartient à un [`UserPlace`] si elle
//!   tombe dans son rayon ; un point est privé s'il tombe dans une
//!   [`PrivateZone`] ;
//! - **par empreinte tolérante** — un [`UserSegmentOverride`] retrouve son
//!   trajet par (date locale + extrémités arrondies), sans dépendre des bornes
//!   temporelles exactes du segment (§4).

/// Date locale, en jours depuis l'epoch.
///
/// Volontairement **locale** et non UTC : une correction faite « le mardi »
/// doit rester attachée au mardi de l'utilisateur, quel que soit le fuseau
/// depuis lequel il consulte ses données ensuite (§5.5).
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct LocalDate(pub i32);

impl LocalDate {
    /// Millisecondes par jour.
    const MILLIS_PER_DAY: i64 = 86_400_000;

    /// Déduit la date locale d'un instant UTC et de son offset (§5.5).
    pub fn from_utc_millis(utc_millis: i64, tz_offset_minutes: i16) -> Self {
        let local = utc_millis + i64::from(tz_offset_minutes) * 60_000;
        // Division euclidienne : les dates d'avant 1970 tombent du bon côté.
        Self(local.div_euclid(Self::MILLIS_PER_DAY) as i32)
    }
}

/// Nombre de décimales conservées dans l'empreinte d'un
/// [`UserSegmentOverride`].
///
/// 2 décimales ≈ 1,1 km. C'est délibérément **grossier** : un ré-import qui
/// redécoupe légèrement un trajet déplace ses extrémités de quelques centaines
/// de mètres, et une empreinte trop fine perdrait la correction (§4). Le prix
/// à payer est qu'un autre trajet du même quartier, le même jour, peut
/// produire la même empreinte — d'où la désambiguïsation temporelle décrite
/// dans [`UserSegmentOverride`].
pub const OVERRIDE_COORD_DECIMALS: u32 = 2;

/// Lieu nommé par l'utilisateur (§5.2).
///
/// Comble le trou laissé par le geocoding « ville + POI majeurs » (§3.2) :
/// « Maison », « Bureau », la salle de sport. Rattaché **géographiquement**,
/// donc indéfiniment persistant.
#[derive(Debug, Clone, PartialEq)]
pub struct UserPlace {
    /// Identifiant en base.
    pub id: i64,
    /// Nom donné par l'utilisateur.
    pub label: String,
    /// Latitude du centre.
    pub lat: f64,
    /// Longitude du centre.
    pub lon: f64,
    /// Rayon de rattachement, en mètres.
    pub radius_m: f64,
}

/// Forme d'une zone privée (§3.7).
#[derive(Debug, Clone, PartialEq)]
pub enum ZoneShape {
    /// Disque autour d'un centre.
    Circle {
        /// Latitude du centre.
        lat: f64,
        /// Longitude du centre.
        lon: f64,
        /// Rayon, en mètres.
        radius_m: f64,
    },
    /// Polygone fermé, sommets en (latitude, longitude).
    Polygon {
        /// Sommets dans l'ordre du tracé ; la fermeture est implicite.
        vertices: Vec<(f64, f64)>,
    },
}

/// Zone géographique exclue de tout (§3.7).
///
/// Appliquée **à la source** par le pipeline (§5.4, étape 1) : un point situé
/// dans une zone privée est absent des stats, des frames vidéo et de l'export
/// — pas seulement invisible à l'écran.
#[derive(Debug, Clone, PartialEq)]
pub struct PrivateZone {
    /// Identifiant en base.
    pub id: i64,
    /// Nom donné par l'utilisateur.
    pub label: String,
    /// Géométrie de la zone.
    pub shape: ZoneShape,
}

/// Correction manuelle d'un mode de transport (§5.2).
///
/// `detected_mode` n'est **jamais** écrasé (§5.1) : la correction vit ici et
/// est appliquée par le pipeline (§5.4, étape 3).
///
/// # Appariement
///
/// La clé est (date locale, extrémités arrondies à
/// [`OVERRIDE_COORD_DECIMALS`]), **sans les bornes temporelles exactes** : un
/// ré-import qui redécoupe le trajet retrouve quand même la correction (§4).
///
/// Si plusieurs segments du même jour produisent la même empreinte, la
/// correction s'applique au segment **temporellement le plus proche** de
/// [`Self::source_start_ts_utc`] (§4).
#[derive(Debug, Clone, PartialEq)]
pub struct UserSegmentOverride {
    /// Identifiant en base.
    pub id: i64,
    /// Date locale du trajet corrigé.
    pub local_date: LocalDate,
    /// Latitude de départ arrondie.
    pub start_lat_r: f64,
    /// Longitude de départ arrondie.
    pub start_lon_r: f64,
    /// Latitude d'arrivée arrondie.
    pub end_lat_r: f64,
    /// Longitude d'arrivée arrondie.
    pub end_lon_r: f64,
    /// Mode corrigé par l'utilisateur.
    pub corrected_mode: super::TravelMode,
    /// Début du segment tel qu'il était **au moment de la correction**.
    ///
    /// ⚠️ Ne fait **pas** partie de la clé d'appariement — sinon un
    /// redécoupage la casserait, ce que §4 interdit explicitement. Sert
    /// uniquement à départager plusieurs segments de même empreinte le même
    /// jour, cas que §4 tranche par « le plus proche temporellement » sans
    /// dire proche de quoi : c'est ce champ qui donne la référence.
    pub source_start_ts_utc: i64,
}

impl UserSegmentOverride {
    /// Arrondit une coordonnée à la précision d'appariement.
    pub fn round_coord(value: f64) -> f64 {
        let factor = 10f64.powi(OVERRIDE_COORD_DECIMALS as i32);
        (value * factor).round() / factor
    }
}

/// Réglage applicatif, clé/valeur (§5.2).
///
/// Porte notamment les interrupteurs des intégrations optionnelles (Immich,
/// météo — §2), le consentement aux tuiles de carte, la langue (§3.9) et les
/// préférences de rendu vidéo (§3.5). **Jamais effacé par un ré-import** :
/// un consentement réseau révoqué ne doit pas se réactiver tout seul.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AppSetting {
    /// Clé du réglage.
    pub key: String,
    /// Valeur sérialisée.
    pub value: String,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn date_locale_depend_de_loffset() {
        // 2024-01-02T22:00Z : déjà le 3 à Tokyo (+09:00), encore le 2 à Paris
        // (+01:00). À 23:30Z les deux seraient le 3 — l'écart d'une heure ne
        // suffit pas, c'est tout l'intérêt de stocker l'offset (§5.5).
        let utc = 1_704_232_800_000;
        let tokyo = LocalDate::from_utc_millis(utc, 540);
        let paris = LocalDate::from_utc_millis(utc, 60);
        assert_eq!(tokyo.0, paris.0 + 1);
    }

    #[test]
    fn date_locale_avant_1970() {
        // Un instant négatif ne doit pas arrondir vers zéro.
        let date = LocalDate::from_utc_millis(-1, 0);
        assert_eq!(date.0, -1);
    }

    #[test]
    fn arrondi_a_deux_decimales() {
        assert_eq!(UserSegmentOverride::round_coord(48.858_4), 48.86);
        assert_eq!(UserSegmentOverride::round_coord(-70.669_3), -70.67);
    }
}
