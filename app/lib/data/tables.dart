// Tables drift du schéma §5.
//
// La frontière entre les trois zones est la chose importante de ce fichier :
//
//   §5.1 zone importée     — vidée et reconstruite à chaque import
//   §5.2 zone utilisateur  — JAMAIS touchée par un import
//   §5.3 référentiel       — embarqué, lecture seule
//
// Règle vérifiée par `test/data/schema_test.dart` : **aucune table de §5.2 ne
// porte de clé étrangère vers §5.1**. Les identifiants de la zone importée
// changent à chaque ré-import (§3.1) ; une donnée utilisateur qui en
// référencerait un serait cassée à chaque mise à jour de l'export. Le
// rattachement est géographique ou par empreinte tolérante (§4), calculé dans
// `core/` — jamais ici (§6.1).

import 'package:drift/drift.dart';

// ---------------------------------------------------------------------------
// §5.1 — zone importée (remplaçable)
// ---------------------------------------------------------------------------

/// Un import = un enregistrement (§5.1).
///
/// Sert à afficher « vos données couvrent telle période » et à avertir avant
/// écrasement si le nouvel export couvre moins que l'ancien (§4).
@DataClassName('ImportBatch')
class ImportBatches extends Table {
  /// Identifiant.
  IntColumn get id => integer().autoIncrement()();

  /// Instant de l'import, en millisecondes UTC.
  IntColumn get importedAt => integer()();

  /// Origine des données (`google_timeline`, plus tard `gpx`…).
  TextColumn get sourceKind => text()();

  /// Chemin du fichier source conservé (§3.2).
  TextColumn get sourceFilePath => text()();

  /// Format concret détecté à l'analyse.
  TextColumn get sourceFormatDetected => text()();

  /// Début de la période couverte, en millisecondes UTC.
  IntColumn get periodStart => integer().nullable()();

  /// Fin de la période couverte, en millisecondes UTC.
  IntColumn get periodEnd => integer().nullable()();

  /// Nombre de positions brutes importées.
  IntColumn get pointCount => integer().withDefault(const Constant(0))();
}

/// Position brute (§5.1).
///
/// C'est la table qui explose : environ 5 millions de lignes sur dix ans
/// (§5.5). D'où les deux index ci-dessous — navigation temporelle (§3.3) et
/// filtres spatiaux / heatmap (§3.4).
@TableIndex(name: 'raw_point_time', columns: {#timestampUtc})
@TableIndex(name: 'raw_point_space', columns: {#lat, #lon})
class RawPoints extends Table {
  /// Identifiant.
  IntColumn get id => integer().autoIncrement()();

  /// Import d'origine.
  IntColumn get batchId =>
      integer().references(ImportBatches, #id, onDelete: KeyAction.cascade)();

  /// Instant UTC, en millisecondes.
  IntColumn get timestampUtc => integer()();

  /// Décalage local, en minutes — stocké séparément (§5.5).
  IntColumn get tzOffsetMinutes => integer()();

  /// Latitude décimale.
  RealColumn get lat => real()();

  /// Longitude décimale.
  RealColumn get lon => real()();

  /// Précision annoncée, en mètres.
  RealColumn get accuracyM => real().nullable()();

  /// Altitude, en mètres.
  RealColumn get altitudeM => real().nullable()();

  /// Vitesse, en mètres par seconde.
  RealColumn get speedMs => real().nullable()();

  /// Origine de l'enregistrement (§3.1).
  TextColumn get sourceKind => text()();
}

/// Déplacement détecté entre deux visites (§5.1).
@TableIndex(name: 'segment_time', columns: {#startTsUtc})
class Segments extends Table {
  /// Identifiant.
  IntColumn get id => integer().autoIncrement()();

  /// Import d'origine.
  IntColumn get batchId =>
      integer().references(ImportBatches, #id, onDelete: KeyAction.cascade)();

  /// Début, en millisecondes UTC.
  IntColumn get startTsUtc => integer()();

  /// Décalage local au départ, en minutes.
  IntColumn get startTzOffsetMinutes => integer()();

  /// Fin, en millisecondes UTC.
  IntColumn get endTsUtc => integer()();

  /// Décalage local à l'arrivée — différent du départ si le trajet traverse un
  /// fuseau (§5.5).
  IntColumn get endTzOffsetMinutes => integer()();

  /// Latitude de départ.
  RealColumn get startLat => real()();

  /// Longitude de départ.
  RealColumn get startLon => real()();

  /// Latitude d'arrivée.
  RealColumn get endLat => real()();

  /// Longitude d'arrivée.
  RealColumn get endLon => real()();

  /// Distance annoncée, en mètres.
  RealColumn get distanceM => real().nullable()();

  /// Mode détecté par la source.
  ///
  /// ⚠️ Garde **toujours** sa valeur d'origine (§5.1). Une correction
  /// utilisateur vit dans [UserSegmentOverrides] et est appliquée par le
  /// pipeline (§5.4) — jamais réécrite ici.
  TextColumn get detectedMode => text()();

  /// Confiance de détection, dans [0, 1].
  RealColumn get modeConfidence => real().nullable()();

  /// Origine de l'enregistrement (§3.1).
  TextColumn get sourceKind => text()();
}

/// Arrêt détecté à un endroit (§5.1).
@TableIndex(name: 'visit_time', columns: {#arrivalTsUtc})
@TableIndex(name: 'visit_space', columns: {#lat, #lon})
class Visits extends Table {
  /// Identifiant.
  IntColumn get id => integer().autoIncrement()();

  /// Import d'origine.
  IntColumn get batchId =>
      integer().references(ImportBatches, #id, onDelete: KeyAction.cascade)();

  /// Arrivée, en millisecondes UTC.
  IntColumn get arrivalTsUtc => integer()();

  /// Décalage local à l'arrivée, en minutes.
  IntColumn get arrivalTzOffsetMinutes => integer()();

  /// Départ, en millisecondes UTC.
  IntColumn get departureTsUtc => integer()();

  /// Décalage local au départ, en minutes.
  IntColumn get departureTzOffsetMinutes => integer()();

  /// Latitude du lieu.
  RealColumn get lat => real()();

  /// Longitude du lieu.
  RealColumn get lon => real()();

  /// Rayon annoncé, en mètres.
  RealColumn get radiusM => real().nullable()();

  /// Identifiant de lieu **propre à la source** (`placeId` Google).
  ///
  /// Distinct du `place_id` de §5.1, qui référence le référentiel embarqué
  /// [GeoPlaces] et est résolu par le pipeline : y recopier l'identifiant
  /// Google calquerait le modèle sur Google (§3.1).
  TextColumn get externalPlaceRef => text().nullable()();

  /// Lieu du référentiel résolu, quand il l'a été (§5.3).
  IntColumn get placeId => integer().nullable().references(GeoPlaces, #id)();

  /// Confiance de détection, dans [0, 1].
  RealColumn get detectionConfidence => real().nullable()();

  /// Origine de l'enregistrement (§3.1).
  TextColumn get sourceKind => text()();
}

// ---------------------------------------------------------------------------
// §5.2 — zone utilisateur (protégée, jamais écrasée)
// ---------------------------------------------------------------------------

/// Lieu nommé par l'utilisateur (§5.2).
///
/// Rattaché **géographiquement** : une visite lui appartient si elle tombe
/// dans son rayon. Aucun identifiant d'import n'apparaît ici — c'est ce qui
/// permet à « Maison » de persister indéfiniment.
@TableIndex(name: 'user_place_space', columns: {#lat, #lon})
class UserPlaces extends Table {
  /// Identifiant.
  IntColumn get id => integer().autoIncrement()();

  /// Nom donné par l'utilisateur.
  TextColumn get label => text()();

  /// Latitude du centre.
  RealColumn get lat => real()();

  /// Longitude du centre.
  RealColumn get lon => real()();

  /// Rayon de rattachement, en mètres.
  RealColumn get radiusM => real()();

  /// Création, en millisecondes UTC.
  IntColumn get createdAt => integer()();

  /// Dernière modification, en millisecondes UTC.
  IntColumn get updatedAt => integer()();
}

/// Zone géographique exclue (§3.7).
///
/// Appliquée **à la source** par le pipeline (§5.4, étape 1), jamais au rendu.
class PrivateZones extends Table {
  /// Identifiant.
  IntColumn get id => integer().autoIncrement()();

  /// Nom donné par l'utilisateur.
  TextColumn get label => text()();

  /// `circle` ou `polygon`.
  TextColumn get shapeKind => text()();

  /// Latitude du centre, pour un cercle.
  RealColumn get lat => real().nullable()();

  /// Longitude du centre, pour un cercle.
  RealColumn get lon => real().nullable()();

  /// Rayon, en mètres, pour un cercle.
  RealColumn get radiusM => real().nullable()();

  /// Tracé GeoJSON, pour un polygone.
  TextColumn get polygonGeojson => text().nullable()();

  /// Création, en millisecondes UTC.
  IntColumn get createdAt => integer()();
}

/// Correction manuelle d'un mode de transport (§5.2).
///
/// Appariée par **empreinte tolérante** (§4) : date locale + extrémités
/// arrondies, sans les bornes temporelles exactes du segment, pour survivre à
/// un redécoupage lors d'un ré-import. Les valeurs arrondies sont calculées
/// dans `core/`, jamais ici (§6.1).
@TableIndex(name: 'override_fingerprint', columns: {#localDate})
class UserSegmentOverrides extends Table {
  /// Identifiant.
  IntColumn get id => integer().autoIncrement()();

  /// Date locale du trajet corrigé, en jours depuis l'epoch.
  IntColumn get localDate => integer()();

  /// Latitude de départ arrondie.
  RealColumn get startLatR => real()();

  /// Longitude de départ arrondie.
  RealColumn get startLonR => real()();

  /// Latitude d'arrivée arrondie.
  RealColumn get endLatR => real()();

  /// Longitude d'arrivée arrondie.
  RealColumn get endLonR => real()();

  /// Mode corrigé par l'utilisateur.
  TextColumn get correctedMode => text()();

  /// Début du segment au moment de la correction.
  ///
  /// Ne fait pas partie de la clé d'appariement : sert uniquement à départager
  /// plusieurs segments de même empreinte le même jour (§4).
  IntColumn get sourceStartTsUtc => integer()();

  /// Création, en millisecondes UTC.
  IntColumn get createdAt => integer()();
}

/// Réglage applicatif, clé/valeur (§5.2).
///
/// Porte les interrupteurs des intégrations optionnelles (Immich, météo — §2),
/// le consentement aux tuiles de carte, la langue (§3.9) et les préférences de
/// rendu vidéo (§3.5). Survit aux imports : un consentement réseau révoqué ne
/// doit jamais se réactiver tout seul.
class AppSettings extends Table {
  /// Clé du réglage.
  TextColumn get settingKey => text()();

  /// Valeur sérialisée.
  TextColumn get settingValue => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}

// ---------------------------------------------------------------------------
// §5.3 — référentiel embarqué (lecture seule)
// ---------------------------------------------------------------------------

/// Base offline GeoNames filtrée (§5.3).
///
/// Peuplée depuis l'asset embarqué (`assets/geo_place/`), jamais par
/// l'utilisateur et jamais par un import. Aucun appel réseau (§2).
@TableIndex(name: 'geo_place_space', columns: {#lat, #lon})
class GeoPlaces extends Table {
  /// Identifiant GeoNames.
  IntColumn get id => integer()();

  /// Nom du lieu.
  TextColumn get name => text()();

  /// Nom sans diacritiques, pour la recherche.
  TextColumn get nameAscii => text()();

  /// Code pays ISO.
  TextColumn get countryCode => text()();

  /// Première subdivision administrative.
  TextColumn get admin1 => text().nullable()();

  /// Classe GeoNames.
  TextColumn get featureClass => text().nullable()();

  /// Population, quand elle est connue.
  IntColumn get population => integer().nullable()();

  /// Latitude.
  RealColumn get lat => real()();

  /// Longitude.
  RealColumn get lon => real()();

  @override
  Set<Column> get primaryKey => {id};
}
