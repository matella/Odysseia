// Vue Import (§3.3) — rendu pur.
//
// Affiche la progression remontée par le cœur (§4) et, à la fin, les
// avertissements que §4 exige : un nouvel import remplace tout, et un export
// plus court que le précédent peut faire perdre de l'historique.
//
// Chaque cause d'échec a son message traduit (§3.10) — jamais de « une erreur
// est survenue ».

import 'package:flutter/material.dart';

import '../../bridge/generated/api/import.dart';
import '../../data/import_service.dart';
import '../../l10n/generated/app_localizations.dart';

/// Vue Import (§3.3).
class ImportView extends StatelessWidget {
  /// Crée la vue.
  const ImportView({
    super.key,
    required this.state,
    this.onChooseFile,
    this.pickerAvailable = true,
  });

  /// État courant de l'import.
  final ImportState state;

  /// Demande de sélection de fichier.
  final VoidCallback? onChooseFile;

  /// La plateforme sait-elle ouvrir un sélecteur de fichier ?
  final bool pickerAvailable;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.importTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.importIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),

        // §4 : l'avertissement avant écrasement, dit avant d'agir et non après.
        _Notice(icon: Icons.swap_horiz, message: l10n.importReplaceWarning),

        if (!pickerAvailable)
          _Notice(
            icon: Icons.info_outline,
            message: l10n.importPickerUnavailable,
          ),

        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: pickerAvailable ? onChooseFile : null,
          icon: const Icon(Icons.folder_open),
          label: Text(l10n.importChoose),
        ),

        const SizedBox(height: 16),
        switch (state) {
          ImportIdle() => const SizedBox.shrink(),
          ImportRunning(:final step, :final percent, :final records) =>
            _Running(step: step, percent: percent, records: records),
          ImportDone(:final summary, :final shorterThanPrevious) =>
            _Done(summary: summary, shorterThanPrevious: shorterThanPrevious),
          ImportFailed(:final kind) => _Failed(kind: kind),
        },
      ],
    );
  }
}

class _Running extends StatelessWidget {
  const _Running({
    required this.step,
    required this.percent,
    required this.records,
  });

  final ImportStepKind step;
  final double? percent;
  final int records;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.importRunning, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        // Barre indéterminée si la taille est inconnue : mieux vaut ne pas
        // afficher de pourcentage que d'en inventer un (§4).
        LinearProgressIndicator(
          value: percent == null ? null : percent! / 100,
        ),
        const SizedBox(height: 8),
        Text(
          '${switch (step) {
            ImportStepKind.detectingFormat => l10n.importStepDetecting,
            ImportStepKind.readingRecords => l10n.importStepReading,
            ImportStepKind.done => l10n.importStepDone,
          }} · ${l10n.importRecords(records)}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _Done extends StatelessWidget {
  const _Done({required this.summary, required this.shorterThanPrevious});

  final ImportSummaryOutput summary;
  final bool shorterThanPrevious;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle_outline, size: 20),
            const SizedBox(width: 8),
            Text(l10n.importSucceeded, style: theme.textTheme.titleSmall),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          l10n.importCounts(
            summary.visitCount,
            summary.segmentCount,
            summary.pointCount,
          ),
          style: theme.textTheme.bodyMedium,
        ),
        // Les rejets sont comptés et montrés — jamais silencieux (§3.10).
        if (summary.skippedCount > 0) ...[
          const SizedBox(height: 4),
          Text(
            l10n.importSkipped(summary.skippedCount),
            style: theme.textTheme.bodySmall,
          ),
        ],
        if (shorterThanPrevious)
          _Notice(
            icon: Icons.warning_amber_outlined,
            message: l10n.importShorterWarning,
          ),
      ],
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.kind});

  final ImportErrorKind kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Notice(
      icon: Icons.error_outline,
      // §3.10 : un cas, un message. Pas de fourre-tout.
      message: switch (kind) {
        ImportErrorKind.emptyExport => l10n.errorEmptyExport,
        ImportErrorKind.corruptJson => l10n.errorCorruptJson,
        ImportErrorKind.unrecognisedFormat => l10n.errorUnrecognisedFormat,
        ImportErrorKind.fileTooLarge => l10n.errorFileTooLarge,
        ImportErrorKind.io => l10n.errorIo,
      },
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
