// Socle des golden tests (§3.10).
//
// # Linux est la plateforme de référence
//
// Le rendu diffère assez d'un OS à l'autre pour qu'une image produite sous
// Windows échoue sous Linux — mesuré : 1 à 1,7 % des pixels, bien au-delà du
// bruit d'anticrénelage. Plutôt que d'élargir la tolérance jusqu'à ne plus
// rien détecter, les images sont produites **en CI, sous Linux**, et
// comparées seulement là. Ailleurs, ces tests sont sautés — visiblement, pas
// silencieusement.
//
//     gh workflow run CI -f update_goldens=true
//
// Deux règles pour que les images de référence restent comparables :
//
// 1. **taille de fenêtre figée** — un golden dépend du pixel près, il ne doit
//    pas dépendre de la machine ;
// 2. **une image par locale** — §3.9 impose anglais + français dès la v1, et
//    un golden qui ne couvrirait que l'anglais laisserait passer un
//    débordement de texte en français, où les libellés sont plus longs.
//
// Les vues testées ici sont des widgets purs : elles reçoivent de la sortie de
// pipeline figée, sans base ni bibliothèque native. Un golden qui aurait
// besoin du pont testerait le pont, pas le rendu.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odysseia/l10n/generated/app_localizations.dart';

/// Locales couvertes par les goldens (§3.9).
const List<Locale> goldenLocales = [Locale('en'), Locale('fr')];

/// Taille de rendu, figée pour que les images soient reproductibles.
const Size goldenSurface = Size(420, 820);

/// Monte [child] dans une app localisée et compare à l'image de référence.
///
/// Produit un fichier par locale : `<name>.en.png`, `<name>.fr.png`.
Future<void> expectGolden(
  WidgetTester tester,
  Widget child, {
  required String name,
  required Locale locale,
}) async {
  tester.view.physicalSize = goldenSurface;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      // La bannière « DEBUG » se retrouverait dans chaque image.
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: SafeArea(child: child)),
    ),
  );
  await tester.pumpAndSettle();

  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('images/$name.${locale.languageCode}.png'),
  );
}

/// Plateforme de référence des images (§3.10).
final bool _isReferencePlatform = Platform.isLinux;

/// Décrit un cas de golden pour les deux locales.
void goldenTest(
  String description,
  Widget Function() build, {
  required String name,
}) {
  for (final locale in goldenLocales) {
    testWidgets(
      '$description (${locale.languageCode})',
      (tester) async {
        await expectGolden(tester, build(), name: name, locale: locale);
      },
      // `testWidgets` ne prend qu'un booléen : la raison du saut est en
      // en-tête de ce fichier et dans `test/golden/README.md`.
      skip: !_isReferencePlatform,
    );
  }
}
