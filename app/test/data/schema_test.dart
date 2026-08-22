// Contraintes **structurelles** du schéma §5.
//
// Les tests de `reimport_test.dart` vérifient un comportement ; ceux-ci
// vérifient une propriété du schéma lui-même, qu'aucune relecture de code ne
// garantit durablement : la zone utilisateur (§5.2) ne peut pas dépendre de la
// zone importée (§5.1).
//
// Si quelqu'un ajoute un jour une clé étrangère de `user_place` vers `visit`
// — ce qui paraîtra pratique sur le moment — ces tests échouent, et c'est tout
// leur intérêt.

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

  Set<String> names(List<TableInfo<Table, dynamic>> tables) =>
      tables.map((t) => t.actualTableName).toSet();

  test('les trois zones sont disjointes et couvrent tout le schéma', () {
    final imported = names(db.importedZoneTables);
    final user = names(db.userZoneTables);
    final reference = names(db.referenceTables);

    expect(imported.intersection(user), isEmpty);
    expect(imported.intersection(reference), isEmpty);
    expect(user.intersection(reference), isEmpty);

    // Toute table nouvelle doit être classée dans une zone : sans cela, elle
    // échapperait aux règles de ré-import sans que personne s'en aperçoive.
    expect(
      names(db.allTables.toList()),
      {...imported, ...user, ...reference},
      reason: 'une table non classée échappe aux règles de §5.1 / §5.2',
    );
  });

  test('aucune table de §5.2 ne référence la zone importée §5.1', () async {
    // La règle de §5.2, lue directement dans SQLite plutôt que dans le code
    // Dart : les identifiants de §5.1 changent à chaque import, une clé
    // étrangère vers eux casserait à chaque mise à jour de l'export.
    final imported = names(db.importedZoneTables);

    for (final table in db.userZoneTables) {
      final rows = await db
          .customSelect('pragma foreign_key_list(${table.actualTableName});')
          .get();
      final referenced = rows.map((r) => r.read<String>('table')).toSet();

      expect(
        referenced.intersection(imported),
        isEmpty,
        reason:
            '${table.actualTableName} référence la zone importée : le lien '
            'casserait au premier ré-import (§5.2)',
      );
    }
  });

  test('la zone utilisateur ne référence rien du tout', () async {
    // Formulation plus forte, tant qu'elle tient : le rattachement est
    // géographique ou par empreinte (§4), donc aucune clé étrangère n'est
    // nécessaire nulle part dans §5.2.
    for (final table in db.userZoneTables) {
      final rows = await db
          .customSelect('pragma foreign_key_list(${table.actualTableName});')
          .get();
      expect(rows, isEmpty, reason: table.actualTableName);
    }
  });

  test('la zone importée est rattachée à son lot, en cascade', () async {
    // Réciproque : à l'intérieur de §5.1, les liens sont non seulement permis
    // mais souhaitables — c'est ce qui rend le remplacement atomique.
    final tables = <TableInfo<Table, dynamic>>[
      db.rawPoints,
      db.segments,
      db.visits,
    ];
    for (final table in tables) {
      final rows = await db
          .customSelect('pragma foreign_key_list(${table.actualTableName});')
          .get();
      final toBatch = rows.where(
        (r) => r.read<String>('table') == db.importBatches.actualTableName,
      );
      expect(toBatch, hasLength(1), reason: table.actualTableName);
      expect(toBatch.single.read<String>('on_delete'), 'CASCADE');
    }
  });

  test('les clés étrangères sont réellement activées', () async {
    // Déclarer `ON DELETE CASCADE` ne sert à rien si SQLite ignore les clés
    // étrangères, ce qu'il fait par défaut.
    final row = await db.customSelect('pragma foreign_keys;').getSingle();
    expect(row.read<int>('foreign_keys'), 1);
  });

  test('les index de volume attendus existent', () async {
    // §5.5 : `raw_point` peut atteindre 5 millions de lignes ; sans index
    // temporel et spatial, la navigation (§3.3) et la heatmap (§3.4) rampent.
    final rows = await db
        .customSelect(
          "select name from sqlite_master where type = 'index';",
        )
        .get();
    final indexes = rows.map((r) => r.read<String>('name')).toSet();

    expect(indexes, containsAll(['raw_point_time', 'raw_point_space']));
    expect(indexes, containsAll(['segment_time', 'visit_time', 'visit_space']));
    expect(indexes, contains('user_place_space'));
    expect(indexes, contains('override_fingerprint'));
  });
}
