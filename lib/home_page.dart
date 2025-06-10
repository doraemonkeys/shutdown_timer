import 'dart:async';
import 'dart:io'; // For Platform
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:process_run/shell.dart';
import 'package:toastification/toastification.dart';
import 'local_storage_service.dart';
import 'providers/app_provider.dart';
import 'package:shutdown_timer/l10n/app_localizations.dart';
import 'app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 状态变量
  Timer? _countdownTimer;
  DateTime? _targetTime;
  Duration _remainingTime = Duration.zero;
  final _customTimeController = TextEditingController();

  // 预设时间
  List<Duration> _presets = [];

  static const Set<int> _defaultPresetInSeconds = {
    30 * 60, // 30 minutes
    1 * 60 * 60, // 1 hour
    2 * 60 * 60, // 2 hours
  };

  // Helper to access localizations easily
  AppLocalizations get S => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _loadShutdownState();
    _loadCustomPresets();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _customTimeController.dispose();
    super.dispose();
  }

  // ---- 核心逻辑 ----

  Future<void> _loadShutdownState() async {
    final targetTimestamp = LocalStorageService.shutdownTargetTime;
    if (targetTimestamp != null) {
      final targetTime = DateTime.fromMillisecondsSinceEpoch(targetTimestamp);
      if (targetTime.isAfter(DateTime.now())) {
        setState(() {
          _targetTime = targetTime;
        });
        _startCountdown();
      } else {
        await _clearShutdownState();
      }
    }
  }

  Future<void> _loadCustomPresets() async {
    var customDurations = LocalStorageService.customPresetsSeconds;
    if (customDurations == null) {
      await LocalStorageService.setCustomPresetsSeconds([
        ..._defaultPresetInSeconds.map((s) => Duration(seconds: s)),
      ]);
      customDurations = LocalStorageService.customPresetsSeconds;
    }

    setState(() {
      _presets = [...customDurations!];
      final uniquePresetsSet = <Duration>{};
      _presets = _presets.where((d) => uniquePresetsSet.add(d)).toList();
      _presets.sort((a, b) => a.inSeconds.compareTo(b.inSeconds));
    });
  }

  Future<void> _clearShutdownState() async {
    await LocalStorageService.setShutdownTargetTime(null);
    setState(() {
      _targetTime = null;
      _remainingTime = Duration.zero;
    });
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (_targetTime == null || now.isAfter(_targetTime!)) {
        setState(() {
          _remainingTime = Duration.zero;
          timer.cancel();
          _clearShutdownState();
        });
      } else {
        setState(() {
          _remainingTime = _targetTime!.difference(now);
        });
      }
    });
  }

  Future<void> _setShutdown(Duration duration) async {
    if (duration.inSeconds <= 0) {
      _showToast(S.toastSetTimeGreaterThanZero, isError: true);
      return;
    }

    try {
      final shell = Shell();
      if (Platform.isWindows) {
        await shell.run('shutdown -s -t ${duration.inSeconds}');
      } else if (Platform.isMacOS || Platform.isLinux) {
        final minutes = (duration.inSeconds / 60).ceil();
        await shell.run('sudo shutdown -h +$minutes');
      } else {
        _showToast(S.toastUnsupportedOS, isError: true);
        return;
      }

      final targetTime = DateTime.now().add(duration);
      await LocalStorageService.setShutdownTargetTime(
        targetTime.millisecondsSinceEpoch,
      );

      setState(() {
        _targetTime = targetTime;
      });
      _startCountdown();
      // _showToast(S.toastShutdownSetSuccess);
    } catch (e) {
      print(e);
      if (Platform.isWindows && e.toString().contains("1190")) {
        await _cancelShutdown(showToast: false);
        _setShutdown(duration);
        return;
      }
      _showToast(S.toastShutdownSetFailed, isError: true);
    }
  }

  Future<void> _cancelShutdown({bool showToast = true}) async {
    try {
      final shell = Shell();
      if (Platform.isWindows) {
        await shell.run('shutdown -a');
      } else if (Platform.isMacOS || Platform.isLinux) {
        await shell.run('sudo shutdown -c');
      } else {
        _showToast(S.toastUnsupportedOS, isError: true);
        return;
      }

      _countdownTimer?.cancel();
      await _clearShutdownState();
    } catch (e) {
      print(e);
      if (showToast) {
        _showToast(S.toastCancelFailed, isError: true);
      }
    }
  }

  Duration? _parseDuration(String text) {
    text = text.toLowerCase().trim();
    if (text.isEmpty) return null;
    final regExp = RegExp(r'(?:(\d+)h)?(?:(\d+)m)?(?:(\d+)s)?');
    final match = regExp.firstMatch(text);
    if (match == null || match.group(0) != text) return null;
    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;
    if (hours == 0 && minutes == 0 && seconds == 0) return null;
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _formatDurationToText(BuildContext ctx, Duration d) {
    final l10n = AppLocalizations.of(ctx)!;
    if (d.inHours > 0) return l10n.durationHours(d.inHours);
    if (d.inMinutes > 0) return l10n.durationMinutes(d.inMinutes);
    return l10n.durationSeconds(d.inSeconds);
  }

  void _showToast(String message, {bool isError = false}) {
    if (context.mounted) {
      Toastification().show(
        context: context,
        description: Text(message),
        autoCloseDuration: const Duration(seconds: 3),
        type: isError ? ToastificationType.error : ToastificationType.success,
      );
    }
  }

  void _showAddPresetDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        final dialogS = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(dialogS.addPresetDialogTitle),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: dialogS.addPresetDialogLabel,
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(dialogS.cancelButton),
            ),
            FilledButton(
              onPressed: () {
                final duration = _parseDuration(controller.text);
                if (duration != null && !_presets.contains(duration)) {
                  setState(() {
                    _presets.add(duration);
                    _presets.sort((a, b) => a.inSeconds.compareTo(b.inSeconds));
                  });
                  LocalStorageService.setCustomPresetsSeconds(_presets);
                  Navigator.pop(dialogContext);
                } else {
                  _showToast(
                    duration == null
                        ? S.toastPresetFormatError
                        : S.toastPresetExistsError,
                    isError: true,
                  );
                }
              },
              child: Text(dialogS.confirmButton),
            ),
          ],
        );
      },
    );
  }

  void _showDeletePresetConfirmDialog(Duration durationToDelete) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final dialogS = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(dialogS.deletePresetDialogTitle),
          content: Text(
            dialogS.deletePresetDialogContent(
              _formatDurationToText(dialogContext, durationToDelete),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(dialogS.cancelButton),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(dialogS.deleteButton),
              onPressed: () {
                setState(() {
                  _presets.remove(durationToDelete);
                  _presets.sort((a, b) => a.inSeconds.compareTo(b.inSeconds));
                });
                LocalStorageService.setCustomPresetsSeconds(_presets);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ---- Helper methods ----
  IconData _getBrightnessIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
      case ThemeMode.system:
        return Icons.brightness_auto_outlined;
    }
  }

  String _getBrightnessTooltip(BuildContext ctx, ThemeMode themeMode) {
    final l10n = AppLocalizations.of(ctx)!;
    switch (themeMode) {
      case ThemeMode.light:
        return l10n.tooltipToggleDark;
      case ThemeMode.dark:
        return l10n.tooltipToggleSystem;
      case ThemeMode.system:
        return l10n.tooltipToggleLight;
    }
  }

  String _getLanguageName(BuildContext ctx, Locale locale) {
    final l10n = AppLocalizations.of(ctx)!;
    switch (locale.languageCode) {
      case 'en':
        return l10n.languageEnglish;
      case 'zh':
        return l10n.languageChineseSimplified;
      default:
        return locale.toLanguageTag();
    }
  }

  // ---- UI 构建 ----
  @override
  Widget build(BuildContext context) {
    bool isTimerActive = _targetTime != null;
    final theme = Theme.of(context);
    final appProviderForActions = Provider.of<AppProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(S.appTitle),
        actions: [
          Consumer<AppProvider>(
            builder: (context, appProvider, _) {
              final consumerS = AppLocalizations.of(context)!;
              return PopupMenuButton<Locale?>(
                icon: const Icon(Icons.translate_outlined),
                tooltip: consumerS.tooltipSelectLanguage,
                onSelected: (Locale? selectedLocale) {
                  appProviderForActions.setLocale(selectedLocale);
                },
                initialValue: appProvider.locale,

                itemBuilder: (BuildContext popupContext) {
                  final currentLocale = appProvider.locale;

                  Widget buildCheckedItem(String text, bool isChecked) {
                    return Row(
                      children: [
                        Expanded(child: Text(text)),
                        if (isChecked)
                          Icon(
                            Icons.check,
                            color: Theme.of(popupContext).colorScheme.primary,
                          ),
                      ],
                    );
                  }

                  return [
                    PopupMenuItem<Locale?>(
                      value: null, // Represents system default
                      child: buildCheckedItem(
                        consumerS.languageSystem,
                        currentLocale == null,
                      ),
                      onTap: () {
                        appProviderForActions.setLocale(null);
                      },
                    ),
                    ...AppLocalizations.supportedLocales.map((locale) {
                      return PopupMenuItem<Locale?>(
                        value: locale,
                        child: buildCheckedItem(
                          _getLanguageName(context, locale),
                          currentLocale == locale,
                        ),
                      );
                    }),
                  ];
                },
              );
            },
          ),
          Consumer<AppProvider>(
            builder: (context, appProvider, _) {
              final consumerS = AppLocalizations.of(context)!;
              return PopupMenuButton<AppColorSeed>(
                icon: const Icon(Icons.palette_outlined),
                tooltip: consumerS.tooltipSelectThemeColor,
                onSelected: (AppColorSeed selectedSeed) {
                  appProviderForActions.setAppSeedColor(selectedSeed);
                },
                itemBuilder: (BuildContext popupContext) {
                  return AppColorSeed.values.map((AppColorSeed seed) {
                    return PopupMenuItem<AppColorSeed>(
                      value: seed,
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: seed.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(
                                  popupContext,
                                ).dividerColor.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(seed.label),
                          if (seed == appProvider.appSeedColor) ...[
                            const Spacer(),
                            Icon(
                              Icons.check,
                              color: Theme.of(popupContext).colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList();
                },
              );
            },
          ),
          Consumer<AppProvider>(
            builder: (context, appProvider, _) {
              return IconButton(
                icon: Icon(_getBrightnessIcon(appProvider.themeMode)),
                tooltip: _getBrightnessTooltip(context, appProvider.themeMode),
                onPressed: () {
                  ThemeMode nextMode;
                  switch (appProvider.themeMode) {
                    case ThemeMode.light:
                      nextMode = ThemeMode.dark;
                      break;
                    case ThemeMode.dark:
                      nextMode = ThemeMode.system;
                      break;
                    case ThemeMode.system:
                      nextMode = ThemeMode.light;
                      break;
                  }
                  appProviderForActions.setThemeMode(nextMode);
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildCountdownDisplay(isTimerActive),
              const SizedBox(height: 40),
              _buildCustomInputSection(),
              const SizedBox(height: 20),
              _buildPresetButtons(),
              const SizedBox(height: 40),
              if (isTimerActive) _buildCancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownDisplay(bool isTimerActive) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: isTimerActive
          ? Column(
              key: const ValueKey('timer_active'),
              children: [
                Text(
                  S.countdownLabel,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDuration(_remainingTime),
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            )
          : Column(
              key: const ValueKey('timer_inactive'),
              children: [
                Icon(
                  Icons.power_settings_new_rounded,
                  size: 60,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  S.noTaskSetLabel,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCustomInputSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _customTimeController,
            decoration: InputDecoration(
              hintText: S.customTimeHint,
              labelText: S.customTimeLabel,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.arrow_forward_rounded),
          iconSize: 28,
          style: IconButton.styleFrom(padding: const EdgeInsets.all(16)),
          onPressed: () {
            final duration = _parseDuration(_customTimeController.text);
            if (duration != null) {
              _setShutdown(duration);
              _customTimeController.clear();
            } else {
              _showToast(S.toastTimeFormatError, isError: true);
            }
          },
        ),
      ],
    );
  }

  Widget _buildPresetButtons() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.quickPresetsLabel,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: [
            ..._presets.map((duration) {
              final button = ElevatedButton(
                onPressed: () => _setShutdown(duration),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: Text(_formatDurationToText(context, duration)),
              );
              return GestureDetector(
                onLongPress: () {
                  _showDeletePresetConfirmDialog(duration);
                },
                child: button,
              );
            }),
            IconButton(
              onPressed: _showAddPresetDialog,
              icon: Icon(Icons.add, color: theme.colorScheme.primary),
              tooltip: S.tooltipAddPreset,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerLowest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      height: 50,
      child: FilledButton.tonal(
        onPressed: _cancelShutdown,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red.shade100.withOpacity(
            Theme.of(context).brightness == Brightness.dark ? 0.3 : 1.0,
          ),
          foregroundColor: Colors.red.shade800,
        ),
        child: Text(
          S.cancelShutdownTaskButton,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
