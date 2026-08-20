# `assets/geo_place/` — référentiel de lieux embarqué (§5.3)

Extrait **GeoNames filtré** (villes ≥ 1000 habitants + POI notables), embarqué
avec l'app pour un reverse geocoding **offline** — aucune étape réseau au
premier lancement, cohérent avec la promesse zéro-réseau (§4).

Ordre de grandeur : quelques dizaines de Mo compressés. Repli prévu si la
taille pose problème côté web : base réduite embarquée + téléchargement
optionnel d'un niveau de détail supérieur (§4).

## Décision en attente (§6.2)

Versionner le dataset dans Git (simple mais lourd) **ou** le générer via un
script de build (repo léger, étape supplémentaire). Tant que ce n'est pas
tranché, le dataset n'est pas commité — `.gitignore` exclut les fichiers de
données de ce dossier.
