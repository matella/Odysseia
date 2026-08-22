//! Normalisation des coordonnées vers un décimal unique (§5.1).
//!
//! Variantes rencontrées dans les exports : E7, `geo:`, degrés, `latLng`.
//! Toutes convergent vers [`LatLon`], validé une seule fois ici — aucune
//! couche en aval ne doit avoir à redouter une latitude à 91°.
//!
//! Les bornes ±90 / ±180 sont **acceptées** : ce sont des positions valides,
//! et l'antiméridien est un cas limite explicitement testé (§3.10).

use serde_json::Value;

use crate::error::CoordError;

/// Coordonnée décimale validée.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct LatLon {
    /// Latitude, dans [-90, 90].
    pub lat: f64,
    /// Longitude, dans [-180, 180].
    pub lon: f64,
}

/// Profondeur maximale de descente dans les objets imbriqués.
///
/// Garde-fou : une source hostile ou absurde ne doit pas provoquer de
/// récursion sans fin (§3.10).
const MAX_DEPTH: u8 = 6;

/// Valide et construit une coordonnée décimale.
pub fn from_degrees(lat: f64, lon: f64) -> Result<LatLon, CoordError> {
    if !lat.is_finite() || !(-90.0..=90.0).contains(&lat) {
        return Err(CoordError::LatitudeOutOfRange(lat));
    }
    if !lon.is_finite() || !(-180.0..=180.0).contains(&lon) {
        return Err(CoordError::LongitudeOutOfRange(lon));
    }
    Ok(LatLon { lat, lon })
}

/// Convertit une paire E7 (degrés × 10⁷) en décimal.
pub fn from_e7(lat_e7: i64, lon_e7: i64) -> Result<LatLon, CoordError> {
    from_degrees(lat_e7 as f64 / 1e7, lon_e7 as f64 / 1e7)
}

/// Analyse une paire textuelle.
///
/// Formes acceptées : `geo:48.8584,2.2945`, `48.8584°, 2.2945°`,
/// `48.8584, 2.2945`.
pub fn parse_pair(raw: &str) -> Result<LatLon, CoordError> {
    let trimmed = raw.trim();
    let body = match trimmed.get(..4) {
        Some(prefix) if prefix.eq_ignore_ascii_case("geo:") => &trimmed[4..],
        _ => trimmed,
    };

    let (lat_part, lon_part) = body
        .split_once(',')
        .ok_or_else(|| CoordError::Malformed(raw.to_string()))?;

    let lat = parse_scalar(lat_part).ok_or_else(|| CoordError::Malformed(raw.to_string()))?;
    let lon = parse_scalar(lon_part).ok_or_else(|| CoordError::Malformed(raw.to_string()))?;
    from_degrees(lat, lon)
}

/// Analyse un scalaire de degrés, avec ou sans symbole degré.
fn parse_scalar(raw: &str) -> Option<f64> {
    raw.trim()
        .trim_end_matches('\u{b0}')
        .trim()
        .parse::<f64>()
        .ok()
}

/// Extrait une coordonnée d'un fragment JSON, quelle qu'en soit la variante.
///
/// Descend dans les enveloppes usuelles (`placeLocation`, `latLng`, `point`,
/// `location`) et reconnaît indifféremment les paires E7, les champs
/// `latitude`/`longitude`, `lat`/`lng` et les formes textuelles.
pub fn from_json(value: &Value) -> Result<LatLon, CoordError> {
    from_json_at(value, 0)
}

fn from_json_at(value: &Value, depth: u8) -> Result<LatLon, CoordError> {
    if depth > MAX_DEPTH {
        return Err(CoordError::Missing);
    }

    match value {
        Value::String(raw) => parse_pair(raw),
        Value::Object(map) => {
            if let (Some(lat), Some(lon)) = (
                map.get("latitudeE7").and_then(as_i64),
                map.get("longitudeE7").and_then(as_i64),
            ) {
                return from_e7(lat, lon);
            }

            for (lat_key, lon_key) in [("latitude", "longitude"), ("lat", "lng"), ("lat", "lon")] {
                if let (Some(lat), Some(lon)) = (
                    map.get(lat_key).and_then(as_f64),
                    map.get(lon_key).and_then(as_f64),
                ) {
                    return from_degrees(lat, lon);
                }
            }

            for wrapper in ["placeLocation", "latLng", "point", "location"] {
                if let Some(inner) = map.get(wrapper) {
                    return from_json_at(inner, depth + 1);
                }
            }

            Err(CoordError::Missing)
        }
        _ => Err(CoordError::Missing),
    }
}

/// Lit un entier, que la source l'écrive en nombre ou en chaîne.
fn as_i64(value: &Value) -> Option<i64> {
    match value {
        Value::Number(n) => n.as_i64(),
        Value::String(s) => s.trim().parse().ok(),
        _ => None,
    }
}

/// Lit un flottant, que la source l'écrive en nombre ou en chaîne.
pub(crate) fn as_f64(value: &Value) -> Option<f64> {
    match value {
        Value::Number(n) => n.as_f64(),
        Value::String(s) => parse_scalar(s),
        _ => None,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn geo_uri() {
        let c = parse_pair("geo:48.8584,2.2945").unwrap();
        assert!((c.lat - 48.8584).abs() < 1e-12);
        assert!((c.lon - 2.2945).abs() < 1e-12);
    }

    #[test]
    fn degres_avec_symbole_et_espaces() {
        let c = parse_pair("  -33.4489\u{b0}, -70.6693\u{b0}  ").unwrap();
        assert!((c.lat + 33.4489).abs() < 1e-12);
        assert!((c.lon + 70.6693).abs() < 1e-12);
    }

    #[test]
    fn paire_nue() {
        assert!(parse_pair("40.7484, -73.9857").is_ok());
    }

    #[test]
    fn prefixe_geo_insensible_a_la_casse() {
        assert!(parse_pair("GEO:1.0,2.0").is_ok());
    }

    #[test]
    fn e7_negatif() {
        let c = from_e7(-334489000, -706693000).unwrap();
        assert!((c.lat + 33.4489).abs() < 1e-9);
    }

    #[test]
    fn bornes_acceptees() {
        assert!(from_degrees(90.0, 180.0).is_ok());
        assert!(from_degrees(-90.0, -180.0).is_ok());
    }

    #[test]
    fn hors_bornes_rejete() {
        assert_eq!(
            from_degrees(91.5, 0.0),
            Err(CoordError::LatitudeOutOfRange(91.5))
        );
        assert_eq!(
            from_degrees(0.0, 180.5),
            Err(CoordError::LongitudeOutOfRange(180.5))
        );
    }

    #[test]
    fn nan_rejete() {
        assert!(from_degrees(f64::NAN, 0.0).is_err());
    }

    #[test]
    fn chaine_illisible_rejetee() {
        assert!(matches!(
            parse_pair("quelque part"),
            Err(CoordError::Malformed(_))
        ));
    }

    #[test]
    fn recursion_bornee() {
        // Objet auto-imbriqué : doit s'arrêter, pas déborder la pile.
        let mut value = serde_json::json!({ "latLng": "48.0, 2.0" });
        for _ in 0..20 {
            value = serde_json::json!({ "latLng": value });
        }
        assert_eq!(from_json(&value), Err(CoordError::Missing));
    }
}
