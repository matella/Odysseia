// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Odysseia';

  @override
  String get navStory => 'Récit';

  @override
  String get navStats => 'Stats';

  @override
  String get navVideo => 'Vidéo';

  @override
  String get granularityDay => 'Jour';

  @override
  String get granularityWeek => 'Semaine';

  @override
  String get granularityMonth => 'Mois';

  @override
  String get granularityYear => 'Année';

  @override
  String get storyEmpty => 'Rien d\'enregistré sur cette période';

  @override
  String get storyEmptyHint =>
      'Essayez une autre période, ou importez un export Timeline.';

  @override
  String storyVisitAt(String place) {
    return 'Arrêt à $place';
  }

  @override
  String get storyUnnamedPlace => 'Lieu sans nom';

  @override
  String storyTripFromTo(String from, String to) {
    return '$from → $to';
  }

  @override
  String get storyCorrectedBadge => 'corrigé';

  @override
  String get storyWeatherUnavailable => 'Météo désactivée';

  @override
  String get storyPhotosUnavailable => 'Photos désactivées';

  @override
  String get modeWalking => 'À pied';

  @override
  String get modeRunning => 'En courant';

  @override
  String get modeCycling => 'À vélo';

  @override
  String get modeInVehicle => 'En voiture';

  @override
  String get modeInBus => 'En bus';

  @override
  String get modeInTrain => 'En train';

  @override
  String get modeBoat => 'En bateau';

  @override
  String get modeMotorcycling => 'À moto';

  @override
  String get modeFlight => 'En avion';

  @override
  String get modeUnknown => 'Inconnu';

  @override
  String get weekdayMonday => 'lun';

  @override
  String get weekdayTuesday => 'mar';

  @override
  String get weekdayWednesday => 'mer';

  @override
  String get weekdayThursday => 'jeu';

  @override
  String get weekdayFriday => 'ven';

  @override
  String get weekdaySaturday => 'sam';

  @override
  String get weekdaySunday => 'dim';

  @override
  String get statsTitle => 'Stats & patterns';

  @override
  String get statsDensity => 'Heatmap de densité';

  @override
  String get statsTopPlaces => 'Lieux les plus visités';

  @override
  String get statsTimePerPlace => 'Temps passé par lieu';

  @override
  String get statsHourly => 'Patterns horaires';

  @override
  String get statsWeekday => 'Patterns par jour de semaine';

  @override
  String get statsTotalDistance => 'Distance totale';

  @override
  String get statsModeBreakdown => 'Par mode de transport';

  @override
  String get statsEmpty => 'Aucune donnée pour ces filtres';

  @override
  String statsVisitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arrêts',
      one: '1 arrêt',
      zero: 'Aucun arrêt',
    );
    return '$_temp0';
  }

  @override
  String statsSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trajets',
      one: '1 trajet',
      zero: 'Aucun trajet',
    );
    return '$_temp0';
  }

  @override
  String get filtersTitle => 'Filtres';

  @override
  String get filtersPeriod => 'Période';

  @override
  String get filtersPlace => 'Lieu';

  @override
  String get filtersMode => 'Mode de transport';

  @override
  String get filtersAll => 'Tous';

  @override
  String get filtersClear => 'Effacer les filtres';

  @override
  String get videoTitle => 'Vidéo souvenir';

  @override
  String get videoDuration => 'Durée';

  @override
  String videoDurationSeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String get videoPeriod => 'Période';

  @override
  String get videoStyle => 'Style visuel';

  @override
  String get videoStyleClassic => 'Classique';

  @override
  String get videoStyleNight => 'Nuit';

  @override
  String get videoStyleMinimal => 'Épuré';

  @override
  String get videoTitleTemplate => 'Titre';

  @override
  String videoTitleTemplateHint(String year) {
    return 'Mon année $year';
  }

  @override
  String get videoRender => 'Générer la vidéo';

  @override
  String get videoPreview => 'Aperçu';

  @override
  String videoFrameCount(int count) {
    return '$count images';
  }

  @override
  String get videoWebSlowWarning =>
      'Le rendu dans le navigateur est nettement plus lent que sur l\'appareil. Vous pouvez continuer à utiliser l\'app pendant ce temps.';

  @override
  String get videoEncoderUnavailable =>
      'L\'export vidéo n\'est pas encore branché — aperçu seulement.';

  @override
  String progressStep(String step) {
    return 'Étape $step';
  }

  @override
  String progressPercent(int percent) {
    return '$percent %';
  }

  @override
  String get errorEmptyExport => 'Cet export ne contient aucune donnée.';

  @override
  String get errorCorruptJson =>
      'Ce fichier n\'est pas du JSON valide et n\'a pas pu être lu.';

  @override
  String get errorUnrecognisedFormat =>
      'Ce format d\'export n\'est pas reconnu. Il vient peut-être d\'une version plus récente de Google Timeline.';

  @override
  String get errorFileTooLarge =>
      'Ce fichier est trop volumineux pour être traité sur cet appareil.';

  @override
  String get errorIo => 'Le fichier n\'a pas pu être lu.';

  @override
  String get privateZoneHidden =>
      'Certaines données sont masquées par vos zones privées';
}
