import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../local_storage_service.dart';

class AppProvider with ChangeNotifier {
  AppColorSeed _appSeedColor = LocalStorageService.themeColor;
  ThemeMode _themeMode = LocalStorageService.themeMode;
  Locale _localeOrDefault = LocalStorageService.localeOrDefault;
  Locale? _locale = LocalStorageService.locale;

  AppColorSeed get appSeedColor => _appSeedColor;
  ThemeMode get themeMode => _themeMode;
  Locale get localeOrDefault => _localeOrDefault;
  Locale? get locale => _locale;

  void setAppSeedColor(AppColorSeed? seedColor) {
    if (seedColor == null) {
      LocalStorageService.setThemeColor(null);
      _appSeedColor = LocalStorageService.themeColor;
    } else {
      _appSeedColor = seedColor;
      LocalStorageService.setThemeColor(seedColor);
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode? themeMode) {
    if (themeMode == null) {
      LocalStorageService.setThemeMode(null);
      _themeMode = LocalStorageService.themeMode;
    } else {
      _themeMode = themeMode;
      LocalStorageService.setThemeMode(themeMode);
    }
    notifyListeners();
  }

  void setLocale(Locale? locale) {
    if (locale == null) {
      LocalStorageService.setLocale(null);
      _localeOrDefault = LocalStorageService.localeOrDefault;
      _locale = null;
    } else {
      _localeOrDefault = locale;
      _locale = locale;
      LocalStorageService.setLocale(locale);
    }
    notifyListeners();
  }
}
