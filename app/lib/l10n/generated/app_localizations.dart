import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Application name (§3.9)
  ///
  /// In en, this message translates to:
  /// **'Odysseia'**
  String get appTitle;

  /// Story view tab (§3.3)
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get navStory;

  /// Stats view tab (§3.4)
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// Memory video tab (§3.5)
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get navVideo;

  /// Story navigation granularity (§3.3)
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get granularityDay;

  /// No description provided for @granularityWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get granularityWeek;

  /// No description provided for @granularityMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get granularityMonth;

  /// No description provided for @granularityYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get granularityYear;

  /// Story view with no data (§3.3)
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded for this period'**
  String get storyEmpty;

  /// No description provided for @storyEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Try another period, or import a Timeline export.'**
  String get storyEmptyHint;

  /// A visit entry in the story (§3.3)
  ///
  /// In en, this message translates to:
  /// **'Stay at {place}'**
  String storyVisitAt(String place);

  /// Fallback when the pipeline resolves to raw coordinates (§5.4)
  ///
  /// In en, this message translates to:
  /// **'Unnamed place'**
  String get storyUnnamedPlace;

  /// A trip entry in the story (§3.3)
  ///
  /// In en, this message translates to:
  /// **'{from} → {to}'**
  String storyTripFromTo(String from, String to);

  /// Marks a trip whose mode the user corrected (§5.2)
  ///
  /// In en, this message translates to:
  /// **'corrected'**
  String get storyCorrectedBadge;

  /// Weather integration disabled by default (§3.3, §2)
  ///
  /// In en, this message translates to:
  /// **'Weather off'**
  String get storyWeatherUnavailable;

  /// Photo correlation not enabled (§3.1)
  ///
  /// In en, this message translates to:
  /// **'Photos off'**
  String get storyPhotosUnavailable;

  /// Travel mode label (§5.1)
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get modeWalking;

  /// No description provided for @modeRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get modeRunning;

  /// No description provided for @modeCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get modeCycling;

  /// No description provided for @modeInVehicle.
  ///
  /// In en, this message translates to:
  /// **'By car'**
  String get modeInVehicle;

  /// No description provided for @modeInBus.
  ///
  /// In en, this message translates to:
  /// **'By bus'**
  String get modeInBus;

  /// No description provided for @modeInTrain.
  ///
  /// In en, this message translates to:
  /// **'By train'**
  String get modeInTrain;

  /// No description provided for @modeBoat.
  ///
  /// In en, this message translates to:
  /// **'By boat'**
  String get modeBoat;

  /// No description provided for @modeMotorcycling.
  ///
  /// In en, this message translates to:
  /// **'By motorbike'**
  String get modeMotorcycling;

  /// No description provided for @modeFlight.
  ///
  /// In en, this message translates to:
  /// **'By plane'**
  String get modeFlight;

  /// No description provided for @modeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get modeUnknown;

  /// Short weekday for the stats view (§3.4)
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySunday;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stats & patterns'**
  String get statsTitle;

  /// One of the six §3.4 statistics
  ///
  /// In en, this message translates to:
  /// **'Density heatmap'**
  String get statsDensity;

  /// No description provided for @statsTopPlaces.
  ///
  /// In en, this message translates to:
  /// **'Most visited places'**
  String get statsTopPlaces;

  /// No description provided for @statsTimePerPlace.
  ///
  /// In en, this message translates to:
  /// **'Time spent per place'**
  String get statsTimePerPlace;

  /// No description provided for @statsHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly patterns'**
  String get statsHourly;

  /// No description provided for @statsWeekday.
  ///
  /// In en, this message translates to:
  /// **'Day-of-week patterns'**
  String get statsWeekday;

  /// No description provided for @statsTotalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total distance'**
  String get statsTotalDistance;

  /// No description provided for @statsModeBreakdown.
  ///
  /// In en, this message translates to:
  /// **'By travel mode'**
  String get statsModeBreakdown;

  /// No description provided for @statsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No data for these filters'**
  String get statsEmpty;

  /// Number of stays after pipeline filtering (§5.4)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No stays} =1{1 stay} other{{count} stays}}'**
  String statsVisitCount(int count);

  /// No description provided for @statsSegmentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No trips} =1{1 trip} other{{count} trips}}'**
  String statsSegmentCount(int count);

  /// Combinable filters (§3.4)
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @filtersPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get filtersPeriod;

  /// No description provided for @filtersPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get filtersPlace;

  /// No description provided for @filtersMode.
  ///
  /// In en, this message translates to:
  /// **'Travel mode'**
  String get filtersMode;

  /// No description provided for @filtersAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filtersAll;

  /// No description provided for @filtersClear.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get filtersClear;

  /// No description provided for @videoTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory video'**
  String get videoTitle;

  /// No description provided for @videoDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get videoDuration;

  /// No description provided for @videoDurationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String videoDurationSeconds(int seconds);

  /// No description provided for @videoPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get videoPeriod;

  /// No description provided for @videoStyle.
  ///
  /// In en, this message translates to:
  /// **'Visual style'**
  String get videoStyle;

  /// No description provided for @videoStyleClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get videoStyleClassic;

  /// No description provided for @videoStyleNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get videoStyleNight;

  /// No description provided for @videoStyleMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get videoStyleMinimal;

  /// No description provided for @videoTitleTemplate.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get videoTitleTemplate;

  /// Placeholder text shown in the title field (§3.5)
  ///
  /// In en, this message translates to:
  /// **'My year in {year}'**
  String videoTitleTemplateHint(String year);

  /// No description provided for @videoRender.
  ///
  /// In en, this message translates to:
  /// **'Generate video'**
  String get videoRender;

  /// No description provided for @videoPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get videoPreview;

  /// No description provided for @videoFrameCount.
  ///
  /// In en, this message translates to:
  /// **'{count} frames'**
  String videoFrameCount(int count);

  /// Required web warning (§3.5)
  ///
  /// In en, this message translates to:
  /// **'Rendering in the browser is much slower than on device. You can keep using the app while it runs.'**
  String get videoWebSlowWarning;

  /// Honest state while the MP4 encoder is not integrated (§3.5)
  ///
  /// In en, this message translates to:
  /// **'Video export is not wired up yet — preview only.'**
  String get videoEncoderUnavailable;

  /// No description provided for @progressStep.
  ///
  /// In en, this message translates to:
  /// **'Step {step}'**
  String progressStep(String step);

  /// No description provided for @progressPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String progressPercent(int percent);

  /// One message per error case (§3.10) — never a generic catch-all
  ///
  /// In en, this message translates to:
  /// **'This export contains no data.'**
  String get errorEmptyExport;

  /// No description provided for @errorCorruptJson.
  ///
  /// In en, this message translates to:
  /// **'This file is not valid JSON and could not be read.'**
  String get errorCorruptJson;

  /// No description provided for @errorUnrecognisedFormat.
  ///
  /// In en, this message translates to:
  /// **'This export format is not recognised. It may come from a newer version of Google Timeline.'**
  String get errorUnrecognisedFormat;

  /// No description provided for @errorFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This file is too large to be processed on this device.'**
  String get errorFileTooLarge;

  /// No description provided for @errorIo.
  ///
  /// In en, this message translates to:
  /// **'The file could not be read.'**
  String get errorIo;

  /// Shown when private zones are active (§3.7)
  ///
  /// In en, this message translates to:
  /// **'Some data is hidden by your private zones'**
  String get privateZoneHidden;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
