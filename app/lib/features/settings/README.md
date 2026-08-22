# `settings/` — capacités et intégrations optionnelles

Regroupe (§2) :

- les fonctionnalités indisponibles ou dégradées selon la plateforme —
  affichées, jamais supprimées silencieusement ;
- les intégrations optionnelles, **désactivées par défaut**, chacune avec son
  interrupteur et un avertissement disant **explicitement** quelles données
  dérivées de la Timeline sont transmises : Immich (§3.1), météo (§3.3) ;
- le consentement tuiles de carte OSM (§2) ;
- l'écran « Mes données » : export complet + suppression totale (§3.7) ;
- l'export manuel du crash log local (§3.10).

## État

Fait : écran des capacités (§2), interrupteurs des trois intégrations avec le
détail de ce que chacune transmet, suppression totale des données locales
(§3.7).

Manque : la persistance des interrupteurs dans `app_setting` (§5.2), la
configuration du serveur Immich, et l'export complet des données — qui
demande d'écrire un fichier, donc une décision sur le stockage.
