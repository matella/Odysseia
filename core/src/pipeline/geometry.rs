//! Primitives géométriques partagées par le pipeline.
//!
//! Volontairement minimales et sans dépendance : rayon de la Terre sphérique,
//! appartenance à un disque, appartenance à un polygone. La précision d'une
//! sphère (≈ 0,3 % d'écart avec l'ellipsoïde) est très en deçà des rayons
//! manipulés ici — des zones privées et des lieux de quelques dizaines à
//! quelques centaines de mètres.

/// Rayon moyen de la Terre, en mètres.
const EARTH_RADIUS_M: f64 = 6_371_008.8;

/// Distance orthodromique entre deux points, en mètres.
///
/// Traverse l'antiméridien sans traitement particulier : la formule travaille
/// sur des différences d'angles, `179.9°` et `-179.9°` sont bien à 22 km l'un
/// de l'autre et non à 40 000 km (§3.10).
pub fn haversine_m(lat_a: f64, lon_a: f64, lat_b: f64, lon_b: f64) -> f64 {
    let (phi_a, phi_b) = (lat_a.to_radians(), lat_b.to_radians());
    let delta_phi = (lat_b - lat_a).to_radians();
    let delta_lambda = (lon_b - lon_a).to_radians();

    let a = (delta_phi / 2.0).sin().powi(2)
        + phi_a.cos() * phi_b.cos() * (delta_lambda / 2.0).sin().powi(2);
    2.0 * a.sqrt().asin().min(std::f64::consts::FRAC_PI_2) * EARTH_RADIUS_M
}

/// Le point est-il dans le disque ?
pub fn in_circle(lat: f64, lon: f64, center_lat: f64, center_lon: f64, radius_m: f64) -> bool {
    haversine_m(lat, lon, center_lat, center_lon) <= radius_m
}

/// Le point est-il dans le polygone ?
///
/// Lancer de rayon classique, avec une correction d'antiméridien : si le
/// polygone s'étend sur plus de 180° de longitude, c'est qu'il le traverse —
/// on ramène alors toutes les longitudes négatives dans une plage continue
/// [0, 360[ avant le test (§3.10).
pub fn in_polygon(lat: f64, lon: f64, vertices: &[(f64, f64)]) -> bool {
    if vertices.len() < 3 {
        return false;
    }

    let unwrap_needed = {
        let (min, max) = vertices
            .iter()
            .fold((f64::MAX, f64::MIN), |(lo, hi), (_, x)| {
                (lo.min(*x), hi.max(*x))
            });
        max - min > 180.0
    };
    let normalise = |value: f64| {
        if unwrap_needed && value < 0.0 {
            value + 360.0
        } else {
            value
        }
    };

    let x = normalise(lon);
    let mut inside = false;
    let mut j = vertices.len() - 1;

    for i in 0..vertices.len() {
        let (yi, xi) = (vertices[i].0, normalise(vertices[i].1));
        let (yj, xj) = (vertices[j].0, normalise(vertices[j].1));

        if (yi > lat) != (yj > lat) && x < (xj - xi) * (lat - yi) / (yj - yi) + xi {
            inside = !inside;
        }
        j = i;
    }
    inside
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn distance_connue() {
        // Paris — Lyon, environ 392 km.
        let d = haversine_m(48.8566, 2.3522, 45.7640, 4.8357);
        assert!((d - 392_000.0).abs() < 5_000.0, "distance {d}");
    }

    #[test]
    fn distance_nulle() {
        assert!(haversine_m(48.0, 2.0, 48.0, 2.0) < 1e-6);
    }

    #[test]
    fn antimeridien_traverse_sans_detour() {
        // 179.95 et -179.95 sont séparés de 0,1° de longitude, pas de 359,9°.
        let d = haversine_m(0.0, 179.95, 0.0, -179.95);
        assert!(d < 12_000.0, "distance {d}");
    }

    #[test]
    fn disque_inclut_le_centre_et_exclut_le_lointain() {
        assert!(in_circle(48.8566, 2.3522, 48.8566, 2.3522, 100.0));
        assert!(!in_circle(45.7640, 4.8357, 48.8566, 2.3522, 100.0));
    }

    #[test]
    fn polygone_simple() {
        let carre = [(0.0, 0.0), (0.0, 1.0), (1.0, 1.0), (1.0, 0.0)];
        assert!(in_polygon(0.5, 0.5, &carre));
        assert!(!in_polygon(1.5, 0.5, &carre));
    }

    #[test]
    fn polygone_a_cheval_sur_lantimeridien() {
        let zone = [
            (-16.0, 179.0),
            (-16.0, -179.0),
            (-17.0, -179.0),
            (-17.0, 179.0),
        ];
        assert!(in_polygon(-16.5, 179.9, &zone));
        assert!(in_polygon(-16.5, -179.9, &zone));
        assert!(!in_polygon(-16.5, 170.0, &zone));
    }

    #[test]
    fn polygone_degenere_rejete() {
        assert!(!in_polygon(0.0, 0.0, &[(0.0, 0.0), (1.0, 1.0)]));
    }
}
