// Point d'entrée de l'application Odysseia.
//
// Rappel de contrainte (§6.1) : ce module — comme tout `app/` — ne contient
// **aucune** logique métier. Parsing, clustering, stats et génération de
// frames vivent dans `core/`. Le Dart orchestre l'UI, la base et le pont.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bridge/generated/frb_generated.dart';
import 'data/connection/connection.dart';
import 'data/database.dart';
import 'data/timeline_repository.dart';
import 'features/stats/stats_view.dart';
import 'features/story/story_view.dart';
import 'features/video/video_view.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = await _initialise();
  runApp(OdysseiaApp(repository: repository));
}

/// Prépare le pont et la base, ou renonce proprement.
///
/// En web, ni le pont (build WASM, §6.2) ni la base (`sqlite3.wasm`, §3.2) ne
/// sont branchés. L'app démarre quand même et affiche des vues vides : §3.10
/// interdit le crash visible, et une plateforme dégradée se **signale**, elle
/// ne se déguise pas (§2).
Future<TimelineRepository?> _initialise() async {
  final connection = openConnection();
  if (connection == null) return null;

  try {
    await RustLib.init();
  } on Object {
    return null;
  }

  return TimelineRepository(OdysseiaDatabase(connection));
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
    // Sans dépôt — tests de widgets, plateforme web, ou app pas encore
    // initialisée — les vues s'affichent vides plutôt que de planter (§3.10).
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
