// L'app de bout en bout : import réel → base → pipeline → vues.
//
// C'est le seul test qui traverse toute la chaîne. Les autres vérifient un
// maillon ; celui-ci vérifie qu'ils sont bien reliés — c'est précisément ce
// qui manquait quand le dépôt existait sans que la moindre vue l'appelle.

import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odysseia/data/database.dart';
import 'package:odysseia/data/import_service.dart';
import 'package:odysseia/data/timeline_repository.dart';
import 'package:odysseia/features/home_shell.dart';
import 'package:odysseia/l10n/generated/app_localizations.dart';

import '../bridge/rust_lib.dart';

/// Attend qu'un widget apparaisse, en laissant tourner l'horloge réelle.
///
/// `pumpAndSettle` seul ne suffit pas ici : l'import et le pipeline font du
/// vrai travail asynchrone — lecture de fichier, appel FFI — que le temps
/// simulé des tests de widgets n'avance pas. `runAsync` rend la main à la
/// boucle d'événements réelle entre deux pompages.
Future<void> pumpUntil(
  WidgetTester tester,
  Finder finder, {
  int attempts = 60,
}) async {
  for (var attempt = 0; attempt < attempts; attempt++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 25)),
    );
    await tester.pumpAndSettle();
  }
}

void main() {
  late OdysseiaDatabase db;

  setUpAll(initRustForTests);

  setUp(() {
    db = OdysseiaDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });

  tearDown(() => db.close());

  Future<void> pump(
    WidgetTester tester, {
    String? pickPath,
    DateTime? now,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeShell(
          repository: TimelineRepository(db),
          importService: ImportService(db),
          pickPath: pickPath == null ? null : () async => pickPath,
          // Les fixtures couvrent le 15 mars 2024.
          now: now ?? DateTime(2024, 3, 15),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('les cinq onglets sont accessibles', (tester) async {
    await pump(tester);
    for (final label in ['Story', 'Stats', 'Video', 'Import', 'Settings']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
  });

  testWidgets('sans données, le Récit affiche son état vide', (tester) async {
    await pump(tester);
    expect(find.text('Nothing recorded for this period'), findsOneWidget);
  });

  testWidgets('sans sélecteur, le bouton d\'import est désactivé', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Import').last);
    await tester.pumpAndSettle();

    expect(find.text('File picking is not wired up on this platform yet. '
        'Import works — it just needs a path.'), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('un import réel remplit le Récit (§3.3)', (tester) async {
    await pump(tester, pickPath: '../core/fixtures/google_direct_array.json');

    await tester.tap(find.text('Import').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose a file'));
    await pumpUntil(tester, find.text('Import finished'));

    expect(find.text('Import finished'), findsOneWidget);
    expect(find.text('1 stays · 1 trips · 3 points'), findsOneWidget);

    // La donnée traverse jusqu'à la vue, en passant par le pipeline.
    await tester.tap(find.text('Story').last);
    await pumpUntil(tester, find.textContaining('Stay at'));
    expect(find.text('Nothing recorded for this period'), findsNothing);
    expect(find.textContaining('Stay at'), findsWidgets);
  });

  testWidgets('les stats voient les mêmes données que le Récit', (
    tester,
  ) async {
    await pump(tester, pickPath: '../core/fixtures/google_direct_array.json');

    await tester.tap(find.text('Import').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose a file'));
    await pumpUntil(tester, find.text('Import finished'));

    await tester.tap(find.text('Stats').last);
    await pumpUntil(tester, find.text('1 stay'));
    expect(find.text('No data for these filters'), findsNothing);
    expect(find.text('1 stay'), findsOneWidget);
  });

  testWidgets('une zone privée retire la donnée de toutes les vues (§3.7)', (
    tester,
  ) async {
    // La garantie qui compte, vue depuis l'UI : ce n'est pas l'affichage qui
    // cache, c'est le pipeline qui ne livre pas.
    await db.into(db.privateZones).insert(
      PrivateZonesCompanion.insert(
        label: 'Maison',
        shapeKind: 'circle',
        lat: const Value(48.8584),
        lon: const Value(2.2945),
        radiusM: const Value(5000),
        createdAt: 1700000000000,
      ),
    );

    await pump(tester, pickPath: '../core/fixtures/google_direct_array.json');
    await tester.tap(find.text('Import').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose a file'));
    await pumpUntil(tester, find.text('Import finished'));

    // L'import a bien tout inséré…
    expect(find.text('1 stays · 1 trips · 3 points'), findsOneWidget);

    // …mais le Récit ne montre rien : la zone couvre toute la journée.
    await tester.tap(find.text('Story').last);
    await pumpUntil(tester, find.text('Nothing recorded for this period'));
    expect(find.text('Nothing recorded for this period'), findsOneWidget);
  });

  testWidgets('un export illisible affiche son message propre (§3.10)', (
    tester,
  ) async {
    await pump(tester, pickPath: '../core/fixtures/corrupt_truncated.json');

    await tester.tap(find.text('Import').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose a file'));
    await pumpUntil(
      tester,
      find.text('This file is not valid JSON and could not be read.'),
    );

    expect(
      find.text('This file is not valid JSON and could not be read.'),
      findsOneWidget,
    );
  });

  testWidgets('les réglages annoncent ce qui n\'est pas branché (§2)', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();

    expect(find.text('Video export'), findsOneWidget);
    expect(find.text('Not wired up yet'), findsOneWidget);
  });

  testWidgets('les intégrations sont désactivées par défaut (§2)', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();

    final switches = tester.widgetList<Switch>(find.byType(Switch));
    expect(switches, hasLength(3));
    expect(
      switches.every((s) => s.value == false),
      isTrue,
      reason: 'aucune intégration réseau ne doit être active sans action '
          'explicite de l\'utilisateur (§2)',
    );
  });

  testWidgets('chaque intégration dit ce qu\'elle transmet (§2)', (
    tester,
  ) async {
    // « Nécessite une connexion » ne suffit pas : §2 exige de nommer les
    // données transmises.
    await pump(tester);
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('coordinates rounded to 2 decimals'),
      findsOneWidget,
    );
    expect(find.textContaining('Never any Timeline data'), findsOneWidget);
    expect(
      find.textContaining('dates and coordinates derived from your Timeline'),
      findsOneWidget,
    );
  });
}
