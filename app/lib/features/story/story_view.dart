// Vue Récit (§3.3) — rendu pur.
//
// Ne reçoit que de la sortie de pipeline (§5.4) : ce qui est absent de
// `visits`/`segments` a déjà été écarté par les zones privées, et ne peut donc
// pas réapparaître ici par accident (§3.7).
//
// Séparée de `StoryPage` exprès : une vue sans dépôt ni pont se teste en
// golden avec des données figées (§3.10).

import 'package:flutter/material.dart';

import '../../bridge/generated/api/timeline.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/display.dart';

/// Granularité de navigation (§3.3).
enum StoryGranularity {
  /// Jour.
  day,

  /// Semaine.
  week,

  /// Mois.
  month,

  /// Année.
  year,
}

/// Une entrée du récit : un arrêt ou un trajet, replacés dans l'ordre.
class _Entry implements Comparable<_Entry> {
  _Entry.visit(this.visit) : segment = null, at = visit!.arrivalTsUtc;
  _Entry.segment(this.segment) : visit = null, at = segment!.startTsUtc;

  final ResolvedVisitOutput? visit;
  final ResolvedSegmentOutput? segment;
  final int at;

  @override
  int compareTo(_Entry other) => at.compareTo(other.at);
}

/// Vue Récit (§3.3).
class StoryView extends StatelessWidget {
  /// Crée la vue.
  const StoryView({
    super.key,
    required this.visits,
    required this.segments,
    required this.granularity,
    required this.periodLabel,
    this.onGranularityChanged,
    this.privateZonesActive = false,
  });

  /// Arrêts retenus par le pipeline.
  final List<ResolvedVisitOutput> visits;

  /// Trajets retenus par le pipeline.
  final List<ResolvedSegmentOutput> segments;

  /// Granularité courante.
  final StoryGranularity granularity;

  /// Libellé de la période affichée, déjà formaté par l'appelant.
  final String periodLabel;

  /// Changement de granularité.
  final ValueChanged<StoryGranularity>? onGranularityChanged;

  /// L'utilisateur a-t-il des zones privées actives ? (§3.7)
  final bool privateZonesActive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = <_Entry>[
      for (final visit in visits) _Entry.visit(visit),
      for (final segment in segments) _Entry.segment(segment),
    ]..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          granularity: granularity,
          periodLabel: periodLabel,
          onGranularityChanged: onGranularityChanged,
        ),
        if (privateZonesActive) _PrivateZoneNotice(message: l10n.privateZoneHidden),
        Expanded(
          child: entries.isEmpty
              ? _Empty(title: l10n.storyEmpty, hint: l10n.storyEmptyHint)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return entry.visit != null
                        ? _VisitTile(visit: entry.visit!)
                        : _SegmentTile(segment: entry.segment!);
                  },
                ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.granularity,
    required this.periodLabel,
    required this.onGranularityChanged,
  });

  final StoryGranularity granularity;
  final String periodLabel;
  final ValueChanged<StoryGranularity>? onGranularityChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = {
      StoryGranularity.day: l10n.granularityDay,
      StoryGranularity.week: l10n.granularityWeek,
      StoryGranularity.month: l10n.granularityMonth,
      StoryGranularity.year: l10n.granularityYear,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(periodLabel, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          // Défilement horizontal : les libellés français sont plus longs
          // que les anglais et faisaient passer « Semaine » sur deux lignes
          // (§3.9 — vu grâce au golden `fr`).
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<StoryGranularity>(
              segments: [
                for (final entry in labels.entries)
                  ButtonSegment(value: entry.key, label: Text(entry.value)),
              ],
              selected: {granularity},
              showSelectedIcon: false,
              onSelectionChanged: onGranularityChanged == null
                  ? null
                  : (selection) => onGranularityChanged!(selection.first),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivateZoneNotice extends StatelessWidget {
  const _PrivateZoneNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _VisitTile extends StatelessWidget {
  const _VisitTile({required this.visit});

  final ResolvedVisitOutput visit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final duration = visit.departureTsUtc - visit.arrivalTsUtc;

    return _Tile(
      icon: Icons.place_outlined,
      time: localTimeOfDay(visit.arrivalTsUtc, visit.arrivalTzOffsetMinutes),
      title: l10n.storyVisitAt(placeLabelOr(l10n, visit.placeLabel)),
      details: [
        formatDuration(duration),
        // Intégrations optionnelles désactivées par défaut (§2) : on le dit
        // plutôt que d'afficher un blanc inexpliqué.
        l10n.storyWeatherUnavailable,
        l10n.storyPhotosUnavailable,
      ],
    );
  }
}

class _SegmentTile extends StatelessWidget {
  const _SegmentTile({required this.segment});

  final ResolvedSegmentOutput segment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final duration = segment.endTsUtc - segment.startTsUtc;

    return _Tile(
      icon: Icons.trending_flat,
      time: localTimeOfDay(segment.startTsUtc, segment.startTzOffsetMinutes),
      title: l10n.storyTripFromTo(
        placeLabelOr(l10n, segment.startPlaceLabel),
        placeLabelOr(l10n, segment.endPlaceLabel),
      ),
      details: [
        modeLabel(l10n, segment.mode),
        formatDuration(duration),
        if (segment.distanceM != null) formatDistance(segment.distanceM!),
      ],
      // §5.2 : la correction de l'utilisateur est visible, la détection
      // d'origine n'est pas écrasée pour autant.
      badge: segment.corrected ? l10n.storyCorrectedBadge : null,
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.time,
    required this.title,
    required this.details,
    this.badge,
  });

  final IconData icon;
  final String time;
  final String title;
  final List<String> details;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 4),
              Text(time, style: theme.textTheme.labelSmall),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title, style: theme.textTheme.titleSmall),
                    ),
                    if (badge != null) _Badge(text: badge!),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final detail in details)
                      Text(detail, style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: theme.textTheme.labelSmall),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timeline, size: 40),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(hint, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
