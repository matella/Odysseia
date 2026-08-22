// Import de bout en bout : fichier réel → parseur Rust → base drift.
//
// Les tests précédents vérifiaient le ré-import avec des données fabriquées à
// la main. Celui-ci part des **mêmes fixtures que le parseur Rust**
// (`core/fixtures/`), ce qui ferme la boucle : si le format change, un seul
// jeu de fichiers est à mettre à jour.

import 'dart:io';

import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odysseia/bridge/generated/api/import.dart';
import 'package:odysseia/data/database.dart';
import 'package:odysseia/data/import_service.dart';

import '../bridge/rust_lib.dart';

/// Chemin d'une fixture du cœur — une seule source de vérité.
String fixture(String name) => '../core/fixtures/$name';

void main() {
  late OdysseiaDatabase db;
  late ImportService service;

  setUpAll(initRustForTests);

  setUp(() {
    db = OdysseiaDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    service = ImportService(db);
  });

  tearDown(() => db.close());

  Future<ImportState> runImport(String name) async {
    final states = await service.import(fixture(name)).toList();
    return states.last;
  }

  test('la fixture existe — sinon le test ne prouverait rien', () {
    expect(File(fixture('google_direct_array.json')).existsSync(), isTrue);
  });

  test('un export valide remplit la zone importée', () async {
    final state = await runImport('google_direct_array.json');

    expect(state, isA<ImportDone>());
    final done = state as ImportDone;
    expect(done.summary.visitCount, 1);
    expect(done.summary.segmentCount, 1);
    expect(done.summary.pointCount, 3);
    expect(done.summary.format, 'google_direct_array');

    expect(await db.select(db.rawPoints).get(), hasLength(3));
    expect(await db.select(db.visits).get(), hasLength(1));
    expect(await db.select(db.segments).get(), hasLength(1));
  });

  test('le lot enregistre la période couverte (§5.1)', () async {
    await runImport('google_direct_array.json');
    final batch = await db.currentImport();

    expect(batch, isNotNull);
    expect(batch!.sourceFormatDetected, 'google_direct_array');
    expect(batch.periodStart, isNotNull);
    expect(batch.periodEnd, greaterThan(batch.periodStart!));
    expect(batch.pointCount, 3);
  });

  test('le format legacy est détecté et importé', () async {
    final state = await runImport('google_semantic_segments.json');

    final done = state as ImportDone;
    expect(done.summary.format, 'google_semantic_segments');
    expect(done.summary.visitCount, 1);
    expect(done.summary.segmentCount, 1);
  });

  test('la progression est remontée pendant la lecture (§4)', () async {
    final states = await service.import(fixture('google_direct_array.json')).toList();
    final running = states.whereType<ImportRunning>().toList();

    expect(running, isNotEmpty);
    expect(running.last.step, ImportStepKind.done);
  });

  group('cas limites (§3.10) — une cause, un état', () {
    test('export vide', () async {
      final state = await runImport('empty_direct_array.json');
      expect(state, isA<ImportFailed>());
      expect((state as ImportFailed).kind, ImportErrorKind.emptyExport);
    });

    test('JSON corrompu', () async {
      final state = await runImport('corrupt_truncated.json');
      expect((state as ImportFailed).kind, ImportErrorKind.corruptJson);
    });

    test('format futur non reconnu', () async {
      final state = await runImport('future_format.json');
      expect((state as ImportFailed).kind, ImportErrorKind.unrecognisedFormat);
    });

    test('fichier introuvable', () async {
      final state = await runImport('ce_fichier_nexiste_pas.json');
      expect((state as ImportFailed).kind, ImportErrorKind.io);
    });

    test('fichier trop volumineux', () async {
      final states = await service
          .import(fixture('google_direct_array.json'), maxBytes: 64)
          .toList();
      expect((states.last as ImportFailed).kind, ImportErrorKind.fileTooLarge);
    });

    test("un import raté laisse l'import précédent intact", () async {
      // §3.10 : plutôt garder l'ancien import qu'une base à moitié remplie.
      // La transaction annule et le vidage, et le lot fantôme — l'utilisateur
      // retrouve exactement ce qu'il avait avant d'essayer.
      await runImport('google_direct_array.json');
      await runImport('corrupt_truncated.json');

      final batches = await db.select(db.importBatches).get();
      expect(batches, hasLength(1));
      expect(batches.single.sourceFormatDetected, 'google_direct_array');
      expect(await db.select(db.rawPoints).get(), hasLength(3));
      expect(await db.select(db.visits).get(), hasLength(1));
    });
  });

  group('remplacement (§3.1, §4)', () {
    test('un second import remplace le premier', () async {
      await runImport('google_direct_array.json');
      await runImport('google_semantic_segments.json');

      expect(await db.select(db.importBatches).get(), hasLength(1));
      final batch = await db.currentImport();
      expect(batch!.sourceFormatDetected, 'google_semantic_segments');
    });

    test('la zone utilisateur survit à un import réel (§5.2)', () async {
      await db.into(db.userPlaces).insert(
        UserPlacesCompanion.insert(
          label: 'Maison',
          lat: 48.8584,
          lon: 2.2945,
          radiusM: 200,
          createdAt: 1700000000000,
          updatedAt: 1700000000000,
        ),
      );
      await db.into(db.privateZones).insert(
        PrivateZonesCompanion.insert(
          label: 'Chez mes parents',
          shapeKind: 'circle',
          lat: const Value(43.2965),
          lon: const Value(5.3698),
          radiusM: const Value(1000),
          createdAt: 1700000000000,
        ),
      );

      await runImport('google_direct_array.json');
      await runImport('google_semantic_segments.json');

      expect(await db.select(db.userPlaces).get(), hasLength(1));
      expect(await db.select(db.privateZones).get(), hasLength(1));
    });

    test('un export plus court déclenche l\'avertissement (§4)', () async {
      // Le premier export couvre mars 2024, le second novembre 2013 : la
      // période change, l'utilisateur doit être prévenu avant de perdre de
      // l'historique.
      await runImport('google_direct_array.json');
      final state = await runImport('google_semantic_segments.json');

      expect((state as ImportDone).shorterThanPrevious, isTrue);
    });

    test('un premier import ne déclenche aucun avertissement', () async {
      final state = await runImport('google_direct_array.json');
      expect((state as ImportDone).shorterThanPrevious, isFalse);
    });
  });
}
