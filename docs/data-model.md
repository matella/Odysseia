# Modèle de données — détail

> Placeholder (§6). Le schéma de référence est la **§5 de
> [`specs.md`](specs.md)** ; ce document l'approfondit au fur et à mesure de
> l'implémentation (index, migrations, requêtes du pipeline).

Rappel du principe directeur (§5) : séparer strictement **ce qui vient de
l'import** (remplaçable) de **ce que l'utilisateur a produit** (doit survivre à
tout ré-import).

| Zone | Tables | Ré-import |
| --- | --- | --- |
| Importée (§5.1) | `import_batch`, `raw_point`, `segment`, `visit` | vidée et reconstruite |
| Utilisateur (§5.2) | `user_place`, `user_segment_override`, `private_zone`, `app_setting` | **jamais touchée** |
| Référentiel (§5.3) | `geo_place` | embarquée, lecture seule |

À détailler ici :

- index retenus sur `raw_point` (temporel, spatial/géohash) et leur coût (§5.5) ;
- migrations drift et stratégie de version de schéma ;
- requêtes concrètes du pipeline §5.4 et leur composabilité (§3.4) ;
- appariement par empreinte tolérante des `user_segment_override` (§4) ;
- rattachement géographique des `user_place` aux visites (§5.2).
