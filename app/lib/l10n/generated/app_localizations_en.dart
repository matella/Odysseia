// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Odysseia';

  @override
  String get navStory => 'Story';

  @override
  String get navStats => 'Stats';

  @override
  String get navVideo => 'Video';

  @override
  String get granularityDay => 'Day';

  @override
  String get granularityWeek => 'Week';

  @override
  String get granularityMonth => 'Month';

  @override
  String get granularityYear => 'Year';

  @override
  String get storyEmpty => 'Nothing recorded for this period';

  @override
  String get storyEmptyHint =>
      'Try another period, or import a Timeline export.';

  @override
  String storyVisitAt(String place) {
    return 'Stay at $place';
  }

  @override
  String get storyUnnamedPlace => 'Unnamed place';

  @override
  String storyTripFromTo(String from, String to) {
    return '$from → $to';
  }

  @override
  String get storyCorrectedBadge => 'corrected';

  @override
  String get storyWeatherUnavailable => 'Weather off';

  @override
  String get storyPhotosUnavailable => 'Photos off';

  @override
  String get modeWalking => 'Walking';

  @override
  String get modeRunning => 'Running';

  @override
  String get modeCycling => 'Cycling';

  @override
  String get modeInVehicle => 'By car';

  @override
  String get modeInBus => 'By bus';

  @override
  String get modeInTrain => 'By train';

  @override
  String get modeBoat => 'By boat';

  @override
  String get modeMotorcycling => 'By motorbike';

  @override
  String get modeFlight => 'By plane';

  @override
  String get modeUnknown => 'Unknown';

  @override
  String get weekdayMonday => 'Mon';

  @override
  String get weekdayTuesday => 'Tue';

  @override
  String get weekdayWednesday => 'Wed';

  @override
  String get weekdayThursday => 'Thu';

  @override
  String get weekdayFriday => 'Fri';

  @override
  String get weekdaySaturday => 'Sat';

  @override
  String get weekdaySunday => 'Sun';

  @override
  String get statsTitle => 'Stats & patterns';

  @override
  String get statsDensity => 'Density heatmap';

  @override
  String get statsTopPlaces => 'Most visited places';

  @override
  String get statsTimePerPlace => 'Time spent per place';

  @override
  String get statsHourly => 'Hourly patterns';

  @override
  String get statsWeekday => 'Day-of-week patterns';

  @override
  String get statsTotalDistance => 'Total distance';

  @override
  String get statsModeBreakdown => 'By travel mode';

  @override
  String get statsEmpty => 'No data for these filters';

  @override
  String statsVisitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stays',
      one: '1 stay',
      zero: 'No stays',
    );
    return '$_temp0';
  }

  @override
  String statsSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trips',
      one: '1 trip',
      zero: 'No trips',
    );
    return '$_temp0';
  }

  @override
  String get filtersTitle => 'Filters';

  @override
  String get filtersPeriod => 'Period';

  @override
  String get filtersPlace => 'Place';

  @override
  String get filtersMode => 'Travel mode';

  @override
  String get filtersAll => 'All';

  @override
  String get filtersClear => 'Clear filters';

  @override
  String get videoTitle => 'Memory video';

  @override
  String get videoDuration => 'Duration';

  @override
  String videoDurationSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get videoPeriod => 'Period';

  @override
  String get videoStyle => 'Visual style';

  @override
  String get videoStyleClassic => 'Classic';

  @override
  String get videoStyleNight => 'Night';

  @override
  String get videoStyleMinimal => 'Minimal';

  @override
  String get videoTitleTemplate => 'Title';

  @override
  String videoTitleTemplateHint(String year) {
    return 'My year in $year';
  }

  @override
  String get videoRender => 'Generate video';

  @override
  String get videoPreview => 'Preview';

  @override
  String videoFrameCount(int count) {
    return '$count frames';
  }

  @override
  String get videoWebSlowWarning =>
      'Rendering in the browser is much slower than on device. You can keep using the app while it runs.';

  @override
  String get videoEncoderUnavailable =>
      'Video export is not wired up yet — preview only.';

  @override
  String progressStep(String step) {
    return 'Step $step';
  }

  @override
  String progressPercent(int percent) {
    return '$percent%';
  }

  @override
  String get errorEmptyExport => 'This export contains no data.';

  @override
  String get errorCorruptJson =>
      'This file is not valid JSON and could not be read.';

  @override
  String get errorUnrecognisedFormat =>
      'This export format is not recognised. It may come from a newer version of Google Timeline.';

  @override
  String get errorFileTooLarge =>
      'This file is too large to be processed on this device.';

  @override
  String get errorIo => 'The file could not be read.';

  @override
  String get privateZoneHidden => 'Some data is hidden by your private zones';

  @override
  String get importTitle => 'Import';

  @override
  String get importIntro =>
      'Import your Google Timeline export. Everything is processed on this device — nothing is sent anywhere (§2).';

  @override
  String get importChoose => 'Choose a file';

  @override
  String get importPickerUnavailable =>
      'File picking is not wired up on this platform yet. Import works — it just needs a path.';

  @override
  String get importReplaceWarning =>
      'A new import replaces the current dataset. Your named places, private zones and corrections are kept.';

  @override
  String get importRunning => 'Importing…';

  @override
  String get importStepDetecting => 'Detecting format';

  @override
  String get importStepReading => 'Reading records';

  @override
  String get importStepDone => 'Finishing';

  @override
  String importRecords(int count) {
    return '$count records';
  }

  @override
  String get importSucceeded => 'Import finished';

  @override
  String importCounts(int visits, int segments, int points) {
    return '$visits stays · $segments trips · $points points';
  }

  @override
  String importSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records were unreadable and skipped',
      one: '1 record was unreadable and skipped',
      zero: '',
    );
    return '$_temp0';
  }

  @override
  String get importShorterWarning =>
      'This export covers a shorter period than the previous one. Older history may be missing from it.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsCapabilities => 'Platform';

  @override
  String get settingsIntegrations => 'Optional integrations';

  @override
  String get settingsIntegrationsIntro =>
      'All off by default. Each one sends Timeline-derived data to a third party — what exactly is stated below.';

  @override
  String get settingsMapTiles => 'Map tiles (OpenStreetMap)';

  @override
  String get settingsMapTilesDetail =>
      'Sends only the map areas you look at. Never any Timeline data.';

  @override
  String get settingsImmich => 'Immich photo server';

  @override
  String get settingsImmichDetail =>
      'Sends dates and coordinates derived from your Timeline to the server you configure.';

  @override
  String get settingsWeather => 'Historical weather';

  @override
  String get settingsWeatherDetail =>
      'Sends coordinates rounded to 2 decimals (~1.1 km) and a date to a third-party weather API.';

  @override
  String get settingsMyData => 'My data';

  @override
  String get settingsExport => 'Export everything';

  @override
  String get settingsDelete => 'Delete all local data';

  @override
  String get settingsDeleteConfirm =>
      'This permanently deletes your imported data, named places, private zones and corrections. This cannot be undone.';

  @override
  String get settingsDeleteDone => 'All local data deleted';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonClose => 'Close';

  @override
  String get capabilityDatabase => 'Local database';

  @override
  String get capabilityBridge => 'Compute core';

  @override
  String get capabilityVideoExport => 'Video export';

  @override
  String get capabilityAvailable => 'Available';

  @override
  String get capabilityUnavailable => 'Not available on this platform';

  @override
  String get capabilityNotWired => 'Not wired up yet';
}
