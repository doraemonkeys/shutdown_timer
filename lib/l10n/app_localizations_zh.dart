// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '定时关机小助手';

  @override
  String get toastSetTimeGreaterThanZero => '设置的时间必须大于0秒';

  @override
  String get toastUnsupportedOS => '不支持的操作系统';

  @override
  String get toastShutdownSetSuccess => '定时关机设置成功！';

  @override
  String get toastShutdownSetFailed => '设置失败! 可能是权限不足 (可尝试用管理员身份运行本程序)';

  @override
  String get toastShutdownCancelled => '已取消定时关机';

  @override
  String get toastCancelFailed => '取消失败! 可能没有正在执行的关机任务。';

  @override
  String durationHours(int count) {
    return '$count小时';
  }

  @override
  String durationMinutes(int count) {
    return '$count分钟';
  }

  @override
  String durationSeconds(int count) {
    return '$count秒';
  }

  @override
  String get addPresetDialogTitle => '添加自定义预设';

  @override
  String get addPresetDialogLabel => '时间 (例如: 45m, 1h30m)';

  @override
  String get cancelButton => '取消';

  @override
  String get confirmButton => '确认';

  @override
  String get toastPresetAddedSuccess => '预设添加成功';

  @override
  String get toastPresetFormatError => '格式错误!';

  @override
  String get toastPresetExistsError => '预设已存在!';

  @override
  String get deletePresetDialogTitle => '删除预设';

  @override
  String deletePresetDialogContent(String presetName) {
    return '确定要删除预设 \'$presetName\' 吗?';
  }

  @override
  String get deleteButton => '删除';

  @override
  String toastPresetDeleted(String presetName) {
    return '预设 \'$presetName\' 已删除';
  }

  @override
  String get tooltipToggleDark => '切换到深色模式';

  @override
  String get tooltipToggleSystem => '切换到系统模式';

  @override
  String get tooltipToggleLight => '切换到浅色模式';

  @override
  String get tooltipSelectThemeColor => '选择主题颜色';

  @override
  String get countdownLabel => '距离关机还有';

  @override
  String get noTaskSetLabel => '未设置关机任务';

  @override
  String get customTimeHint => '自定义时间, 如: 1h30m';

  @override
  String get customTimeLabel => '自定义';

  @override
  String get toastTimeFormatError =>
      '时间格式不正确！\n请使用如 \'1h\', \'30m\', \'10s\' 的格式';

  @override
  String get quickPresetsLabel => '快速预设';

  @override
  String get tooltipAddPreset => '添加预设';

  @override
  String get cancelShutdownTaskButton => '取消关机任务';

  @override
  String get tooltipSelectLanguage => '选择语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChineseSimplified => '简体中文';
}
