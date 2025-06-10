import 'dart:io';
import 'package:process_run/shell.dart';

class ShutdownService {
  final _shell = Shell();

  // 设置定时关机
  Future<void> setShutdown(Duration duration) async {
    try {
      if (Platform.isWindows) {
        // Windows: shutdown /s /t 秒数
        await _shell.run('shutdown /s /t ${duration.inSeconds}');
      } else if (Platform.isMacOS || Platform.isLinux) {
        // macOS/Linux: sudo shutdown -h +分钟数
        // 注意：在 macOS/Linux 上需要 sudo 权限！
        // 你可能需要以 sudo 权限运行此应用，或者配置免密 sudo。
        final minutes = (duration.inSeconds / 60).ceil();
        await _shell.run('sudo shutdown -h +$minutes');
      }
    } catch (e) {
      print('设置关机失败: $e');
      // 可以在这里向用户显示一个错误提示
      rethrow;
    }
  }

  // 取消定时关机
  Future<void> cancelShutdown() async {
    try {
      if (Platform.isWindows) {
        // Windows: shutdown /a
        await _shell.run('shutdown /a');
      } else if (Platform.isMacOS || Platform.isLinux) {
        // macOS/Linux: sudo shutdown -c
        await _shell.run('sudo shutdown -c');
      }
    } catch (e) {
      print('取消关机失败: $e');
      // 可以在这里向用户显示一个错误提示
      rethrow;
    }
  }
}
