// Fenêtre temporelle affichée par une vue (§3.3).
//
// # Pourquoi c'est ici et non dans `core/`
//
// CLAUDE.md range les règles de découpage temporel dans `core/` — à raison :
// regrouper des données par jour ou par semaine est une règle métier. Ce
// fichier ne fait pas cela. Il calcule **quelle fenêtre l'utilisateur
// regarde** quand il appuie sur « semaine suivante », puis la passe au
// pipeline, qui reste seul à filtrer (§5.4).
//
// Autrement dit : la navigation est de l'UI, le filtrage est du cœur.

import 'package:intl/intl.dart';

import '../data/timeline_repository.dart';
import '../features/story/story_view.dart';

/// Fenêtre affichée, et de quoi se déplacer dedans.
class ViewPeriod {
  /// Crée une fenêtre autour de [anchor], à la granularité donnée.
  const ViewPeriod({required this.anchor, required this.granularity});

  /// Date de référence, dans le fuseau de l'appareil.
  final DateTime anchor;

  /// Granularité de navigation (§3.3).
  final StoryGranularity granularity;

  /// Premier instant de la fenêtre, en millisecondes UTC.
  DateTime get start => switch (granularity) {
    StoryGranularity.day => DateTime(anchor.year, anchor.month, anchor.day),
    StoryGranularity.week => DateTime(
      anchor.year,
      anchor.month,
      anchor.day,
    ).subtract(Duration(days: anchor.weekday - 1)),
    StoryGranularity.month => DateTime(anchor.year, anchor.month),
    StoryGranularity.year => DateTime(anchor.year),
  };

  /// Dernier instant de la fenêtre, exclu.
  DateTime get end => switch (granularity) {
    StoryGranularity.day => start.add(const Duration(days: 1)),
    StoryGranularity.week => start.add(const Duration(days: 7)),
    StoryGranularity.month => DateTime(start.year, start.month + 1),
    StoryGranularity.year => DateTime(start.year + 1),
  };

  /// Fenêtre au format attendu par le dépôt.
  Period get bounds => Period(
    startUtc: start.toUtc().millisecondsSinceEpoch,
    endUtc: end.toUtc().millisecondsSinceEpoch - 1,
  );

  /// Fenêtre précédente.
  ViewPeriod get previous => ViewPeriod(
    anchor: switch (granularity) {
      StoryGranularity.day => anchor.subtract(const Duration(days: 1)),
      StoryGranularity.week => anchor.subtract(const Duration(days: 7)),
      StoryGranularity.month => DateTime(anchor.year, anchor.month - 1, 1),
      StoryGranularity.year => DateTime(anchor.year - 1, 1, 1),
    },
    granularity: granularity,
  );

  /// Fenêtre suivante.
  ViewPeriod get next => ViewPeriod(
    anchor: switch (granularity) {
      StoryGranularity.day => anchor.add(const Duration(days: 1)),
      StoryGranularity.week => anchor.add(const Duration(days: 7)),
      StoryGranularity.month => DateTime(anchor.year, anchor.month + 1, 1),
      StoryGranularity.year => DateTime(anchor.year + 1, 1, 1),
    },
    granularity: granularity,
  );

  /// Même fenêtre, à une autre granularité.
  ViewPeriod withGranularity(StoryGranularity value) =>
      ViewPeriod(anchor: anchor, granularity: value);

  /// Libellé affichable, dans la langue de l'utilisateur (§3.9).
  String label(String locale) {
    final start = this.start;
    return switch (granularity) {
      StoryGranularity.day => DateFormat.yMMMMd(locale).format(start),
      StoryGranularity.week =>
        '${DateFormat.MMMd(locale).format(start)} – '
            '${DateFormat.yMMMd(locale).format(end.subtract(const Duration(days: 1)))}',
      StoryGranularity.month => DateFormat.yMMMM(locale).format(start),
      StoryGranularity.year => DateFormat.y(locale).format(start),
    };
  }
}
