# Golden tests (§3.10)

18 images de référence : **une par vue et par locale** (§3.9).

| Vue | Cas |
| --- | --- |
| Récit (§3.3) | journée typique, lieu non nommé, période vide, zones privées actives |
| Stats (§3.4) | les six statistiques, aucune donnée |
| Vidéo (§3.5) | plan calculé, avertissement web, rien à animer |

## Pourquoi deux locales

Le français est plus long que l'anglais. Le premier jeu de goldens a
immédiatement montré « Semaine » passant sur deux lignes dans le sélecteur de
granularité — un défaut invisible sur l'image anglaise. C'est exactement ce
qu'un golden par locale sert à attraper.

## Régénérer

```bash
cd app && flutter test test/golden --update-goldens
```

Regarder les images avant de les commiter : un golden régénéré sans être lu ne
vaut rien.

## Tolérance

La comparaison accepte 0,5 % de pixels différents
(`test/flutter_test_config.dart`). Les images sont produites sur la machine du
développeur et rejouées en CI sous Linux, où l'anticrénelage diffère
légèrement. Le seuil absorbe ce bruit ; un décalage de mise en page, un texte
qui déborde ou une traduction manquante en changent bien davantage et font
toujours échouer le test.

## Pas de pont ici

Les vues testées sont des widgets purs, alimentés par de la sortie de pipeline
figée. Un golden qui aurait besoin de la bibliothèque native testerait le pont
plutôt que le rendu — c'est le rôle de `test/bridge/`.
