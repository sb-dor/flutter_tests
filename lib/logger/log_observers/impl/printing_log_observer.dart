import 'package:flutter_tests/logger/log_observers/log_observer.dart';
import 'package:flutter_tests/logger/logger.dart';
import 'dart:developer' as dev;

class PrintingLogObserver implements LogObserver {
  final LogLevel logLevel;

  PrintingLogObserver(this.logLevel);

  @override
  void onLog(LogMessage logMessage) {
    if (logMessage.logLevel.index >= logLevel.index) {
      final logLevelsLength = LogLevel.values.length;
      final severityPerLevel = 2000 ~/ logLevelsLength;
      final level = logMessage.logLevel.index * severityPerLevel;

      dev.log(
        logMessage.message,
        time: logMessage.dateTime,
        error: logMessage.error,
        stackTrace: logMessage.stackTrace,
        level: level,
        name: logMessage.logLevel.toShortName(),
      );
    }
  }
}
