import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'local_storage_service.dart';
import 'app_theme.dart';
import 'providers/app_provider.dart';
import 'package:shutdown_timer/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(ShutdownTimerApp());
}

class ShutdownTimerApp extends StatelessWidget {
  ShutdownTimerApp({super.key});

  final appProvider =
      AppProvider(); // Assuming AppProvider loads its state internally

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appProvider,
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) => MaterialApp(
          onGenerateTitle: (context) {
            return AppLocalizations.of(context)!.appTitle;
          },
          theme: AppTheme.lightTheme(seed: appProvider.appSeedColor),
          darkTheme: AppTheme.darkTheme(seed: appProvider.appSeedColor),
          themeMode: appProvider.themeMode,
          locale: appProvider.localeOrDefault,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
