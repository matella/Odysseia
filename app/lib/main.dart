// Point d'entrée de l'application Odysseia.
//
// Rappel de contrainte (§6.1) : ce module — comme tout `app/` — ne contient
// **aucune** logique métier. Parsing, clustering, stats et génération de
// frames vivent dans `core/`. Le Dart orchestre l'UI, la base et le pont.

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bridge/generated/frb_generated.dart';
import 'data/database.dart';
import 'data/timeline_repository.dart';
import 'features/stats/stats_view.dart';
import 'features/story/story_view.dart';
import 'features/video/video_view.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();

  // TODO(import): base en mémoire tant que l'import (§3.3 de docs/specs.md,
  // étape 2 de §7) n'existe pas — il n'y a encore rien à persister. Le passage
  // à un fichier local se fera avec l'écran d'import, qui doit aussi archiver
  // le Timeline.json source (§3.2).
  final database = OdysseiaDatabase(
    DatabaseConnection(NativeDatabase.memory()),
  );

  runApp(OdysseiaApp(repository: TimelineRepository(database)));
}

/// Racine de l'application.
class OdysseiaApp extends StatelessWidget {
  /// Crée la racine.
  ///
  /// [repository] est optionnel pour que les tests de widgets puissent monter
  /// l'app sans base ni bibliothèque native.
  const OdysseiaApp({super.key, this.repository});

  /// Accès aux données, via le pipeline §5.4 et lui seul.
  final TimelineRepository? repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: true),
      home: HomeShell(repository: repository),
    );
  }
}

/// Coquille de navigation entre les trois vues (§3.3–3.5).
class HomeShell extends StatefulWidget {
  /// Crée la coquille.
  const HomeShell({super.key, this.repository});

  /// Accès aux données.
  final TimelineRepository? repository;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  StoryGranularity _granularity = StoryGranularity.day;
  VideoSettings _videoSettings = const VideoSettings();

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
        ],
      ),
    );
  }

  Widget _body() {
    // Sans dépôt — tests de widgets, ou app pas encore initialisée — les vues
    // s'affichent vides plutôt que de planter (§3.10).
    return switch (_tab) {
      0 => StoryView(
        visits: const [],
        segments: const [],
        granularity: _granularity,
        periodLabel: '',
        onGranularityChanged: (value) => setState(() => _granularity = value),
      ),
      1 => StatsView(stats: emptyStats()),
      _ => VideoView(
        settings: _videoSettings,
        plan: null,
        isWeb: kIsWeb,
        onSettingsChanged: (value) => setState(() => _videoSettings = value),
      ),
    };
  }
}
