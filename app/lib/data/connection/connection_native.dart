// Ouverture native (Android, iOS, desktop) — §3.2.

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Ouvre la base locale.
///
/// TODO(import): base en mémoire tant que l'import n'existe pas (§7, étape 2)
/// — il n'y a encore rien à persister. Le passage à un fichier local se fera
/// avec l'écran d'import, qui doit aussi archiver le Timeline.json source
/// (§3.2).
DatabaseConnection? openConnection() =>
    DatabaseConnection(NativeDatabase.memory());
