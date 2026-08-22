// Vue Stats & patterns (§3.4) — rendu pur.
//
// Les six statistiques sont calculées en Rust, sur la sortie du pipeline
// (§5.4) : rien n'est agrégé ici (§6.1), et aucun total ne peut inclure une
// donnée écartée par une zone privée (§3.7).

import 'package:flutter/material.dart';

import '../../bridge/generated/api/timeline.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/display.dart';

/// Statistiques vides — état initial, avant tout import (§3.10 : une vue
/// sans données s'affiche, elle ne plante pas).
StatsOutput emptyStats() => StatsOutput(
  density: const [],
  places: const [],
  modes: const [],
  hours: const [],
  weekdays: const [],
  totalDistanceM: 0,
  visitCount: 0,
  segmentCount: 0,
);

/// Vue Stats (§3.4).
class StatsView extends StatelessWidget {
  /// Crée la vue.
  const StatsView({
    super.key,
    required this.stats,
    this.activeModes = const [],
    this.onModeToggled,
    this.onClearFilters,
  });

  /// Statistiques déjà calculées par le cœur.
  final StatsOutput stats;

  /// Modes retenus par le filtre courant ; vide = tous (§3.4).
  final List<TravelMode> activeModes;

  /// Bascule d'un mode dans le filtre.
  final ValueChanged<TravelMode>? onModeToggled;

  /// Remise à zéro des filtres.
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final empty = stats.visitCount == 0 && stats.segmentCount == 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.statsTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        _ModeFilter(
          active: activeModes,
          onToggled: onModeToggled,
          onClear: onClearFilters,
        ),
        const SizedBox(height: 16),
        if (empty)
          _EmptyCard(message: l10n.statsEmpty)
        else ...[
          _Totals(stats: stats),
          const SizedBox(height: 16),
          _Section(
            title: l10n.statsTopPlaces,
            child: _BucketList(
              buckets: stats.places,
              valueOf: (bucket) => '${bucket.count}',
            ),
          ),
          _Section(
            title: l10n.statsTimePerPlace,
            child: _BucketList(
              buckets: stats.places,
              valueOf: (bucket) => formatDuration(bucket.durationMs.toInt()),
            ),
          ),
          _Section(
            title: l10n.statsModeBreakdown,
            child: _BucketList(
              buckets: stats.modes,
              labelOf: (bucket) => modeLabelFromKey(l10n, bucket.key),
              valueOf: (bucket) => formatDistance(bucket.distanceM),
            ),
          ),
          _Section(
            title: l10n.statsHourly,
            child: _BarRow(
              buckets: stats.hours,
              labelOf: (bucket) => bucket.key,
            ),
          ),
          _Section(
            title: l10n.statsWeekday,
            child: _BarRow(
              buckets: stats.weekdays,
              labelOf: (bucket) => weekdayLabel(l10n, bucket.key),
            ),
          ),
          _Section(
            title: l10n.statsDensity,
            child: _DensitySummary(cells: stats.density),
          ),
        ],
      ],
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.stats});

  final StatsOutput stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _Metric(
            label: l10n.statsTotalDistance,
            value: formatDistance(stats.totalDistanceM),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Metric(
            label: l10n.navStory,
            value: l10n.statsVisitCount(stats.visitCount),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Metric(
            label: l10n.filtersMode,
            value: l10n.statsSegmentCount(stats.segmentCount),
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _ModeFilter extends StatelessWidget {
  const _ModeFilter({required this.active, this.onToggled, this.onClear});

  final List<TravelMode> active;
  final ValueChanged<TravelMode>? onToggled;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const offered = [
      TravelMode.walking,
      TravelMode.cycling,
      TravelMode.inVehicle,
      TravelMode.inTrain,
      TravelMode.flight,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(l10n.filtersMode, style: Theme.of(context).textTheme.labelMedium),
        for (final mode in offered)
          FilterChip(
            label: Text(modeLabel(l10n, mode)),
            selected: active.contains(mode),
            onSelected: onToggled == null ? null : (_) => onToggled!(mode),
          ),
        if (active.isNotEmpty)
          TextButton(onPressed: onClear, child: Text(l10n.filtersClear)),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _BucketList extends StatelessWidget {
  const _BucketList({
    required this.buckets,
    required this.valueOf,
    this.labelOf,
  });

  final List<BucketOutput> buckets;
  final String Function(BucketOutput) valueOf;
  final String Function(BucketOutput)? labelOf;

  /// Nombre d'entrées affichées : un classement se lit, il ne se déroule pas.
  static const int _max = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shown = buckets.take(_max).toList();
    if (shown.isEmpty) return _EmptyCard(message: l10n.statsEmpty);

    return Column(
      children: [
        for (final bucket in shown)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    labelOf?.call(bucket) ??
                        (bucket.key.isEmpty ? l10n.storyUnnamedPlace : bucket.key),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(valueOf(bucket), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
      ],
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({required this.buckets, required this.labelOf});

  final List<BucketOutput> buckets;
  final String Function(BucketOutput) labelOf;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (buckets.isEmpty) return _EmptyCard(message: l10n.statsEmpty);

    final peak = buckets.map((b) => b.count).reduce((a, b) => a > b ? a : b);
    final theme = Theme.of(context);

    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final bucket in buckets)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: peak == 0 ? 0 : 64 * bucket.count / peak,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(labelOf(bucket), style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DensitySummary extends StatelessWidget {
  const _DensitySummary({required this.cells});

  final List<HeatCellOutput> cells;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (cells.isEmpty) return _EmptyCard(message: l10n.statsEmpty);

    // La carte elle-même viendra avec le widget carte partagé (§6) : les
    // tuiles OSM demandent un consentement explicite (§2), qu'une vue de
    // statistiques ne doit pas déclencher toute seule.
    final peak = cells.map((c) => c.count).reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${cells.length}', style: Theme.of(context).textTheme.titleMedium),
        Text(
          '${l10n.statsDensity} · $peak',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: theme.textTheme.bodyMedium),
    );
  }
}
