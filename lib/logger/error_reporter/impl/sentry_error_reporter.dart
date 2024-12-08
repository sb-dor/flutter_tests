import 'package:flutter_tests/dot_env/dot_env_helper.dart';
import 'package:flutter_tests/logger/error_reporter/error_reporter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryErrorReporter implements ErrorReporter {
  @override
  Future<void> captureException({
    required Object throwable,
    StackTrace? stackTrace,
  }) async {
    await Sentry.captureException(throwable, stackTrace: stackTrace);
  }

  @override
  Future<void> close() async {
    await Sentry.close();
  }

  @override
  Future<void> init() async {
    await SentryFlutter.init((options) {
      options.dsn = DotEnvHelper.internal.dotEnv.get("DSN");
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    });
  }

  @override
  // TODO: implement isInitialized
  bool get isInitialized => Sentry.isEnabled;
}
