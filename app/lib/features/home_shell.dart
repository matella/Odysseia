// Navigation entre les trois vues, et chargement de leurs données.
//
// C'est le seul endroit qui appelle `TimelineRepository`, lequel est le seul à
// parler à la base et au pipeline (§5.4). Les vues elles-mêmes ne reçoivent
// que des données déjà filtrées — elles ne savent même pas qu'une base existe.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart'
    show Int64List;

import '../bridge/generated/api/timeline.dart';
import '../data/import_service.dart';
import '../data/timeline_repository.dart';
import '../l10n/generated/app_localizations.dart';
import '../shared/period.dart';
import 'import/import_view.dart';
import 'settings/settings_view.dart';
import 'stats/stats_view.dart';
import 'story/story_view.dart';
import 'video/video_view.dart';

/// Coquille de navigation entre les trois vues (§3.3–3.5).
class HomeShell extends StatefulWidget {
  /// Crée la coquille.
  const HomeShell({
    super.key,
    this.repository,
    this.importService,
    this.pickPath,
    this.now,
  });

  /// Accès aux données, via le pipeline §5.4 et lui seul.
  final TimelineRepository? repository;

  /// Import d'un export Timeline (§3.3).
  final ImportService? importService;

  /// Sélection du fichier à importer.
  ///
  /// Injectée plutôt que codée en dur : aucun sélecteur de fichier n'est
  /// branché pour l'instant, et les tests fournissent un chemin de fixture.
  /// Quand un sélecteur arrivera, c'est la seule ligne à changer.
  final Future<String?> Function()? pickPath;

  /// Date de référence, injectable pour les tests.
  final DateTime? now;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  late ViewPeriod _period;
  VideoSettings _videoSettings = const VideoSettings();
  List<TravelMode> _modes = const [];
  ImportState _import = const ImportIdle();
  IntegrationSwitches _integrations = const IntegrationSwitches();

  Future<PipelineResponse>? _story;
  Future<StatsOutput>? _stats;
  Future<VideoPlanResult>? _plan;

  @override
  void initState() {
    super.initState();
    _period = ViewPeriod(
      anchor: widget.now ?? DateTime.now(),
      granularity: StoryGranularity.day,
    );
    _reload();
  }

  /// Relance les requêtes de la vue courante.
  ///
  /// Chaque appel repart du pipeline : un lieu renommé ou une zone privée
  /// ajoutée se répercute partout sans code supplémentaire (§5.4).
  void _reload() {
    final repository = widget.repository;
    if (repository == null) return;

    final filters = FiltersInput(modes: _modes);
    setState(() {
      _story = repository.story(_period.bounds, filters: filters);
      _stats = repository.stats(_period.bounds, filters: filters);
      _plan = repository.videoPlan(
        _period.bounds,
        VideoParams(
          durationS: _videoSettings.durationS,
          periodStartUtc: _period.bounds.startUtc,
          periodEndUtc: _period.bounds.endUtc,
          style: _videoSettings.style,
          title: _videoSettings.title,
        ),
        filters: filters,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(child: _body()),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.timeline),
            label: l10n.navStory,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights),
            label: l10n.navStats,
          ),
          NavigationDestination(
            icon: const Icon(Icons.movie_outlined),
            label: l10n.navVideo,
          ),
          NavigationDestination(
            icon: const Icon(Icons.file_download_outlined),
            label: l10n.importTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: l10n.settingsTitle,
          ),
        ],
      ),
    );
  }

  Widget _body() => switch (_tab) {
    0 => _storyTab(),
    1 => _statsTab(),
    2 => _videoTab(),
    3 => _importTab(),
    _ => _settingsTab(),
  };

  Widget _importTab() => ImportView(
    state: _import,
    // Sans sélecteur, le dire plutôt que d'afficher un bouton qui ne ferait
    // rien (§3.10).
    pickerAvailable: widget.pickPath != null && widget.importService != null,
    onChooseFile: _startImport,
  );

  /// Lance un import et suit sa progression (§4).
  Future<void> _startImport() async {
    final service = widget.importService;
    final pick = widget.pickPath;
    if (service == null || pick == null) return;

    final path = await pick();
    if (path == null) return;

    await for (final state in service.import(path)) {
      if (!mounted) return;
      setState(() => _import = state);
    }
    // Les vues repartent du pipeline sur les nouvelles données (§5.4).
    _reload();
  }

  Widget _settingsTab() => SettingsView(
    capabilities: _capabilities(context),
    integrations: _integrations,
    onIntegrationsChanged: (value) => setState(() => _integrations = value),
    onDelete: widget.repository == null ? null : () => _confirmDelete(context),
  );

  /// État réel des capacités sur cette plateforme (§2).
  ///
  /// Ce qui manque est **affiché**, pas masqué : c'est la règle de §2 sur les
  /// fonctionnalités dégradées.
  List<Capability> _capabilities(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      Capability(
        label: l10n.capabilityDatabase,
        status: widget.repository == null
            ? CapabilityStatus.unavailable
            : CapabilityStatus.available,
      ),
      Capability(
        label: l10n.capabilityBridge,
        status: widget.repository == null
            ? CapabilityStatus.unavailable
            : CapabilityStatus.available,
      ),
      Capability(
        label: l10n.capabilityVideoExport,
        status: CapabilityStatus.notWired,
      ),
    ];
  }

  Future<void> _confirmDelete(BuildContext context) async {
    if (!await confirmDeleteEverything(context)) return;
    await widget.repository?.deleteAllUserData();
    if (!context.mounted) return;
    _reload();
  }

  String get _locale => Localizations.localeOf(context).toLanguageTag();

  Widget _storyTab() {
    return _Loader<PipelineResponse>(
      future: _story,
      // Sans dépôt — tests de widgets, plateforme web — la vue s'affiche vide
      // plutôt que de planter (§3.10).
      empty: PipelineResponse(
        points: const [],
        visits: const [],
        segments: const [],
        orphanOverrideIds: Int64List(0),
      ),
      builder: (response) => StoryView(
        visits: response.visits,
        segments: response.segments,
        granularity: _period.granularity,
        periodLabel: _period.label(_locale),
        onGranularityChanged: (value) {
          _period = _period.withGranularity(value);
          _reload();
        },
        onPrevious: () {
          _period = _period.previous;
          _reload();
        },
        onNext: () {
          _period = _period.next;
          _reload();
        },
      ),
    );
  }

  Widget _statsTab() {
    return _Loader<StatsOutput>(
      future: _stats,
      empty: emptyStats(),
      builder: (stats) => StatsView(
        stats: stats,
        activeModes: _modes,
        onModeToggled: (mode) {
          _modes = _modes.contains(mode)
              ? [for (final m in _modes) if (m != mode) m]
              : [..._modes, mode];
          _reload();
        },
        onClearFilters: () {
          _modes = const [];
          _reload();
        },
      ),
    );
  }

  Widget _videoTab() {
    return _Loader<VideoPlanResult?>(
      future: _plan,
      empty: null,
      builder: (plan) => VideoView(
        settings: _videoSettings,
        plan: plan,
        periodLabel: _period.label(_locale),
        isWeb: kIsWeb,
        onSettingsChanged: (value) {
          _videoSettings = value;
          _reload();
        },
        onRender: _reload,
      ),
    );
  }
}

/// Affiche `builder(données)`, ou `builder(empty)` tant qu'il n'y a rien.
///
/// Volontairement sans indicateur de chargement bloquant : les vues savent
/// afficher un état vide, et un écran qui clignote à chaque changement de
/// filtre serait pire que l'attente (§3.10).
class _Loader<T> extends StatelessWidget {
  const _Loader({
    required this.future,
    required this.empty,
    required this.builder,
  });

  final Future<T>? future;
  final T empty;
  final Widget Function(T) builder;

  @override
  Widget build(BuildContext context) {
    if (future == null) return builder(empty);
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) =>
          builder(snapshot.hasData ? snapshot.data as T : empty),
    );
  }
}
