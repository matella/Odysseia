// Mise en forme pour l'affichage.
//
// Frontière à garder en tête (§6.1) : formater n'est pas calculer. Choisir
// d'écrire « 1,2 km » plutôt que « 1234 m » est une décision d'UI ; décider
// *quelle* distance afficher appartient au pipeline et aux stats, en Rust.
// Rien ici ne dérive de donnée nouvelle — on met en forme ce que le cœur a
// déjà produit.

import 'package:flutter/widgets.dart';

import '../bridge/generated/api/timeline.dart';
import '../l10n/generated/app_localizations.dart';

/// Libellé traduit d'un mode de transport (§3.9).
String modeLabel(AppLocalizations l10n, TravelMode mode) => switch (mode) {
  TravelMode.walking => l10n.modeWalking,
  TravelMode.running => l10n.modeRunning,
  TravelMode.cycling => l10n.modeCycling,
  TravelMode.inVehicle => l10n.modeInVehicle,
  TravelMode.inBus => l10n.modeInBus,
  TravelMode.inTrain => l10n.modeInTrain,
  TravelMode.boat => l10n.modeBoat,
  TravelMode.motorcycling => l10n.modeMotorcycling,
  TravelMode.flight => l10n.modeFlight,
  TravelMode.unknown => l10n.modeUnknown,
};

/// Libellé traduit d'un mode depuis la clé stable produite par le cœur.
///
/// Le cœur ne renvoie jamais de texte destiné à l'utilisateur (§3.9) : il
/// renvoie `"in_vehicle"`, c'est l'UI qui en fait « En voiture ».
String modeLabelFromKey(AppLocalizations l10n, String key) => switch (key) {
  'walking' => l10n.modeWalking,
  'running' => l10n.modeRunning,
  'cycling' => l10n.modeCycling,
  'in_vehicle' => l10n.modeInVehicle,
  'in_bus' => l10n.modeInBus,
  'in_train' => l10n.modeInTrain,
  'boat' => l10n.modeBoat,
  'motorcycling' => l10n.modeMotorcycling,
  'flight' => l10n.modeFlight,
  _ => l10n.modeUnknown,
};

/// Libellé court traduit d'un jour de semaine (§3.9).
String weekdayLabel(AppLocalizations l10n, String key) => switch (key) {
  'monday' => l10n.weekdayMonday,
  'tuesday' => l10n.weekdayTuesday,
  'wednesday' => l10n.weekdayWednesday,
  'thursday' => l10n.weekdayThursday,
  'friday' => l10n.weekdayFriday,
  'saturday' => l10n.weekdaySaturday,
  _ => l10n.weekdaySunday,
};

/// Heure locale d'un instant, au format `HH:mm`.
///
/// Reconstruite depuis UTC + offset, jamais depuis l'heure de l'appareil : un
/// trajet fait à Tokyo doit s'afficher à l'heure de Tokyo (§5.5).
String localTimeOfDay(int utcMillis, int tzOffsetMinutes) {
  final local = utcMillis + tzOffsetMinutes * 60000;
  final millisInDay = local.remainder(86400000) + (local < 0 ? 86400000 : 0);
  final hours = (millisInDay ~/ 3600000) % 24;
  final minutes = (millisInDay ~/ 60000) % 60;
  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}';
}

/// Durée abrégée, `2 h 05` ou `45 min`.
String formatDuration(int millis) {
  final totalMinutes = (millis / 60000).round();
  if (totalMinutes < 60) return '$totalMinutes min';
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  return '$hours h ${minutes.toString().padLeft(2, '0')}';
}

/// Distance abrégée, `1,2 km` ou `340 m`.
String formatDistance(double metres) {
  if (metres < 1000) return '${metres.round()} m';
  final km = metres / 1000;
  return '${km.toStringAsFixed(km < 10 ? 1 : 0)} km';
}

/// Nom affichable d'un lieu résolu, ou le repli traduit (§5.4).
String placeLabelOr(AppLocalizations l10n, String? label) =>
    (label == null || label.isEmpty) ? l10n.storyUnnamedPlace : label;

/// Palette dérivée du thème, pour que les vues restent cohérentes.
extension OdysseiaColors on BuildContext {
  /// Couleur d'accent de la vue courante.
  Color get accent => const Color(0xFF3D6B9C);
}
