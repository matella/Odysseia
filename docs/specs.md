# Specs — Odysseia (Ὀδύσσεια)

Visualiseur de Google Timeline — application multi-plateforme, zéro transfert réseau.

Statut : specs complètes — toutes les décisions sont prises, prêt pour le code.

## 1. Vision

Application permettant d'explorer ses données Google Timeline (export JSON), sous
trois angles combinés : récit/exploration jour par jour, stats & patterns, et
génération de vidéo souvenir animée.

## 2. Décisions déjà actées

- **Zéro transfert réseau** : tout le traitement (parsing, clustering, stats,
  génération des frames vidéo) se fait localement sur l'appareil de
  l'utilisateur. Aucune donnée Timeline n'est envoyée à un serveur.
- **Stack** : Flutter (mobile + web, un seul codebase UI) + moteur de calcul
  en Rust (`timeline_core`), compilé nativement (mobile/desktop via
  `flutter_rust_bridge`) et en WASM pour le web.
- **Distribution** : via GitHub, sans publication en store et sans
  certificats — web en statique (GitHub Pages), Android en APK, desktop en
  binaires non signés, iOS compilé localement via Xcode (compte Apple
  gratuit, profil à renouveler tous les 7 jours). Pas de backend à héberger.
  Détail en §4.
- **Écran de capacités/settings** : les fonctionnalités indisponibles ou
  dégradées sur une plateforme, ainsi que les intégrations optionnelles
  ci-dessous, sont regroupées et gérées dans un écran de settings plutôt que
  supprimées silencieusement.
- **Dépendances réseau** : le traitement des données Timeline reste toujours
  100 % local. Deux catégories d'exceptions réseau existent néanmoins :
  1. **Tuiles de carte (OpenStreetMap)** — nécessaires à l'affichage, avec
     consentement explicite avant le premier chargement. Aucune donnée
     Timeline n'y transite, seules les zones de carte affichées.
  2. **Intégrations optionnelles**, toutes désactivées par défaut, chacune
     avec son propre interrupteur et son avertissement de confidentialité
     dans l'écran de settings : serveur Immich personnel (§3.1) et API météo
     historique (§3.3). ⚠️ Ces intégrations transmettent des données dérivées
     de la Timeline (coordonnées, dates) à un tiers — l'avertissement doit le
     dire explicitement, pas seulement "nécessite une connexion".

## 3. Questions ouvertes — à trancher avant le code

### 3.1 Sources de données & intégrations externes
- [x] Corrélation photos : **les deux**, activables indépendamment —
  photothèque locale du device (défaut, zéro réseau) **et** intégration
  Immich optionnelle (clairement identifiée comme rompant le zéro-réseau
  quand activée).
- [x] Autres sources (Strava/GPX, Apple Health/Google Fit) : **schéma
  générique prévu dès le départ, implémentation après la v1**. Implication :
  le modèle de données ne doit pas être calqué sur le format Google —
  prévoir une notion de "source" sur les points/segments, et garder le
  parsing Google comme *une* implémentation parmi d'autres derrière une
  interface commune.
- [x] Import multi-fichiers : **non** — un seul export à la fois, un nouvel
  import **remplace** tout. ⚠️ Conséquence importante à assumer :
  1. Les **corrections manuelles** (§3.3) et les **zones privées** (§3.7)
     ne doivent PAS être effacées par un ré-import, sinon l'utilisateur
     perd son travail à chaque mise à jour de son export. → Ces données
     vivent dans des tables séparées, rattachées à une position/un lieu
     plutôt qu'à un identifiant de point issu de l'import.
  2. Google ne garantit pas que les exports successifs couvrent tout
     l'historique — remplacer purement et simplement peut faire *perdre*
     des données plus anciennes présentes dans un export précédent. Le
     fichier source étant conservé (§3.2), prévoir au minimum un
     avertissement clair avant écrasement, voire un archivage des exports
     précédents.

### 3.2 Modèle de données & stockage local
- [x] Structures de base : définies en §5.
- [x] Stockage local : **SQLite (drift) partout**, y compris web via
  `sqlite3.wasm` + IndexedDB. ⚠️ Contrainte à garder en tête : quota de
  stockage navigateur (géré/purgeable par l'utilisateur côté web).
- [x] Le fichier Timeline.json source **est conservé** après import (permet
  de re-parser si le modèle de données évolue). Implication : prévoir un
  espace de stockage brut dédié en plus de la base normalisée.
- [x] Résolution des noms de lieux : **reverse geocoding embarqué/offline**,
  précision **intermédiaire — ville + POI majeurs**. Source candidate :
  GeoNames (dataset libre, villes + points d'intérêt, filtrable par
  population/importance pour maîtriser la taille). Implication : base
  embarquée de taille raisonnable (dizaines de Mo selon le filtrage retenu),
  mais les lieux du quotidien (commerces, adresses précises) ne seront PAS
  résolus automatiquement → c'est exactement ce que l'édition manuelle
  (§3.3) vient compenser : l'utilisateur nomme lui-même ses lieux
  récurrents, et ce nom doit persister (cf §3.1, survivre aux ré-imports).
- [x] Combien de temps/volume de données doit tenir l'app sans ramer : cf §4
  (10 ans / ~5 M points bruts comme cible de conception).

### 3.3 Vue "Récit"
- [x] Granularité de navigation : **multiple** — jour, semaine, mois, année.
- [x] Niveau de détail : **complet** — durée, distance, mode de transport,
  météo du jour, photos correspondantes. ⚠️ Implication : la météo
  historique n'existe pas dans le Timeline export et n'est pas réaliste à
  embarquer offline — ça nécessite un appel à une API météo externe, ce qui
  rompt le zéro-réseau pour cette fonctionnalité précise. Point d'attention
  fort : une requête météo historique = coordonnées + date envoyées à un
  tiers, soit exactement le type de donnée que l'app promet de garder
  locale. À isoler comme intégration optionnelle désactivée par défaut
  (même famille que Immich, cf §2), avec un avertissement explicite sur ce
  qui est transmis. Question ouverte : quelle granularité de localisation
  envoyer (coordonnées exactes, ou arrondies à la ville pour limiter la
  fuite d'information) ?
- [x] Édition manuelle (renommer un lieu, corriger un mode de transport
  détecté) : **incluse dès la v1**. Implication : le modèle de données
  (§3.2) doit distinguer valeur "détectée" vs. "corrigée manuellement" par
  l'utilisateur (pour ne pas écraser la correction lors d'un ré-import ou
  d'un recalcul du clustering).

### 3.4 Vue "Stats & patterns"
- [x] Stats v1 : **toutes** — heatmap de densité, classement des lieux les
  plus visités, temps passé par zone/lieu, patterns horaires/jour de
  semaine, distance totale parcourue, répartition par mode de transport.
  ⚠️ Implication : ça pousse à concevoir dès maintenant une couche de calcul
  de stats générique dans `timeline_core` (agrégations réutilisables) plutôt
  que six calculs ad hoc — sinon chaque filtre (§ci-dessous) doit être
  réimplémenté six fois.
- [x] Filtres : **par période, par lieu, par mode de transport** — combinables
  entre eux. Implication : les agrégations doivent être calculées sur un
  sous-ensemble filtré des données, pas uniquement sur la totalité — à
  prévoir dans l'architecture du moteur de stats (requêtes composables,
  plutôt que stats pré-calculées figées).

### 3.5 Vue "Vidéo souvenir"
- [x] Formats de sortie : **MP4 natif partout**, y compris web via
  `ffmpeg.wasm` (plus lent, accepté). Implication : pas de repli GIF/image à
  prévoir — mais l'UI web doit clairement indiquer un temps de rendu plus
  long (barre de progression, possibilité de continuer à utiliser l'app
  pendant le rendu si techniquement possible en web worker).
- [x] Personnalisation : **complète dès la v1** — durée, période, style
  visuel personnalisables, au niveau du repo de référence (qui propose déjà
  15/30/45/60/75/90s, plage de mois/années, template de titre). Implication :
  le moteur de génération de frames (§2, `timeline_core`) doit exposer ces
  paramètres en entrée dès sa conception initiale, pas les ajouter après
  coup.

### 3.6 Multi-comptes / multi-personnes
- [x] Un seul jeu de données à la fois en v1 (pas de multi-profils).

### 3.7 Confidentialité & rétention
- [x] Purge/export à la demande : **export complet + suppression totale des
  données locales**, disponible depuis l'app. Implication : prévoir un
  écran "Mes données" dédié (export → fichier, suppression → confirmation
  irréversible) plutôt qu'un simple bouton caché dans les settings.
- [x] Zones privées : **incluses dès la v1** (exclure une zone géographique
  des vidéos/vues). Implication sur le modèle de données (§3.2) : une table
  de zones privées (centre + rayon ou polygone) consultée par le clustering
  ET par le moteur de rendu vidéo — à appliquer à la source des données
  filtrées, pas seulement en affichage, pour être cohérent partout.
- [x] Politique de confidentialité : **oui**, à rédiger même en zéro-réseau
  (bonne pratique + souvent exigée par les stores). À couvrir : ce qui est
  stocké localement, les intégrations réseau optionnelles (Immich §3.1,
  météo §3.3), les tuiles de carte OSM, et le crash log local (§3.10).

### 3.8 Plateformes & contraintes techniques
- [x] Cibles v1 : **toutes en même temps** — Android, iOS, Web, desktop.
  ⚠️ Implication : `flutter_rust_bridge` doit être configuré/testé sur
  Android, iOS, Windows, macOS, Linux, + build WASM pour le web en parallèle.
  C'est faisable mais ça multiplie les pipelines CI dès le départ (cf §3.9) —
  à garder en tête pour l'ordre de mise en place de la CI.
- [x] **iOS : résolu** — pas de publication en store, compilation locale via
  Xcode avec un compte Apple gratuit (cf §4). Le projet ne visant pas la
  prod, la contrainte App Store disparaît.
- [x] Taille de fichier Timeline.json max supportée : cf §4 (500 Mo natif,
  avertissement au-delà de ~200 Mo en web).
- [x] Stratégie de traitement en tâche de fond : cf §4 (streaming Rust +
  Isolate/Web Worker + progression).

### 3.9 Projet & distribution
- [x] Nom du projet et de l'app : **Odysseia** (Ὀδύσσεια). Reste à vérifier
  avant de figer : disponibilité du nom de repo GitHub, de l'identifiant de
  package (ex: `app.odysseia.*` ou équivalent inversé de domaine), et du nom
  sur l'App Store si la cible iOS est retenue.
- [x] Licence : **MIT** (comme le repo de référence).
- [x] Structure du repo : **monorepo** (Flutter + Rust ensemble).
- [x] CI/CD : **légère** — vérifier que ça compile et que les tests passent
  suffit. Concrètement : `cargo test` + `cargo clippy` sur `timeline_core`,
  `flutter test` (unitaires + golden, §3.10), et un build de vérification
  Android + web. Pas de pipeline de release multi-plateformes, pas de
  signature, pas de publication automatique — les binaires desktop/iOS sont
  compilés localement à la demande (§4). Décision révisée : la version
  "complète dès le début" avait été retenue dans une optique de
  distribution large, abandonnée depuis (§4).
- [x] Internationalisation : **anglais + français dès la v1**.

### 3.10 Qualité & tests
- [x] Stratégie de tests `timeline_core` : **jeux de données de test
  (fixtures) + tests unitaires systématiques**, à l'image du repo de
  référence (`test-fixtures/`, `tests/`). Implication : prévoir dès le
  début un jeu d'exports Timeline anonymisés/synthétiques couvrant les
  formats legacy et actuel, les variantes de coordonnées, et les cas
  limites (fichier vide, très gros fichier, dateline).
- [x] Tests UI : **golden tests Flutter dès la v1**.
- [x] Gestion des cas limites : comportement standard retenu — **jamais de
  crash visible**, chaque type d'erreur géré individuellement avec un
  message utilisateur clair et traduit (JSON corrompu, export vide, format
  futur non reconnu, fichier trop volumineux...), + un **crash log local**
  généré pour le debug (jamais transmis automatiquement, cohérent avec le
  zéro-réseau — export manuel si besoin de le partager pour un bug report).
  Implication : prévoir un type d'erreur dédié par cas dans `timeline_core`
  (plutôt qu'une erreur générique), pour que l'UI Flutter puisse afficher un
  message spécifique et traduit pour chacun.

## 4. Questions restantes — recommandations retenues

Ces points étaient ouverts ; ils sont tranchés par recommandation, révisables
à tout moment.

**Distribution (§3.8) — plus de blocage.** Le projet ne vise pas une
publication en store. Conséquences :
- **iOS** : compilation locale via Xcode avec un compte Apple gratuit
  (« personal team »). Pas de certificat payant, pas de review. Limite
  connue et acceptée : le profil expire au bout de 7 jours, il faut
  recompiler. Utilisable pour soi, pas distribuable.
- **Desktop** : binaires non signés dans les Releases GitHub. macOS et
  Windows afficheront un avertissement de sécurité au premier lancement —
  normal et acceptable ici.
- **Android** : APK signé avec une clé de debug locale, installable
  directement.
- **Web** : GitHub Pages, sans contrainte particulière.
- **CI** : légère (compile + tests), cf §3.9. Les cibles desktop/iOS sont
  compilées en local à la demande, sans pipeline dédié.

**§3.2 / §3.8 — Volume cible.** Cible de conception : **10 ans d'historique,
~5 millions de points bruts**. Au-delà, dégradation acceptée (l'app prévient
plutôt que de ramer silencieusement). Timeline.json : viser 500 Mo
confortables en natif ; côté web, avertir au-delà de ~200 Mo (contrainte
mémoire navigateur, §3.2).

**§3.8 — Traitement en tâche de fond.** Parsing en **streaming côté Rust**
(ne jamais charger tout le JSON en mémoire d'un coup), exécuté dans un
Isolate en natif et un Web Worker en web, avec un callback de progression
remonté à l'UI (pourcentage + étape en cours). Insertion en base par lots
(transactions groupées) plutôt que ligne par ligne.

**§3.3 — Granularité envoyée à l'API météo.** Coordonnées **arrondies à
2 décimales** (~1,1 km) avant tout appel, + cache local par (cellule, jour)
pour ne jamais re-questionner l'API deux fois. La météo ne varie pas à
l'échelle de la rue : aucune perte de qualité, et la trace transmise reste
grossière. Source recommandée : Open-Meteo (API historique gratuite, sans
clé).

**§3.1 — Politique d'écrasement au ré-import.** **Archivage** des exports
précédents (le fichier source est déjà conservé, §3.2) + avertissement
explicite si le nouvel export couvre une période plus courte que l'actuel
(détectable via `import_batch`, §5.1). Coût faible, protège contre la perte
d'historique liée aux limites de rétention de Google.

**§5.2 — Rattachement des corrections de mode de transport.** Recommandation :
**empreinte tolérante** — clé de correspondance composée de
(date locale, coordonnées de départ arrondies, coordonnées d'arrivée
arrondies), sans dépendre des bornes temporelles exactes du segment. Un
ré-import qui redécoupe légèrement le trajet retrouve quand même la
correction. En cas de correspondances multiples le même jour, appliquer au
segment temporellement le plus proche. Les corrections orphelines sont
conservées (jamais supprimées automatiquement), simplement inactives.

**§5.3 — Base `geo_place`.** **Embarquée dans l'app**, à partir d'un extrait
GeoNames filtré (villes ≥ 1000 habitants + POI notables) — de l'ordre de
quelques dizaines de Mo compressés. Évite une étape réseau au premier
lancement, cohérent avec la promesse zéro-réseau. Si la taille pose problème
côté web, repli prévu : base réduite embarquée + téléchargement optionnel
d'un niveau de détail supérieur.

## 5. Schéma de données `timeline_core`

Principe directeur : séparer strictement **ce qui vient de l'import**
(remplaçable, jetable) de **ce que l'utilisateur a produit** (précieux, doit
survivre à tout ré-import — cf §3.1).

### 5.1 Données importées (zone remplaçable)

Toutes ces tables sont vidées et reconstruites à chaque import.

**`import_batch`** — un import = un enregistrement
- `id`, `imported_at`, `source_kind` (enum : `google_timeline`, plus tard
  `gpx`, `strava`, `fitness`...), `source_file_path` (fichier conservé, §3.2),
  `source_format_detected` (legacy `semanticSegments` / direct-array / autre),
  `period_start`, `period_end`, `point_count`
- Permet d'afficher "vos données couvrent telle période" et d'avertir avant
  écrasement si le nouvel export couvre moins que l'ancien (§4)

**`raw_point`** — position brute
- `id`, `batch_id`, `timestamp_utc`, `tz_offset_minutes`, `lat`, `lon`,
  `accuracy_m?`, `altitude_m?`, `speed_ms?`, `source_kind`
- Stockage lat/lon en `REAL` ; normalisation faite au parsing (E7, `geo:`,
  degrés, `latLng` → décimal unique, cf formats §3.10)
- Index sur `timestamp_utc` (navigation §3.3) et sur `(lat, lon)` ou géohash
  (heatmap et filtres spatiaux §3.4)

**`segment`** — déplacement détecté entre deux visites
- `id`, `batch_id`, `start_ts`, `end_ts`, `start_lat/lon`, `end_lat/lon`,
  `distance_m`, `detected_mode` (enum : `walking`, `cycling`, `in_vehicle`,
  `flight`, `unknown`...), `mode_confidence`
- `detected_mode` reste **toujours** la valeur d'origine — une correction
  utilisateur ne l'écrase pas, elle vit en §5.2

**`visit`** — arrêt détecté à un endroit
- `id`, `batch_id`, `arrival_ts`, `departure_ts`, `lat`, `lon`,
  `radius_m`, `place_id?` (résolu via §5.3), `detection_confidence`

### 5.2 Données utilisateur (zone protégée, jamais écrasée)

Ces tables **survivent aux ré-imports**. C'est la conséquence directe de la
décision "un nouvel import remplace tout" (§3.1) : rien ici ne référence un
`id` de la zone 5.1, sinon la liaison casserait à chaque import.

**`user_place`** — lieu nommé par l'utilisateur
- `id`, `label`, `lat`, `lon`, `radius_m`, `created_at`, `updated_at`
- **Rattachement géographique, pas par id** : une visite est associée à un
  `user_place` si elle tombe dans son rayon. C'est ce qui permet à
  "Maison" ou "Bureau" de persister indéfiniment.
- Comble le trou laissé par le geocoding "ville + POI majeurs" (§3.2)

**`user_segment_override`** — correction de mode de transport
- `id`, `local_date`, `start_lat_r`, `start_lon_r`, `end_lat_r`, `end_lon_r`
  (coordonnées arrondies), `corrected_mode`, `created_at`
- Stratégie d'appariement retenue (§4) : **empreinte tolérante** —
  (date locale + départ/arrivée arrondis), indépendante des bornes
  temporelles exactes du segment, pour survivre à un redécoupage lors d'un
  ré-import. Correspondances multiples le même jour → segment temporellement
  le plus proche. Les corrections orphelines sont conservées, inactives.

**`private_zone`** — zone exclue (§3.7)
- `id`, `label`, `shape_kind` (`circle` | `polygon`), `lat`/`lon`/`radius_m`
  ou `polygon_geojson`, `created_at`
- Appliquée **à la source** dans le pipeline (§5.4), pas seulement en
  affichage

**`app_setting`** — clé/valeur
- Intégrations optionnelles activées (Immich, météo — §2), langue (§3.9),
  consentement tuiles de carte (§2), préférences de rendu vidéo (§3.5)

### 5.3 Référentiel de lieux (embarqué, en lecture seule)

**`geo_place`** — base offline GeoNames filtrée (§3.2)
- `id`, `name`, `name_ascii`, `country_code`, `admin1`, `feature_class`,
  `population?`, `lat`, `lon`
- Index spatial pour la recherche du plus proche voisin
- **Embarquée avec l'app** (§4), extrait GeoNames filtré (villes ≥ 1000 hab.
  + POI notables)

### 5.4 Vues dérivées et pipeline

Le pipeline de lecture applique, dans cet ordre, avant toute exploitation :

1. Filtrage des `private_zone` (§3.7) — **en amont de tout**, pour que les
   stats, les vidéos et les exports soient cohérents
2. Résolution du nom de lieu : `user_place` (prioritaire) → `geo_place` →
   coordonnées brutes en dernier recours
3. Application des `user_segment_override` sur `detected_mode`
4. Filtres de la vue courante (période / lieu / mode — §3.4)

Les trois vues (§3.3–3.5) consomment **la même sortie de pipeline**, ce qui
garantit qu'un lieu renommé ou une zone privée se comporte identiquement
partout. C'est aussi ce qui rend les agrégations composables demandées en
§3.4 réalistes : les stats sont des requêtes sur ce flux filtré, pas des
tables pré-calculées figées.

### 5.5 Points de vigilance sur ce schéma

- **Volume** : `raw_point` est la table qui explose (potentiellement des
  millions de lignes sur 10 ans). Dimensionner les index en conséquence et
  prévoir une table d'agrégats pré-calculés si les stats deviennent lentes
  — dépend de la réponse à la question ouverte sur le volume cible (§4).
- **Web** : ce schéma tourne sur `sqlite3.wasm` + IndexedDB (§3.2), avec le
  quota navigateur comme limite dure. Le fichier source conservé (§3.2)
  pèse en plus de la base — à surveiller côté web.
- **Fuseaux horaires** : stocker l'UTC + l'offset séparément (et non l'heure
  locale seule) est indispensable pour les patterns horaires (§3.4) et les
  trajets qui traversent des fuseaux.

## 6. Structure du monorepo

Arborescence cible. Rien ici n'est du code — c'est le contrat d'organisation
à mettre en place au premier commit.

```
odysseia/
├── README.md                  # présentation, install, export Timeline.json
├── LICENSE                    # MIT (§3.9)
├── CHANGELOG.md
├── docs/
│   ├── specs.md               # ce document
│   ├── privacy.md             # politique de confidentialité (§3.7)
│   └── data-model.md          # détail du schéma §5 si besoin d'approfondir
│
├── core/                      # crate Rust — timeline_core
│   ├── Cargo.toml
│   ├── src/
│   │   ├── lib.rs             # API publique exposée au bridge
│   │   ├── error.rs           # types d'erreur dédiés par cas (§3.10)
│   │   ├── model/             # Point, Segment, Visit, PrivateZone... (§5)
│   │   ├── parse/
│   │   │   ├── mod.rs         # trait commun d'import (générique, §3.1)
│   │   │   ├── google.rs      # legacy semanticSegments + direct-array
│   │   │   └── coords.rs      # E7, geo:, degrés, latLng → décimal
│   │   ├── pipeline/          # zones privées → noms → overrides → filtres (§5.4)
│   │   ├── stats/             # agrégations composables (§3.4)
│   │   ├── geocode/           # recherche plus proche voisin dans geo_place
│   │   └── render/            # génération des frames vidéo (§3.5)
│   ├── tests/                 # tests unitaires + intégration (§3.10)
│   └── fixtures/              # exports synthétiques : formats, cas limites
│
├── bridge/                    # génération flutter_rust_bridge
│   └── (config + fichiers générés, non édités à la main)
│
├── app/                       # application Flutter
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main.dart
│   │   ├── l10n/              # en + fr (§3.9)
│   │   ├── data/              # drift/SQLite, accès au core via le bridge
│   │   ├── features/
│   │   │   ├── import/        # sélection fichier, progression, avertissements
│   │   │   ├── story/         # vue Récit (§3.3)
│   │   │   ├── stats/         # vue Stats (§3.4)
│   │   │   ├── video/         # vue Vidéo (§3.5)
│   │   │   ├── places/        # édition manuelle des lieux (§3.3)
│   │   │   ├── privacy_zones/ # zones privées (§3.7)
│   │   │   └── settings/      # capacités, intégrations optionnelles (§2)
│   │   └── shared/            # widgets carte, thème, utilitaires
│   ├── test/                  # unitaires + golden (§3.10)
│   └── (android/ ios/ web/ windows/ macos/ linux/)
│
├── assets/
│   └── geo_place/             # base GeoNames filtrée, embarquée (§5.3)
│
└── .github/workflows/
    └── ci.yml                 # CI légère : cargo test/clippy, flutter test,
                               # build de vérification Android + web (§3.9)
```

### 6.1 Règles de dépendance

- `core/` ne dépend **jamais** de Flutter ni de Dart. Il est testable seul
  (`cargo test`), sans émulateur ni device.
- `app/` ne réimplémente **aucune** logique métier : parsing, clustering,
  stats et génération de frames vivent dans `core/`. Le Dart orchestre l'UI,
  la base et les appels au bridge.
- Le pipeline §5.4 est le **point de passage unique** vers les données. Aucune
  vue n'interroge la base directement en contournant les zones privées.
- Les fichiers générés par `flutter_rust_bridge` sont commités mais jamais
  édités à la main.

### 6.2 Points d'attention pour la mise en place

- La toolchain Rust doit être disponible dans la CI **et** en local (targets
  Android/iOS/desktop + `wasm32-unknown-unknown` pour le web).
- Le build web nécessite une étape WASM distincte du build natif — c'est
  généralement le point le plus pénible à configurer, à faire tôt plutôt que
  tard, même avec une CI légère.
- `assets/geo_place/` peut être volumineux : décider dès le départ s'il est
  versionné dans Git (simple mais lourd) ou généré/téléchargé par un script
  de build (repo léger, étape supplémentaire).

## 7. Prochaines étapes

Toutes les questions sont tranchées. Ordre de démarrage :

1. Créer le repo Git et l'arborescence §6 (squelette vide + CI légère)
2. Implémenter le parsing en streaming + fixtures de test (§3.10), point
   d'entrée de toute la chaîne
3. Poser le schéma §5 en base (drift/SQLite) et le pipeline §5.4
4. Construire les vues une à une (Récit → Stats → Vidéo)

Note : à reprendre depuis Claude Code une fois le repo créé — ce document
(`docs/specs.md`) est le point d'entrée pour retrouver tout le contexte.
