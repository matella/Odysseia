// La garantie centrale du schéma (§5.2) : **un ré-import n'efface rien de ce
// que l'utilisateur a produit**.
//
// « Un nouvel import remplace tout » (§3.1) vaut pour la zone §5.1 et pour
// elle seule. Si l'utilisateur perdait ses lieux nommés, ses zones privées et
// ses corrections à chaque mise à jour de son export Google, il referait le
// même travail indéfiniment — la fonctionnalité serait inutilisable.
//
// La survie du *sens* (une correction retrouve son trajet après redécoupage)
// est vérifiée côté Rust, dans `core/tests/pipeline_reimport.rs`.

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odysseia/data/database.dart';

void main() {
  late OdysseiaDatabase db;

  setUp(() {
    db = OdysseiaDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });

  tearDown(() => db.close());

  /// Remplit la zone utilisateur (§5.2) comme le ferait un utilisateur après
  /// quelques semaines d'usage.
  Future<void> seedUserZone() async {
    await db
        .into(db.userPlaces)
        .insert(
          UserPlacesCompanion.insert(
            label: 'Maison',
            lat: 48.8584,
            lon: 2.2945,
            radiusM: 200,
            createdAt: 1700000000000,
            updatedAt: 1700000000000,
          ),
        );
    await db
        .into(db.privateZones)
        .insert(
          PrivateZonesCompanion.insert(
            label: 'Chez mes parents',
            shapeKind: 'circle',
            lat: const Value(43.2965),
            lon: const Value(5.3698),
            radiusM: const Value(1000),
            createdAt: 1700000000000,
          ),
        );
    await db
        .into(db.userSegmentOverrides)
        .insert(
          // Valeurs déjà arrondies : l'arrondi est calculé dans `core/`,
          // jamais côté Dart (§6.1).
          UserSegmentOverridesCompanion.insert(
            localDate: 19797,
            startLatR: 48.86,
            startLonR: 2.29,
            endLatR: 48.86,
            endLonR: 2.34,
            correctedMode: 'cycling',
            sourceStartTsUtc: 1710489900000,
            createdAt: 1710500000000,
          ),
        );
    await db
        .into(db.appSettings)
        .insert(
          AppSettingsCompanion.insert(
            settingKey: 'weather_integration_enabled',
            settingValue: 'false',
          ),
        );
  }

  /// Simule un import : un lot, une visite, un segment, deux points.
  Future<int> runImport({required String path, required int importedAt}) {
    return db.replaceImport(
      batch: ImportBatchesCompanion.insert(
        importedAt: importedAt,
        sourceKind: 'google_timeline',
        sourceFilePath: path,
        sourceFormatDetected: 'google_direct_array',
        periodStart: Value(importedAt - 1000),
        periodEnd: Value(importedAt),
        pointCount: const Value(2),
      ),
      points: (batchId) => [
        RawPointsCompanion.insert(
          batchId: batchId,
          timestampUtc: importedAt,
          tzOffsetMinutes: 60,
          lat: 48.8584,
          lon: 2.2945,
          sourceKind: 'google_timeline',
        ),
        RawPointsCompanion.insert(
          batchId: batchId,
          timestampUtc: importedAt + 60000,
          tzOffsetMinutes: 60,
          lat: 48.8606,
          lon: 2.3376,
          sourceKind: 'google_timeline',
        ),
      ],
      segmentRows: (batchId) => [
        SegmentsCompanion.insert(
          batchId: batchId,
          startTsUtc: importedAt,
          startTzOffsetMinutes: 60,
          endTsUtc: importedAt + 60000,
          endTzOffsetMinutes: 60,
          startLat: 48.8584,
          startLon: 2.2945,
          endLat: 48.8606,
          endLon: 2.3376,
          detectedMode: 'walking',
          sourceKind: 'google_timeline',
        ),
      ],
      visitRows: (batchId) => [
        VisitsCompanion.insert(
          batchId: batchId,
          arrivalTsUtc: importedAt,
          arrivalTzOffsetMinutes: 60,
          departureTsUtc: importedAt + 60000,
          departureTzOffsetMinutes: 60,
          lat: 48.8584,
          lon: 2.2945,
          sourceKind: 'google_timeline',
        ),
      ],
    );
  }

  group('ré-import (§3.1) — la zone utilisateur survit', () {
    test('les lieux nommés survivent', () async {
      await runImport(path: 'export-1.json', importedAt: 1710000000000);
      await seedUserZone();

      await runImport(path: 'export-2.json', importedAt: 1720000000000);

      final places = await db.select(db.userPlaces).get();
      expect(places, hasLength(1));
      expect(places.single.label, 'Maison');
      expect(places.single.radiusM, 200);
    });

    test('les zones privées survivent', () async {
      await runImport(path: 'export-1.json', importedAt: 1710000000000);
      await seedUserZone();

      await runImport(path: 'export-2.json', importedAt: 1720000000000);

      final zones = await db.select(db.privateZones).get();
      expect(zones, hasLength(1));
      expect(zones.single.label, 'Chez mes parents');
      expect(zones.single.radiusM, 1000);
    });

    test('les corrections de mode survivent, empreinte intacte', () async {
      await runImport(path: 'export-1.json', importedAt: 1710000000000);
      await seedUserZone();

      await runImport(path: 'export-2.json', importedAt: 1720000000000);

      final overrides = await db.select(db.userSegmentOverrides).get();
      expect(overrides, hasLength(1));
      expect(overrides.single.correctedMode, 'cycling');
      expect(overrides.single.localDate, 19797);
      expect(overrides.single.startLatR, 48.86);
      expect(overrides.single.endLonR, 2.34);
    });

    test('les réglages survivent — un consentement révoqué le reste', () async {
      // §2 : une intégration réseau désactivée ne doit jamais se réactiver
      // toute seule à la faveur d'un import.
      await runImport(path: 'export-1.json', importedAt: 1710000000000);
      await seedUserZone();

      await runImport(path: 'export-2.json', importedAt: 1720000000000);

      final settings = await db.select(db.appSettings).get();
      expect(settings.single.settingValue, 'false');
    });

    test('dix ré-imports successifs ne grignotent rien', () async {
      await seedUserZone();
      for (var i = 0; i < 10; i++) {
        await runImport(path: 'export-$i.json', importedAt: 1710000000000 + i);
      }

      expect(await db.select(db.userPlaces).get(), hasLength(1));
      expect(await db.select(db.privateZones).get(), hasLength(1));
      expect(await db.select(db.userSegmentOverrides).get(), hasLength(1));
      expect(await db.select(db.appSettings).get(), hasLength(1));
    });
  });

  group('ré-import (§3.1) — la zone importée est bien remplacée', () {
    test('le nouvel import remplace l\'ancien, il ne s\'y ajoute pas', () async {
      await runImport(path: 'export-1.json', importedAt: 1710000000000);
      await runImport(path: 'export-2.json', importedAt: 1720000000000);

      final batches = await db.select(db.importBatches).get();
      expect(batches, hasLength(1), reason: 'un seul jeu de données (§3.6)');
      expect(batches.single.sourceFilePath, 'export-2.json');

      expect(await db.select(db.rawPoints).get(), hasLength(2));
      expect(await db.select(db.segments).get(), hasLength(1));
      expect(await db.select(db.visits).get(), hasLength(1));
    });

    test('aucune ligne orpheline ne subsiste', () async {
      await runImport(path: 'export-1.json', importedAt: 1710000000000);
      final batchId = await runImport(
        path: 'export-2.json',
        importedAt: 1720000000000,
      );

      final points = await db.select(db.rawPoints).get();
      expect(points.every((p) => p.batchId == batchId), isTrue);
    });

    test('wipeImportedZone ne touche pas la zone utilisateur', () async {
      await runImport(path: 'export-1.json', importedAt: 1710000000000);
      await seedUserZone();

      await db.wipeImportedZone();

      expect(await db.select(db.rawPoints).get(), isEmpty);
      expect(await db.select(db.importBatches).get(), isEmpty);
      expect(await db.select(db.userPlaces).get(), hasLength(1));
      expect(await db.select(db.privateZones).get(), hasLength(1));
      expect(await db.select(db.userSegmentOverrides).get(), hasLength(1));
    });
  });

  group('suppression explicite (§3.7)', () {
    test('deleteAllUserData emporte les deux zones', () async {
      await runImport(path: 'export-1.json', importedAt: 1710000000000);
      await seedUserZone();

      await db.deleteAllUserData();

      expect(await db.select(db.userPlaces).get(), isEmpty);
      expect(await db.select(db.privateZones).get(), isEmpty);
      expect(await db.select(db.userSegmentOverrides).get(), isEmpty);
      expect(await db.select(db.appSettings).get(), isEmpty);
      expect(await db.select(db.importBatches).get(), isEmpty);
    });
  });
}
