import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️ [EcoSwap INFO]: $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('⚠️ [EcoSwap WARNING]: $message');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('🚨 [EcoSwap ERROR]: $message');
      if (error != null) debugPrint('Error detail: $error');
      if (stackTrace != null) debugPrint(stackTrace.toString());
    }
  }
}
