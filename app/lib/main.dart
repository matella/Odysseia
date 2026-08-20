// Point d'entrée de l'application Odysseia.
//
// Squelette : aucune fonctionnalité n'est encore branchée (§7).
//
// Rappel de contrainte (§6.1) : ce module — comme tout `app/` — ne contient
// **aucune** logique métier. Parsing, clustering, stats et génération de frames
// vivent dans `core/`. Le Dart orchestre l'UI, la base et le bridge.

import 'package:flutter/material.dart';

void main() => runApp(const OdysseiaApp());

/// Racine de l'application.
class OdysseiaApp extends StatelessWidget {
  /// Crée la racine de l'application.
  const OdysseiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(l10n): titre et textes à localiser en + fr dès la v1 (§3.9).
    return MaterialApp(
      title: 'Odysseia',
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(
        body: Center(child: Text('Odysseia')),
      ),
    );
  }
}
