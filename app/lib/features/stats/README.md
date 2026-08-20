# `stats/` — vue Stats & patterns (§3.4)

Heatmap de densité, classement des lieux, temps par lieu, patterns
horaires/jour de semaine, distance totale, répartition par mode.

Filtres combinables (période / lieu / mode). Les agrégations sont calculées
dans `core/`, sur le flux filtré du pipeline (§5.4) — pas en Dart.
