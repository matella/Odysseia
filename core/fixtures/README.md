# Fixtures de test (§3.10)

Jeux d'exports Timeline **synthétiques ou anonymisés** — jamais de données
personnelles réelles dans le repo.

Couverture attendue :

- formats : legacy `semanticSegments`, direct-array, format futur non reconnu ;
- variantes de coordonnées : E7, `geo:`, degrés, `latLng` (§5.1) ;
- cas limites : fichier vide, JSON corrompu, très gros fichier, dateline,
  trajets traversant un fuseau horaire (§5.5).
