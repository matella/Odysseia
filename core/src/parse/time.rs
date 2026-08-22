//! Normalisation des horodatages (§5.5).
//!
//! Stocke systématiquement **UTC + offset séparés**, jamais l'heure locale
//! seule : les patterns horaires (§3.4) et les trajets qui traversent un
//! fuseau en dépendent.
//!
//! Pendant du module [`super::coords`] pour l'axe temporel.

use chrono::DateTime;
use serde_json::Value;

use crate::error::TimeError;

/// Instant normalisé.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Timestamp {
    /// Millisecondes UTC depuis l'epoch.
    pub utc_millis: i64,
    /// Décalage du fuseau local, en minutes.
    pub tz_offset_minutes: i16,
}

/// Analyse un horodatage RFC 3339 (`2024-03-15T08:12:00.000+01:00`).
pub fn parse_rfc3339(raw: &str) -> Result<Timestamp, TimeError> {
    let parsed = DateTime::parse_from_rfc3339(raw.trim())
        .map_err(|_| TimeError::Malformed(raw.to_string()))?;

    Ok(Timestamp {
        utc_millis: parsed.timestamp_millis(),
        // `local_minus_utc` est en secondes ; les offsets réels tiennent tous
        // largement dans un i16 (±14 h = ±840 min).
        tz_offset_minutes: (parsed.offset().local_minus_utc() / 60) as i16,
    })
}

/// Construit un instant depuis un epoch en millisecondes.
///
/// L'offset est inconnu dans cette forme : il vaut 0 (UTC). L'heure locale
/// devra être reconstituée autrement si la source ne la donne pas (§5.5).
pub fn from_epoch_millis(millis: i64) -> Timestamp {
    Timestamp {
        utc_millis: millis,
        tz_offset_minutes: 0,
    }
}

/// Extrait un horodatage d'un fragment JSON.
///
/// Accepte le RFC 3339 (avec ou sans offset) et l'epoch en millisecondes,
/// écrit en nombre comme en chaîne — les exports Google mélangent les deux
/// selon les époques.
pub fn from_json(value: &Value) -> Result<Timestamp, TimeError> {
    match value {
        Value::String(raw) => parse_rfc3339(raw).or_else(|err| match raw.trim().parse::<i64>() {
            Ok(millis) => Ok(from_epoch_millis(millis)),
            Err(_) => Err(err),
        }),
        Value::Number(n) => n
            .as_i64()
            .map(from_epoch_millis)
            .ok_or_else(|| TimeError::Malformed(n.to_string())),
        Value::Null => Err(TimeError::Missing),
        other => Err(TimeError::Malformed(other.to_string())),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn offset_positif_conserve() {
        let t = parse_rfc3339("2024-03-15T08:12:00.000+01:00").unwrap();
        assert_eq!(t.tz_offset_minutes, 60);
    }

    #[test]
    fn offset_negatif_conserve() {
        let t = parse_rfc3339("2013-11-01T07:30:00.000-05:00").unwrap();
        assert_eq!(t.tz_offset_minutes, -300);
    }

    #[test]
    fn offset_non_entier_en_heures() {
        // Katmandou : +05:45.
        let t = parse_rfc3339("2024-03-15T08:12:00+05:45").unwrap();
        assert_eq!(t.tz_offset_minutes, 345);
    }

    #[test]
    fn zoulou_vaut_offset_zero() {
        let t = parse_rfc3339("2024-01-02T10:00:00.000Z").unwrap();
        assert_eq!(t.tz_offset_minutes, 0);
    }

    #[test]
    fn meme_instant_offsets_differents() {
        let a = parse_rfc3339("2024-03-15T08:12:00.000+01:00").unwrap();
        let b = parse_rfc3339("2024-03-15T07:12:00.000Z").unwrap();
        assert_eq!(a.utc_millis, b.utc_millis);
        assert_ne!(a.tz_offset_minutes, b.tz_offset_minutes);
    }

    #[test]
    fn epoch_en_chaine() {
        let t = from_json(&Value::String("1383315825000".into())).unwrap();
        assert_eq!(t.utc_millis, 1_383_315_825_000);
    }

    #[test]
    fn epoch_en_nombre() {
        let t = from_json(&serde_json::json!(1_383_315_825_000i64)).unwrap();
        assert_eq!(t.utc_millis, 1_383_315_825_000);
    }

    #[test]
    fn chaine_illisible_rejetee() {
        assert!(matches!(
            from_json(&Value::String("hier matin".into())),
            Err(TimeError::Malformed(_))
        ));
    }

    #[test]
    fn null_est_absent() {
        assert_eq!(from_json(&Value::Null), Err(TimeError::Missing));
    }
}
