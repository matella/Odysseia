// Base locale (§3.2) et opération de ré-import (§3.1).
//
// Ce fichier ne contient **aucune logique métier** (§6.1) : pas de calcul de
// distance, pas de détection de mode, pas d'empreinte. Il orchestre le
// stockage, rien de plus. Tout ce qui décide vit dans `core/`.

import 'package:drift/drift.dart';

import 'tables.dart';

part 'database.g.dart';

/// Base locale d'Odysseia (§5).
@DriftDatabase(
  tables: [
    // §5.1 — zone importée
    ImportBatches,
    RawPoints,
    Segments,
    Visits,
    // §5.2 — zone utilisateur
    UserPlaces,
    PrivateZones,
    UserSegmentOverrides,
    AppSettings,
    // §5.3 — référentiel embarqué
    GeoPlaces,
  ],
)
class OdysseiaDatabase extends _$OdysseiaDatabase {
  /// Ouvre la base sur l'exécuteur fourni.
  OdysseiaDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // Sans cette option, SQLite ignore les clés étrangères déclarées et le
      // `ON DELETE CASCADE` de la zone importée ne s'applique pas.
      await customStatement('pragma foreign_keys = ON;');
    },
  );

  /// Tables de la **zone importée** (§5.1) — vidées à chaque import.
  ///
  /// Ordre volontaire : les tables filles d'abord, `import_batch` en dernier,
  /// pour que la suppression ne bute pas sur les clés étrangères.
  List<TableInfo<Table, dynamic>> get importedZoneTables => [
    rawPoints,
    segments,
    visits,
    importBatches,
  ];

  /// Tables de la **zone utilisateur** (§5.2) — jamais touchées par un import.
  ///
  /// Cette liste n'est utilisée par aucune opération d'effacement : elle
  /// existe pour être *comparée* à [importedZoneTables] dans les tests, et
  /// pour rendre la frontière lisible plutôt qu'implicite.
  List<TableInfo<Table, dynamic>> get userZoneTables => [
    userPlaces,
    privateZones,
    userSegmentOverrides,
    appSettings,
  ];

  /// Tables du **référentiel embarqué** (§5.3) — lecture seule.
  List<TableInfo<Table, dynamic>> get referenceTables => [geoPlaces];

  /// Vide la zone importée (§5.1), et **elle seule**.
  ///
  /// Ne touche jamais à [userZoneTables] : c'est la garantie centrale de §5.2.
  /// Un utilisateur qui met son export à jour ne doit pas perdre ses lieux
  /// nommés, ses zones privées ni ses corrections.
  Future<void> wipeImportedZone() async {
    await transaction(() async {
      for (final table in importedZoneTables) {
        await delete(table).go();
      }
    });
  }

  /// Remplace l'import courant (§3.1 : un seul jeu de données à la fois).
  ///
  /// Tout se joue dans une seule transaction : si l'insertion échoue à
  /// mi-chemin, l'ancien import reste en place plutôt que de laisser une base
  /// à moitié vide (§3.10).
  ///
  /// L'appelant reste responsable d'archiver le fichier source et d'avertir si
  /// le nouvel export couvre une période plus courte que l'actuel (§4) — cette
  /// décision est de l'UI, pas du stockage.
  Future<int> replaceImport({
    required ImportBatchesCompanion batch,
    Iterable<RawPointsCompanion> Function(int batchId)? points,
    Iterable<SegmentsCompanion> Function(int batchId)? segmentRows,
    Iterable<VisitsCompanion> Function(int batchId)? visitRows,
  }) {
    return transaction(() async {
      for (final table in importedZoneTables) {
        await delete(table).go();
      }

      final batchId = await into(importBatches).insert(batch);

      // Insertion par lots plutôt que ligne par ligne (§4).
      await this.batch((b) {
        if (points != null) b.insertAll(rawPoints, points(batchId));
        if (segmentRows != null) b.insertAll(segments, segmentRows(batchId));
        if (visitRows != null) b.insertAll(visits, visitRows(batchId));
      });

      return batchId;
    });
  }

  /// Import courant, s'il y en a un (§3.6 : un seul à la fois).
  Future<ImportBatch?> currentImport() {
    return (select(importBatches)
          ..orderBy([(t) => OrderingTerm.desc(t.importedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Efface **toutes** les données locales (§3.7).
  ///
  /// Contrairement à [wipeImportedZone], celle-ci emporte aussi la zone
  /// utilisateur : c'est l'action « supprimer mes données », irréversible et
  /// explicitement confirmée par l'utilisateur dans l'écran « Mes données ».
  /// Le référentiel embarqué (§5.3) n'est pas une donnée personnelle et
  /// survit.
  Future<void> deleteAllUserData() async {
    await transaction(() async {
      for (final table in [...importedZoneTables, ...userZoneTables]) {
        await delete(table).go();
      }
    });
  }
}
