// Vue Réglages et capacités (§2) — rendu pur.
//
// Deux exigences fortes de la spec se rencontrent ici :
//
// - **§2** : chaque intégration optionnelle a son propre interrupteur et son
//   propre avertissement, qui dit **explicitement quelles données dérivées de
//   la Timeline sont transmises**. « Nécessite une connexion » ne suffit pas.
// - **§2** : les fonctionnalités indisponibles ou dégradées sur la plateforme
//   sont affichées ici, pas supprimées silencieusement.
//
// Et §3.7 : « Mes données » est un écran, pas un bouton caché — export complet
// et suppression totale, avec confirmation irréversible.

import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Disponibilité d'une capacité sur la plateforme courante (§2).
enum CapabilityStatus {
  /// Disponible.
  available,

  /// Indisponible sur cette plateforme.
  unavailable,

  /// Prévue, pas encore branchée.
  notWired,
}

/// Une capacité et son état.
class Capability {
  /// Crée une capacité.
  const Capability({required this.label, required this.status});

  /// Libellé déjà traduit.
  final String label;

  /// État.
  final CapabilityStatus status;
}

/// Interrupteurs des intégrations optionnelles (§2), toutes à `false` par
/// défaut.
class IntegrationSwitches {
  /// Crée un jeu d'interrupteurs.
  const IntegrationSwitches({
    this.mapTiles = false,
    this.immich = false,
    this.weather = false,
  });

  /// Consentement aux tuiles de carte OSM (§2).
  final bool mapTiles;

  /// Serveur photo Immich (§3.1).
  final bool immich;

  /// API météo historique (§3.3).
  final bool weather;

  /// Copie modifiée.
  IntegrationSwitches copyWith({bool? mapTiles, bool? immich, bool? weather}) =>
      IntegrationSwitches(
        mapTiles: mapTiles ?? this.mapTiles,
        immich: immich ?? this.immich,
        weather: weather ?? this.weather,
      );
}

/// Vue Réglages (§2, §3.7).
class SettingsView extends StatelessWidget {
  /// Crée la vue.
  const SettingsView({
    super.key,
    required this.capabilities,
    this.integrations = const IntegrationSwitches(),
    this.onIntegrationsChanged,
    this.onExport,
    this.onDelete,
  });

  /// État des capacités de la plateforme.
  final List<Capability> capabilities;

  /// Interrupteurs des intégrations.
  final IntegrationSwitches integrations;

  /// Changement d'interrupteur.
  final ValueChanged<IntegrationSwitches>? onIntegrationsChanged;

  /// Export complet (§3.7).
  final VoidCallback? onExport;

  /// Suppression totale (§3.7).
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.settingsTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),

        _SectionTitle(l10n.settingsCapabilities),
        for (final capability in capabilities)
          _CapabilityTile(capability: capability),

        const SizedBox(height: 24),
        _SectionTitle(l10n.settingsIntegrations),
        Text(
          l10n.settingsIntegrationsIntro,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),

        _IntegrationTile(
          title: l10n.settingsMapTiles,
          detail: l10n.settingsMapTilesDetail,
          value: integrations.mapTiles,
          onChanged: onIntegrationsChanged == null
              ? null
              : (value) => onIntegrationsChanged!(
                  integrations.copyWith(mapTiles: value),
                ),
        ),
        _IntegrationTile(
          title: l10n.settingsImmich,
          detail: l10n.settingsImmichDetail,
          value: integrations.immich,
          onChanged: onIntegrationsChanged == null
              ? null
              : (value) =>
                    onIntegrationsChanged!(integrations.copyWith(immich: value)),
        ),
        _IntegrationTile(
          title: l10n.settingsWeather,
          detail: l10n.settingsWeatherDetail,
          value: integrations.weather,
          onChanged: onIntegrationsChanged == null
              ? null
              : (value) => onIntegrationsChanged!(
                  integrations.copyWith(weather: value),
                ),
        ),

        const SizedBox(height: 24),
        _SectionTitle(l10n.settingsMyData),
        OutlinedButton.icon(
          onPressed: onExport,
          icon: const Icon(Icons.download_outlined),
          label: Text(l10n.settingsExport),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          label: Text(l10n.settingsDelete),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}

class _CapabilityTile extends StatelessWidget {
  const _CapabilityTile({required this.capability});

  final Capability capability;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            switch (capability.status) {
              CapabilityStatus.available => Icons.check_circle_outline,
              CapabilityStatus.unavailable => Icons.block,
              CapabilityStatus.notWired => Icons.construction_outlined,
            },
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(capability.label, style: theme.textTheme.bodyMedium),
          ),
          Text(
            switch (capability.status) {
              CapabilityStatus.available => l10n.capabilityAvailable,
              CapabilityStatus.unavailable => l10n.capabilityUnavailable,
              CapabilityStatus.notWired => l10n.capabilityNotWired,
            },
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _IntegrationTile extends StatelessWidget {
  const _IntegrationTile({
    required this.title,
    required this.detail,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String detail;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 4),
                // L'avertissement est à côté de l'interrupteur, pas derrière un
                // lien : c'est la condition posée par §2.
                Text(detail, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// Demande la confirmation irréversible de §3.7.
Future<bool> confirmDeleteEverything(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.settingsDelete),
      content: Text(l10n.settingsDeleteConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.commonConfirm),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
