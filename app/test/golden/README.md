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

## Linux est la plateforme de référence

Les images sont produites **en CI, sous Linux**, et comparées seulement là.
Ailleurs — typiquement sous Windows — ces tests sont **sautés**, visiblement.

Ce n'est pas un choix de confort : une image produite sous Windows et rejouée
sous Linux diffère de 1 à 1,7 % des pixels, mesuré. Élargir la tolérance
jusqu'à absorber cet écart aurait rendu les goldens aveugles à ce qu'ils sont
censés attraper.

## Régénérer

```bash
gh workflow run CI -f update_goldens=true
```

Puis récupérer l'artefact `goldens` et remplacer `images/`. Regarder les
images avant de les commiter : un golden régénéré sans être lu ne vaut rien.

En cas d'échec en CI, l'artefact `golden-failures` contient les trois images
attendue / obtenue / différence.

## Tolérance

La comparaison accepte 0,5 % de pixels différents
(`test/flutter_test_config.dart`). Ce seuil ne sert plus à absorber un écart
entre OS — il n'y en a plus — mais la dérive d'une version de moteur Flutter à
l'autre. Un décalage de mise en page, un texte qui déborde ou une traduction
manquante changent bien davantage et font toujours échouer le test.

## Pas de pont ici

Les vues testées sont des widgets purs, alimentés par de la sortie de pipeline
figée. Un golden qui aurait besoin de la bibliothèque native testerait le pont
plutôt que le rendu — c'est le rôle de `test/bridge/`.
