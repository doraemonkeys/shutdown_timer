import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shutdown Timer Assistant'**
  String get appTitle;

  /// No description provided for @toastSetTimeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Set time must be greater than 0 seconds'**
  String get toastSetTimeGreaterThanZero;

  /// No description provided for @toastUnsupportedOS.
  ///
  /// In en, this message translates to:
  /// **'Unsupported operating system'**
  String get toastUnsupportedOS;

  /// No description provided for @toastShutdownSetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Shutdown timer set successfully!'**
  String get toastShutdownSetSuccess;

  /// No description provided for @toastShutdownSetFailed.
  ///
  /// In en, this message translates to:
  /// **'Setup failed! Possibly insufficient permissions (try running as administrator)'**
  String get toastShutdownSetFailed;

  /// No description provided for @toastShutdownCancelled.
  ///
  /// In en, this message translates to:
  /// **'Shutdown timer cancelled'**
  String get toastShutdownCancelled;

  /// No description provided for @toastCancelFailed.
  ///
  /// In en, this message translates to:
  /// **'Cancellation failed! There might be no active shutdown task.'**
  String get toastCancelFailed;

  /// Duration in hours, e.g., 2h
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String durationHours(String count);

  /// Duration in minutes, e.g., 30m
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String durationMinutes(int count);

  /// Duration in seconds, e.g., 45s
  ///
  /// In en, this message translates to:
  /// **'{count}s'**
  String durationSeconds(int count);

  /// No description provided for @addPresetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Preset'**
  String get addPresetDialogTitle;

  /// No description provided for @addPresetDialogLabel.
  ///
  /// In en, this message translates to:
  /// **'Time (e.g., 45m, 1h30m)'**
  String get addPresetDialogLabel;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @toastPresetAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Preset added successfully'**
  String get toastPresetAddedSuccess;

  /// No description provided for @toastPresetFormatError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect format!'**
  String get toastPresetFormatError;

  /// No description provided for @toastPresetExistsError.
  ///
  /// In en, this message translates to:
  /// **'Preset already exists!'**
  String get toastPresetExistsError;

  /// No description provided for @deletePresetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Preset'**
  String get deletePresetDialogTitle;

  /// Confirmation message for deleting a preset.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the preset \'{presetName}\'?'**
  String deletePresetDialogContent(String presetName);

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// Toast message after a preset is deleted.
  ///
  /// In en, this message translates to:
  /// **'Preset \'{presetName}\' deleted'**
  String toastPresetDeleted(String presetName);

  /// No description provided for @tooltipToggleDark.
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark Mode'**
  String get tooltipToggleDark;

  /// No description provided for @tooltipToggleSystem.
  ///
  /// In en, this message translates to:
  /// **'Switch to System Mode'**
  String get tooltipToggleSystem;

  /// No description provided for @tooltipToggleLight.
  ///
  /// In en, this message translates to:
  /// **'Switch to Light Mode'**
  String get tooltipToggleLight;

  /// No description provided for @tooltipSelectThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Select Theme Color'**
  String get tooltipSelectThemeColor;

  /// No description provided for @countdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Time until shutdown'**
  String get countdownLabel;

  /// No description provided for @noTaskSetLabel.
  ///
  /// In en, this message translates to:
  /// **'No shutdown task set'**
  String get noTaskSetLabel;

  /// No description provided for @customTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Custom time, e.g., 1h30m'**
  String get customTimeHint;

  /// No description provided for @customTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customTimeLabel;

  /// No description provided for @toastTimeFormatError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect time format!\nPlease use format like \'1h\', \'30m\', \'10s\''**
  String get toastTimeFormatError;

  /// No description provided for @quickPresetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Quick Presets'**
  String get quickPresetsLabel;

  /// No description provided for @tooltipAddPreset.
  ///
  /// In en, this message translates to:
  /// **'Add Preset'**
  String get tooltipAddPreset;

  /// No description provided for @cancelShutdownTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel Shutdown Task'**
  String get cancelShutdownTaskButton;

  /// No description provided for @tooltipSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get tooltipSelectLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChineseSimplified.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get languageChineseSimplified;
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
