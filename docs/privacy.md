# Politique de confidentialité — Odysseia

Dernière mise à jour : voir l'historique Git de ce fichier.

Odysseia explore vos données Google Timeline. Ces données disent où vous avez
été, quand, et avec quelle régularité — c'est-à-dire à peu près tout de votre
vie quotidienne. Ce document dit précisément ce que l'application en fait.

## En résumé

**Vos données Timeline ne quittent jamais votre appareil.** Il n'y a pas de
compte, pas de serveur Odysseia, pas de synchronisation. Analyse, statistiques
et génération vidéo tournent localement.

Il n'y a **ni télémétrie, ni analytics, ni rapport de crash automatique, ni
configuration distante, ni vérification de mise à jour**.

Trois fonctionnalités peuvent émettre du réseau. Elles sont listées plus bas,
avec ce qu'elles transmettent exactement. Deux sont **désactivées par
défaut** ; la troisième demande votre accord avant le premier chargement.

## Ce qui est stocké, et où

Tout est sur votre appareil :

| Donnée | Contenu |
| --- | --- |
| Base locale | positions, trajets et arrêts issus de votre export ; vos lieux nommés, zones privées et corrections ; vos réglages |
| Fichier source | l'export Timeline importé est conservé, pour pouvoir être ré-analysé si le modèle de données évolue |
| Journal d'erreurs | local, pour le diagnostic |

Sur le web, ce stockage vit dans le navigateur (IndexedDB) et reste soumis à
son quota : le navigateur peut le purger, et vous pouvez l'effacer vous-même.

Personne d'autre que vous n'y a accès. Odysseia n'a aucun moyen de lire ces
données à distance — il n'y a pas de « à distance ».

## Les trois exceptions réseau

### 1. Tuiles de carte (OpenStreetMap)

**Ce qui est transmis** : les coordonnées des zones de carte affichées à
l'écran, et rien d'autre.

**Ce qui n'est pas transmis** : aucune donnée Timeline. Ni vos positions, ni
vos trajets, ni vos lieux.

Une zone de carte affichée reste une information : elle indique une région
qui vous intéresse. C'est pourquoi votre accord est demandé avant le premier
chargement, et pourquoi vous pouvez le retirer à tout moment dans les
réglages. Sans accord, l'application fonctionne sans fond de carte.

Destinataire : les serveurs de tuiles OpenStreetMap.

### 2. Serveur photo Immich — désactivé par défaut

**Ce qui est transmis** : des dates et des coordonnées **dérivées de votre
Timeline**, envoyées au serveur Immich que vous configurez, pour retrouver les
photos correspondant à vos déplacements.

C'est bien de la donnée de localisation qui sort de l'appareil. Le serveur est
le vôtre, mais la promesse « zéro réseau » est rompue pour cette
fonctionnalité — c'est le sens de son interrupteur dédié.

Destinataire : le serveur que vous indiquez, et lui seul.

### 3. Météo historique — désactivée par défaut

**Ce qui est transmis** : une date et des coordonnées **arrondies à
2 décimales**, soit une précision d'environ 1,1 km, à une API météo tierce.

L'arrondi est appliqué avant tout appel : le service n'apprend jamais votre
position à la rue près. Les réponses sont mises en cache localement par
(cellule, jour), de sorte qu'une même cellule n'est jamais redemandée.

Cela reste une trace de vos déplacements chez un tiers, en gros. D'où
l'interrupteur, et le défaut à « désactivé ».

Destinataire : le service météo configuré.

## Journal d'erreurs

En cas de problème, Odysseia écrit un journal **local**. Il n'est **jamais**
transmis automatiquement. Si vous souhaitez le partager pour signaler un bug,
vous devez l'exporter explicitement — et vous pouvez le lire avant.

## Vos données vous appartiennent

L'écran « Mes données » propose :

- **l'export complet** de ce qui est stocké, dans un format lisible ;
- **la suppression totale** des données locales, avec confirmation. C'est
  irréversible : les données importées, vos lieux nommés, vos zones privées et
  vos corrections partent ensemble.

Vous pouvez aussi désinstaller l'application : rien ne subsiste ailleurs,
puisque rien n'a jamais été envoyé ailleurs.

## Zones privées

Vous pouvez définir des zones géographiques exclues. Une position située dans
une zone privée est écartée **à la source** : elle est absente des vues, des
statistiques, des vidéos générées **et** de l'export. Elle n'est pas seulement
masquée à l'écran.

## Enfants et tiers

Un export Timeline contient les déplacements de la personne qui l'a produit,
et peut révéler ceux des personnes qui l'accompagnent. Odysseia ne partage
rien, mais une vidéo que **vous** exportez et publiez, elle, sort de
l'appareil. Les zones privées existent aussi pour cela.

## Modifications

Ce document évolue avec l'application. Son historique complet est dans le
dépôt Git : toute modification y est visible, datée et attribuée.

## Contact

Odysseia est un projet libre sous licence MIT, sans éditeur ni service
client. Questions et signalements passent par les issues du dépôt.
