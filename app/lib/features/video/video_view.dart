// Vue Vidéo souvenir (§3.5) — rendu pur.
//
// Personnalisation complète dès la v1 (§3.5) : durée, période, style visuel,
// template de titre. Le plan de frames est calculé en Rust
// (`core/src/render/`) sur la sortie du pipeline, donc les zones privées sont
// absentes des images elles-mêmes (§3.7).
//
// ⚠️ L'encodage MP4 n'est pas branché : ni ffmpeg natif, ni `ffmpeg.wasm`. La
// vue le dit explicitement plutôt que de proposer un bouton qui ne produirait
// rien (§3.10).

import 'package:flutter/material.dart';

import '../../bridge/generated/api/timeline.dart';
import '../../l10n/generated/app_localizations.dart';

/// Durées proposées, en secondes (§3.5).
const List<int> videoDurations = [15, 30, 45, 60, 75, 90];

/// Réglages choisis par l'utilisateur.
class VideoSettings {
  /// Crée un jeu de réglages.
  const VideoSettings({
    this.durationS = 30,
    this.style = VideoStyle.classic,
    this.title = '',
  });

  /// Durée retenue.
  final int durationS;

  /// Style visuel retenu.
  final VideoStyle style;

  /// Titre saisi.
  final String title;

  /// Copie modifiée.
  VideoSettings copyWith({int? durationS, VideoStyle? style, String? title}) =>
      VideoSettings(
        durationS: durationS ?? this.durationS,
        style: style ?? this.style,
        title: title ?? this.title,
      );
}

/// Vue Vidéo (§3.5).
class VideoView extends StatelessWidget {
  /// Crée la vue.
  const VideoView({
    super.key,
    required this.settings,
    required this.plan,
    this.periodLabel = '',
    this.isWeb = false,
    this.onSettingsChanged,
    this.onRender,
  });

  /// Réglages courants.
  final VideoSettings settings;

  /// Plan de frames renvoyé par le cœur, ou `null` tant qu'il n'a pas été
  /// calculé.
  final VideoPlanResult? plan;

  /// Libellé de la plage couverte, formaté par l'appelant.
  final String periodLabel;

  /// Rendu web : l'UI doit prévenir que ce sera plus lent (§3.5).
  final bool isWeb;

  /// Changement de réglages.
  final ValueChanged<VideoSettings>? onSettingsChanged;

  /// Demande de génération.
  final VoidCallback? onRender;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.videoTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),

        _Field(
          label: l10n.videoDuration,
          child: Wrap(
            spacing: 8,
            children: [
              for (final seconds in videoDurations)
                ChoiceChip(
                  label: Text(l10n.videoDurationSeconds(seconds)),
                  selected: settings.durationS == seconds,
                  onSelected: onSettingsChanged == null
                      ? null
                      : (_) => onSettingsChanged!(
                          settings.copyWith(durationS: seconds),
                        ),
                ),
            ],
          ),
        ),

        _Field(
          label: l10n.videoStyle,
          child: Wrap(
            spacing: 8,
            children: [
              for (final style in VideoStyle.values)
                ChoiceChip(
                  label: Text(_styleLabel(l10n, style)),
                  selected: settings.style == style,
                  onSelected: onSettingsChanged == null
                      ? null
                      : (_) => onSettingsChanged!(settings.copyWith(style: style)),
                ),
            ],
          ),
        ),

        _Field(
          label: l10n.videoPeriod,
          child: Text(periodLabel, style: theme.textTheme.bodyMedium),
        ),

        _Field(
          label: l10n.videoTitleTemplate,
          child: TextField(
            controller: TextEditingController(text: settings.title),
            decoration: InputDecoration(
              hintText: l10n.videoTitleTemplateHint('2024'),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: onSettingsChanged == null
                ? null
                : (value) => onSettingsChanged!(settings.copyWith(title: value)),
          ),
        ),

        if (isWeb) _Notice(icon: Icons.hourglass_empty, message: l10n.videoWebSlowWarning),

        const SizedBox(height: 8),
        _PlanSummary(plan: plan),

        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onRender,
          icon: const Icon(Icons.movie_creation_outlined),
          label: Text(l10n.videoPreview),
        ),
        const SizedBox(height: 8),
        _Notice(icon: Icons.info_outline, message: l10n.videoEncoderUnavailable),
      ],
    );
  }

  String _styleLabel(AppLocalizations l10n, VideoStyle style) => switch (style) {
    VideoStyle.classic => l10n.videoStyleClassic,
    VideoStyle.night => l10n.videoStyleNight,
    VideoStyle.minimal => l10n.videoStyleMinimal,
  };
}

class _PlanSummary extends StatelessWidget {
  const _PlanSummary({required this.plan});

  final VideoPlanResult? plan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = plan;
    if (current == null) return const SizedBox.shrink();

    // Un cas d'erreur, un message traduit (§3.10) — jamais un message
    // générique, jamais un crash.
    if (current.error != null) {
      return _Notice(
        icon: Icons.error_outline,
        message: switch (current.error!) {
          VideoPlanErrorKind.unsupportedDuration => l10n.errorUnrecognisedFormat,
          VideoPlanErrorKind.emptyPeriod => l10n.statsEmpty,
          VideoPlanErrorKind.nothingToRender => l10n.storyEmpty,
        },
      );
    }

    final theme = Theme.of(context);
    final lastFrame = current.frames.isEmpty ? null : current.frames.last;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.videoPreview, style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            l10n.videoFrameCount(current.frames.length),
            style: theme.textTheme.titleMedium,
          ),
          if (lastFrame != null)
            Text(
              '${lastFrame.revealedPoints} · ${lastFrame.revealedSegments}',
              style: theme.textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
