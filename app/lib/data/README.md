# `data/` — accès aux données

Base locale **drift/SQLite** (§3.2, y compris web via `sqlite3.wasm` +
IndexedDB) et appels au `core/` Rust via le bridge.

| Fichier | Rôle |
| --- | --- |
| `tables.dart` | tables §5.1 / §5.2 / §5.3, et la frontière entre elles |
| `database.dart` | ouverture, ré-import, suppression des données |
| `database.g.dart` | **généré** par `build_runner`, jamais édité à la main |

## Ce que ce dossier ne fait pas

Aucune logique métier (§6.1). Pas de distance, pas de détection de mode, pas
de calcul d'empreinte, pas de résolution de nom de lieu : tout cela vit dans
`core/`. Ici on stocke et on orchestre.

Concrètement, les colonnes `local_date` et `*_r` de `user_segment_override`
arrivent **déjà calculées** par `core/` — les recalculer ici dupliquerait la
règle d'arrondi de §4, avec la certitude qu'elles divergeraient un jour.

## La règle qui compte (§5.2)

`wipeImportedZone()` et `replaceImport()` ne touchent qu'à
`importedZoneTables`. La zone utilisateur — lieux nommés, zones privées,
corrections, réglages — survit à tout ré-import. Vérifié par
`test/data/reimport_test.dart` et `test/data/schema_test.dart`.

Seul `deleteAllUserData()` emporte les deux zones : c'est l'action explicite
« supprimer mes données » de l'écran Mes données (§3.7).

## Régénérer le code drift

```bash
cd app && dart run build_runner build
```

## Le seul chemin vers les données

`timeline_repository.dart` est la seule classe autorisée à lire les tables
§5.1. Sa méthode de collecte est privée et ses méthodes publiques ne
renvoient que des types déjà passés par le pipeline §5.4, via le pont.

Une vue n'a aucun moyen d'obtenir une ligne brute : pour contourner les zones
privées, il faudrait modifier ce fichier — ce qui se voit en revue.
