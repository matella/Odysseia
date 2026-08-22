# Modèle de données — détail

Le schéma de référence est la **§5 de [`specs.md`](specs.md)** ; ce document
consigne les décisions d'implémentation qu'elle laissait ouvertes.

## Les trois zones

| Zone | Tables | Ré-import | Où |
| --- | --- | --- | --- |
| Importée (§5.1) | `import_batch`, `raw_point`, `segment`, `visit` | vidée et reconstruite | `core/src/model/imported.rs` |
| Utilisateur (§5.2) | `user_place`, `private_zone`, `user_segment_override`, `app_setting` | **jamais touchée** | `core/src/model/user.rs` |
| Référentiel (§5.3) | `geo_place` | embarquée, lecture seule | `core/src/model/geo.rs` |

La frontière est vérifiée par des tests, pas seulement documentée :

- `app/test/data/schema_test.dart` — les trois zones sont disjointes et
  couvrent tout le schéma ; **aucune table de §5.2 ne porte de clé étrangère**
  (lu dans SQLite via `pragma foreign_key_list`, pas dans le code Dart) ;
- `app/test/data/reimport_test.dart` — dix ré-imports successifs ne
  grignotent aucune ligne de §5.2 ;
- `core/tests/pipeline_reimport.rs` — après redécoupage du même trajet par
  Google, la correction de mode retrouve son segment.

Une table nouvelle non classée dans une zone fait échouer `schema_test.dart` :
sans cela, elle échapperait silencieusement aux règles de ré-import.

## Rattachement de la zone utilisateur

Rien dans §5.2 ne référence un identifiant de §5.1 — ils changent à chaque
import (§3.1). Deux mécanismes de rattachement :

**Géographique** — `user_place` et `private_zone` s'appliquent par distance
(haversine) ou appartenance à un polygone. Une visite appartient à « Maison »
si elle tombe dans son rayon, quel que soit son identifiant.

**Empreinte tolérante** — `user_segment_override` retrouve son trajet par
`(date locale, extrémités arrondies)`, sans les bornes temporelles exactes du
segment (§4).

| Paramètre | Valeur | Pourquoi |
| --- | --- | --- |
| Arrondi des coordonnées | **2 décimales** (~1,1 km) | un redécoupage déplace les extrémités de quelques centaines de mètres ; une empreinte plus fine perdrait la correction |
| Date | **locale**, en jours depuis l'epoch | une correction faite « le mardi » reste attachée au mardi de l'utilisateur (§5.5) |
| Départage | segment le plus proche de `source_start_ts_utc` | §4 impose « le plus proche temporellement » sans dire de quoi ; ce champ donne la référence, **hors clé d'appariement** |

Conséquence assumée : deux trajets du même quartier, le même jour, peuvent
partager une empreinte. Le départage temporel tranche, et le pire cas est une
correction appliquée au mauvais trajet du même jour — préférable à une
correction perdue à chaque import.

Les corrections **orphelines** sont conservées, inactives (§4). Elles se
réactivent d'elles-mêmes si un import futur ramène le trajet — comportement
vérifié par `une_correction_orpheline_se_reactive_au_retour_du_trajet`.

## Index

`raw_point` peut atteindre ~5 millions de lignes sur dix ans (§5.5).

| Index | Table | Sert à |
| --- | --- | --- |
| `raw_point_time` | `raw_point` | navigation jour/semaine/mois/année (§3.3) |
| `raw_point_space` | `raw_point` | heatmap et filtres spatiaux (§3.4) |
| `segment_time`, `visit_time` | `segment`, `visit` | navigation temporelle |
| `visit_space`, `user_place_space` | `visit`, `user_place` | rattachement géographique |
| `override_fingerprint` | `user_segment_override` | appariement par date locale |

Pas de table d'agrégats pré-calculés pour l'instant : §3.4 demande des
requêtes **composables**, et figer des totaux les rendrait incompatibles avec
les filtres. §5.5 autorise à en ajouter si les stats deviennent lentes — ce
sera une décision mesurée, pas anticipée.

## Pipeline (§5.4)

Implémenté dans `core/src/pipeline/`, **en Rust** : c'est de la logique
métier, elle ne peut pas vivre dans `app/` (§6.1).

1. `zones.rs` — filtrage des zones privées, **avant tout le reste**
2. `places.rs` — `user_place` → `geo_place` → coordonnées
3. `overrides.rs` — application des corrections sur `detected_mode`
4. `mod.rs` — filtres de la vue courante (période / lieu / mode)

Décisions prises en implémentant :

- **Un segment dont une seule extrémité tombe dans une zone privée est écarté
  en entier.** Le conserver publierait la coordonnée que l'utilisateur cache.
  Perdre le trajet est le prix de la garantie « appliquée à la source » (§3.7).
- **Le filtre par mode ne s'applique qu'aux segments.** Un arrêt n'a pas de
  mode ; filtrer les visites par mode viderait la vue Récit au lieu de la
  restreindre.
- **Les segments se traitent par lot, les points et visites un par un.**
  L'appariement des corrections doit voir les candidats d'une même journée
  ensemble (§4) ; le lot naturel est la période affichée, toujours bornée.
- **Un `geo_place` à plus de 25 km n'est pas retenu.** Le référentiel est
  filtré « villes ≥ 1000 habitants » : en zone peu dense, mieux vaut afficher
  les coordonnées qu'affirmer une ville où l'utilisateur n'est jamais allé.

## Accès depuis Dart

Le pipeline est appelable depuis Dart via `bridge/` : `TimelineRepository`
est le seul chemin, et l'API du pont n'offre aucune fonction renvoyant de la
donnée non filtrée. Vérifié par `app/test/bridge/pipeline_bridge_test.dart`,
qui fait passer une zone privée à travers le pont et constate l'absence.

## Reste à faire

- **L'encodage MP4 n'est pas branché** (§3.5) : `core/src/render/` produit un
  plan de frames déterministe, mais ni ffmpeg natif ni `ffmpeg.wasm` ne sont
  intégrés.
- **Le build web du pont** reste à faire (`build-web`, §6.2).
- `geo_place` est déclarée mais vide : le peuplement depuis
  `assets/geo_place/` dépend de la décision §6.2 (dataset versionné ou généré).
- Migrations : `schemaVersion = 1`, aucune migration à écrire tant que rien
  n'est distribué.
