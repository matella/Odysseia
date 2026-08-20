// Placeholder : garantit que `flutter test` a une cible.
// Les vrais tests (unitaires + golden, §3.10) arrivent avec les vues.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:odysseia/main.dart';

void main() {
  testWidgets('l\'app démarre', (tester) async {
    await tester.pumpWidget(const OdysseiaApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
