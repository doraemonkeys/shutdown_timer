// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shutdown Timer Assistant';

  @override
  String get toastSetTimeGreaterThanZero =>
      'Set time must be greater than 0 seconds';

  @override
  String get toastUnsupportedOS => 'Unsupported operating system';

  @override
  String get toastShutdownSetSuccess => 'Shutdown timer set successfully!';

  @override
  String get toastShutdownSetFailed =>
      'Setup failed! Possibly insufficient permissions (try running as administrator)';

  @override
  String get toastShutdownCancelled => 'Shutdown timer cancelled';

  @override
  String get toastCancelFailed =>
      'Cancellation failed! There might be no active shutdown task.';

  @override
  String durationHours(int count) {
    return '${count}h';
  }

  @override
  String durationMinutes(int count) {
    return '${count}m';
  }

  @override
  String durationSeconds(int count) {
    return '${count}s';
  }

  @override
  String get addPresetDialogTitle => 'Add Custom Preset';

  @override
  String get addPresetDialogLabel => 'Time (e.g., 45m, 1h30m)';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get toastPresetAddedSuccess => 'Preset added successfully';

  @override
  String get toastPresetFormatError => 'Incorrect format!';

  @override
  String get toastPresetExistsError => 'Preset already exists!';

  @override
  String get deletePresetDialogTitle => 'Delete Preset';

  @override
  String deletePresetDialogContent(String presetName) {
    return 'Are you sure you want to delete the preset \'$presetName\'?';
  }

  @override
  String get deleteButton => 'Delete';

  @override
  String toastPresetDeleted(String presetName) {
    return 'Preset \'$presetName\' deleted';
  }

  @override
  String get tooltipToggleDark => 'Switch to Dark Mode';

  @override
  String get tooltipToggleSystem => 'Switch to System Mode';

  @override
  String get tooltipToggleLight => 'Switch to Light Mode';

  @override
  String get tooltipSelectThemeColor => 'Select Theme Color';

  @override
  String get countdownLabel => 'Time until shutdown';

  @override
  String get noTaskSetLabel => 'No shutdown task set';

  @override
  String get customTimeHint => 'Custom time, e.g., 1h30m';

  @override
  String get customTimeLabel => 'Custom';

  @override
  String get toastTimeFormatError =>
      'Incorrect time format!\nPlease use format like \'1h\', \'30m\', \'10s\'';

  @override
  String get quickPresetsLabel => 'Quick Presets';

  @override
  String get tooltipAddPreset => 'Add Preset';

  @override
  String get cancelShutdownTaskButton => 'Cancel Shutdown Task';

  @override
  String get tooltipSelectLanguage => 'Select Language';

  @override
  String get languageSystem => 'System Default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChineseSimplified => '简体中文';
}
