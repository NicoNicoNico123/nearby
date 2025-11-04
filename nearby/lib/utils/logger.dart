import 'dart:developer' as developer;

class Logger {
  static void debug(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'Nearby',
      level: 500, // Level for debug
    );
  }

  static void info(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'Nearby',
      level: 800, // Level for info
    );
  }

  static void warning(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'Nearby',
      level: 900, // Level for warning
    );
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: tag ?? 'Nearby',
      level: 1000, // Level for error
      error: error,
      stackTrace: stackTrace,
    );
  }
}