import 'dart:io';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  // call this method to initialize the local storage service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    const key = 'LOCAL_STORAGE_SERVICE_INIT';
    if (!_prefs.containsKey(key)) {
      await _prefs.setString(key, 'true');
    }
  }

  /// Returns all keys in the persistent storage.
  static Set<String> getKeys() {
    return _prefs.getKeys();
  }

  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  static Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  /// Completes with true once the user preferences for the app has been cleared.
  static Future<bool> clear() async {
    return _prefs.clear();
  }

  /// Fetches the latest values from the host platform.
  ///
  /// Use this method to observe modifications that were made in native code
  /// (without using the plugin) while the app is running.
  static Future<void> reload() async {
    return _prefs.reload();
  }

  /// Theme color
  static AppColorSeed get themeColor {
    final String? colorLable = _prefs.getString('themeColor');
    if (colorLable == null) {
      return AppColorSeed.baseColor;
    }
    return AppColorSeed.getSeedByLabel(colorLable);
  }

  static Future<bool> setThemeColor(AppColorSeed? value) async {
    if (value == null) {
      return _prefs.remove('themeColor');
    } else {
      return _prefs.setString('themeColor', value.label);
    }
  }

  static ThemeMode get themeMode {
    final String? themeMode = _prefs.getString('themeMode');
    if (themeMode == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeMode,
      orElse: () => ThemeMode.system,
    );
  }

  static Future<bool> setThemeMode(ThemeMode? value) async {
    if (value == null) {
      return _prefs.remove('themeMode');
    } else {
      return _prefs.setString('themeMode', value.name);
    }
  }

  static Locale get localeOrDefault {
    String? language = _prefs.getString('locale');
    language ??= Platform.localeName;

    return _parseLocale(language);
  }

  static Locale? get locale {
    String? language = _prefs.getString('locale');
    if (language == null) {
      return null;
    }
    return _parseLocale(language);
  }

  static Locale _parseLocale(String language) {
    final languageCode = language.split('_')[0];
    final countryCode = language.split('_').length > 1
        ? language.split('_')[1]
        : null;
    return Locale(languageCode, countryCode);
  }

  /// set null to use the system language
  static Future<bool> setLocale(Locale? value) async {
    if (value == null) {
      return _prefs.remove('locale');
    } else {
      return _prefs.setString('locale', value.toString());
    }
  }

  static int? get shutdownTargetTime {
    return _prefs.getInt('shutdownTargetTime');
  }

  static Future<bool> setShutdownTargetTime(int? value) async {
    if (value == null) {
      return _prefs.remove('shutdownTargetTime');
    } else {
      return _prefs.setInt('shutdownTargetTime', value);
    }
  }

  static List<Duration>? get customPresetsSeconds {
    final seconds = _prefs.getStringList('customPresetsSeconds');
    if (seconds == null) {
      return null;
    }
    return seconds.map((s) => Duration(seconds: int.parse(s))).toList();
  }

  static Future<bool> setCustomPresetsSeconds(List<Duration>? value) async {
    if (value == null) {
      return _prefs.remove('customPresetsSeconds');
    }
    return _prefs.setStringList(
      'customPresetsSeconds',
      value.map((s) => s.inSeconds.toString()).toList(),
    );
  }
}
