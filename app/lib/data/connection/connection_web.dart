// Ouverture web — §3.2 : `sqlite3.wasm` + IndexedDB.
//
// Pas encore branchée. Renvoyer `null` plutôt que de faire semblant : l'app
// démarre, les vues s'affichent vides, et rien ne prétend avoir persisté quoi
// que ce soit (§3.10 — jamais de crash, jamais de mensonge).
//
// À faire avec le build WASM du pont (§6.2) : les deux morceaux manquants de
// la cible web tiennent ensemble.

import 'package:drift/drift.dart';

/// Ouvre la base locale.
DatabaseConnection? openConnection() => null;
