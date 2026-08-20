# Politique de confidentialité — Odysseia

> Placeholder — à rédiger (§3.7). Aucune fonctionnalité n'étant implémentée,
> ce document ne décrit encore aucun traitement réel.

À couvrir, d'après §3.7 :

- Ce qui est stocké **localement** : base SQLite (§5), fichier `Timeline.json`
  source conservé et exports archivés (§3.2 / §4).
- **Zéro transfert réseau** des données Timeline (§2) — principe général.
- Intégrations réseau **optionnelles, désactivées par défaut**, et ce que
  chacune transmet exactement :
  - serveur Immich personnel (§3.1) ;
  - API météo historique (§3.3) — coordonnées arrondies à 2 décimales + date.
- Tuiles de carte OpenStreetMap (§2) : consentement explicite, seules les zones
  de carte affichées transitent, jamais de donnée Timeline.
- **Crash log local** (§3.10) : jamais transmis automatiquement, export manuel.
- Droits de l'utilisateur : export complet et suppression totale des données
  locales depuis l'écran « Mes données » (§3.7).
