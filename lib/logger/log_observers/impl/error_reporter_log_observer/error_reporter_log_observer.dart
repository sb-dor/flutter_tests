import 'package:flutter_tests/logger/error_reporter/error_reporter.dart';
import 'package:flutter_tests/logger/log_observers/log_observer.dart';
import 'package:flutter_tests/logger/logger.dart';

final class ErrorReporterLogObserver implements LogObserver {
  final ErrorReporter _errorReporter;

  ErrorReporterLogObserver(this._errorReporter);

  @override
  void onLog(LogMessage logMessage) {
    if (!_errorReporter.isInitialized) return;

    if (logMessage.logLevel.index >= LogLevel.error.index) {
      _errorReporter.captureException(
        throwable: logMessage.error ?? ReportedMessageException(logMessage.message),
        stackTrace: logMessage.stackTrace ?? StackTrace.current,
      );
    }
  }
}

class ReportedMessageException implements Exception {
  /// Constructs an instance of [ReportedMessageException].
  const ReportedMessageException(this.message);

  /// The message that was reported.
  final String message;

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportedMessageException && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
