// Configuration commune à tous les tests (chargée automatiquement par
// `flutter test`).
//
// # Pourquoi une comparaison tolérante
//
// Les images de référence (§3.10) sont produites et comparées sous Linux, en
// CI — voir `test/golden/golden_harness.dart`. L'écart entre systèmes est donc
// hors sujet ici ; ce qui reste, c'est la dérive d'une version de moteur
// Flutter à l'autre. Une comparaison au pixel près échouerait sur des écarts
// invisibles, et l'équipe prendrait vite l'habitude de régénérer les goldens
// sans les regarder — ce qui les viderait de leur sens.
//
// Le seuil est délibérément **bas** : il absorbe le bruit d'anticrénelage,
// pas un décalage de mise en page. Un texte qui déborde, un widget qui
// disparaît ou une traduction manquante changent bien plus que 0,5 % des
// pixels et font toujours échouer le test.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Proportion de pixels différents tolérée avant échec.
const double _goldenTolerance = 0.005;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final defaultComparator = goldenFileComparator as LocalFileComparator;
  goldenFileComparator = _TolerantComparator(
    defaultComparator.basedir.resolve('flutter_test_config.dart'),
  );
  await testMain();
}

class _TolerantComparator extends LocalFileComparator {
  _TolerantComparator(super.testFile);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (result.passed || result.diffPercent <= _goldenTolerance) {
      // Un écart sous le seuil reste digne d'être signalé : c'est souvent le
      // premier signe qu'une version de moteur a bougé.
      if (!result.passed) {
        debugPrint(
          'Golden $golden : écart de ${result.diffPercent * 100}% toléré.',
        );
      }
      return true;
    }

    throw FlutterError(await generateFailureOutput(result, golden, basedir));
  }
}
