// Logger class, that manages the logging of messages
import 'package:flutter/foundation.dart';
import 'package:flutter_tests/logger/log_observers/log_observer.dart';
import 'package:clock/clock.dart';

base class AppLogger extends Logger {
  final List<LogObserver> _observers;

  AppLogger(this._observers);

  bool _destroyed = false;

  bool get destroyed => _destroyed;

  @override
  void destroy() {
    _destroyed = true;
  }

  @override
  void log(
    String message, {
    required LogLevel logLevel,
    Object? error,
    StackTrace? stackTrace,
    bool printStackTrace = true,
    bool printError = true,
  }) {
    if (_destroyed || _observers.isEmpty) return;

    final logMessage = LogMessage(
      message: message,
      logLevel: logLevel,
      error: error,
      stackTrace: stackTrace,
      dateTime: clock.now(),
    );

    for (final each in _observers) {
      each.onLog(logMessage);
    }
  }
}

// it's just a abstract class that doesn't have log implementation
// but has other function that extender class should have
// all classes that extend this class will implement only destroy() and log() methods
abstract base class Logger {
  // Destroys the logger and releases all resources
  // After calling this method, the logger should not be used anymore.
  void destroy();

  void log(
    String message, {
    required LogLevel logLevel,
    Object? error,
    StackTrace? stackTrace,
    bool printStackTrace = true,
    bool printError = true,
  });

  void logFlutterError(FlutterErrorDetails details) {
    log(
      details.summary.toString(),
      logLevel: LogLevel.error,
      error: details.exception,
      stackTrace: details.stack,
      printStackTrace: false,
      printError: false,
    );
  }

  void trace(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool printStackTrace = true,
    bool printError = true,
  }) {
    log(
      message,
      logLevel: LogLevel.trace,
      error: error,
      stackTrace: stackTrace,
      printStackTrace: printStackTrace,
      printError: printError,
    );
  }

  void debug(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        logLevel: LogLevel.debug,
        error: error,
        stackTrace: stackTrace,
        printStackTrace: printStackTrace,
        printError: printError,
      );

  void info(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        logLevel: LogLevel.info,
        error: error,
        stackTrace: stackTrace,
        printStackTrace: printStackTrace,
        printError: printError,
      );

  void warn(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        logLevel: LogLevel.warn,
        error: error,
        stackTrace: stackTrace,
        printStackTrace: printStackTrace,
        printError: printError,
      );

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        logLevel: LogLevel.error,
        error: error,
        stackTrace: stackTrace,
        printStackTrace: printStackTrace,
        printError: printError,
      );

  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        logLevel: LogLevel.fatal,
        error: error,
        stackTrace: stackTrace,
        printStackTrace: printStackTrace,
        printError: printError,
      );
}

enum LogLevel implements Comparable<LogLevel> {
  /// A log level describing events showing step by step execution of your code
  /// that can be ignored during the standard operation,
  /// but may be useful during extended debugging sessions.
  trace._(),
  //
  // /// A log level used for events considered to be useful during software
  // /// debugging when more granular information is needed.
  debug._(),
  //
  // /// An event happened, the event is purely informative
  // /// and can be ignored during normal operations.
  info._(),
  //
  // /// Unexpected behavior happened inside the application, but it is continuing
  // /// its work and the key business features are operating as expected.
  warn._(),
  //
  // /// One or more functionalities are not working,
  // /// preventing some functionalities from working correctly.
  // /// For example, a network request failed, a file is missing, etc.
  error._(),
  //
  // /// One or more key business functionalities are not working
  // /// and the whole system doesn’t fulfill the business functionalities.
  fatal._();

  //
  const LogLevel._();

  //
  @override
  int compareTo(LogLevel other) => index - other.index;

  //
  /// Return short name of the log level.
  String toShortName() => switch (this) {
        LogLevel.trace => 'TRC',
        LogLevel.debug => 'DBG',
        LogLevel.info => 'INF',
        LogLevel.warn => 'WRN',
        LogLevel.error => 'ERR',
        LogLevel.fatal => 'FTL',
      };
}

// Represents a single log message with various details
// for debugging and information purposes.
class LogMessage {
  final String message;

  final LogLevel logLevel;

  final DateTime dateTime;

  final Object? error;

  final StackTrace? stackTrace;

  /// Constructs an instance of [LogMessage].
  ///
  /// - [message]: The main content of the log message.
  /// - [level]: The severity level of the log message,
  ///   represented by [LogLevel].
  /// - [timestamp]: The date and time when the log message was created.
  /// - [error]: Optional. Any error object associated with the log message.
  /// - [stackTrace]: Optional. The stack trace associated with the log message,
  ///   typically provided when logging errors.
  const LogMessage({
    required this.message,
    required this.logLevel,
    required this.dateTime,
    this.error,
    this.stackTrace,
  });
}
