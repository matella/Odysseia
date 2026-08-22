# Fixtures de test (§3.10)

Jeux d'exports Timeline **synthétiques ou anonymisés** — jamais de données
personnelles réelles dans le repo.

## Formats (§5.1)

| Fixture | Couvre |
| --- | --- |
| `google_direct_array.json` | format actuel : tableau de premier niveau, une visite + un trajet + une trajectoire |
| `google_semantic_segments.json` | format legacy : objet `semanticSegments`, offset négatif, clés sœurs inconnues à ignorer |

## Variantes de coordonnées (§5.1)

Les quatre encodent **exactement les mêmes deux visites** — Paris
(48.8584, 2.2945) et Santiago (-33.4489, -70.6693), mêmes horodatages. La
normalisation doit produire une sortie identique pour les quatre, ce que
vérifie `tests/parse_coords.rs`.

| Fixture | Variante |
| --- | --- |
| `coords_degrees.json` | `"48.8584°, 2.2945°"` |
| `coords_geo_uri.json` | `"geo:48.8584,2.2945"` |
| `coords_e7.json` | `latitudeE7` / `longitudeE7` |
| `coords_lat_lng_object.json` | `{"latitude": …, "longitude": …}` et `{"lat": …, "lng": …}` |

## Cas limites

| Fixture | Erreur attendue |
| --- | --- |
| `empty_direct_array.json` | `EmptyExport` |
| `empty_semantic_segments.json` | `EmptyExport` |
| `empty_file.json` (0 octet) | `EmptyExport` |
| `whitespace_only.json` | `EmptyExport` |
| `corrupt_truncated.json` | `CorruptJson` |
| `corrupt_invalid_token.json` | `CorruptJson` |
| `future_format.json` | `UnrecognisedFormat` |
| `future_format_scalar.json` | `UnrecognisedFormat` |

| Fixture | Comportement attendu |
| --- | --- |
| `dateline.json` | longitudes de part et d'autre de l'antiméridien préservées, bornes ±90 / ±180 acceptées, offsets +12:00 puis -11:00 sur un même trajet (§5.5) |
| `mixed_invalid_records.json` | 2 visites valides conservées, 3 enregistrements rejetés et comptés — un enregistrement aberrant ne fait pas échouer l'import (§3.10) |

`FileTooLarge` n'a pas de fixture : la limite est une option d'appel
(`ParseOptions::max_bytes`), le test l'applique à un fichier existant.

## Reste à couvrir

- très gros fichier : couvert par génération à la volée dans
  `tests/parse_streaming.rs` plutôt que par un fichier commité, pour ne pas
  alourdir le repo ;
- formats d'autres sources (GPX, Strava, fitness) quand leurs importeurs
  arriveront (§3.1).
