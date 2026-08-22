// Chargement de la bibliothèque native pour les tests Dart.
//
// En production, cargokit compile `bridge/` pour chaque plateforme et
// l'embarque dans l'app ; `RustLib.init()` la trouve toute seule. Sous
// `flutter test`, rien n'est empaqueté : il faut désigner le binaire produit
// par `cargo build` dans `bridge/`.
//
//     cd bridge && cargo build
//
// Sans cette étape, les tests du pont échouent avec une erreur de chargement —
// délibérément, plutôt que d'être silencieusement sautés (§3.10).

import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:odysseia/bridge/generated/frb_generated.dart';

/// Nom du binaire selon la plateforme hôte.
String get _libraryFileName {
  if (Platform.isWindows) return 'odysseia_bridge.dll';
  if (Platform.isMacOS) return 'libodysseia_bridge.dylib';
  return 'libodysseia_bridge.so';
}

/// Emplacements plausibles, du plus probable au moins.
Iterable<String> get _candidatePaths sync* {
  const roots = ['../bridge/target/debug', '../bridge/target/release'];
  for (final root in roots) {
    yield '$root/$_libraryFileName';
  }
}

bool _initialised = false;

/// Initialise le pont une fois pour toute la suite de tests.
Future<void> initRustForTests() async {
  if (_initialised) return;
  _initialised = true;

  final path = _candidatePaths.firstWhere(
    (candidate) => File(candidate).existsSync(),
    orElse: () => throw StateError(
      'Bibliothèque native introuvable. Lancez `cargo build` dans `bridge/` '
      'avant `flutter test`. Cherché : ${_candidatePaths.join(', ')}',
    ),
  );

  await RustLib.init(externalLibrary: ExternalLibrary.open(path));
}
