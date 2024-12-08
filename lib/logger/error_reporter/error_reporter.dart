abstract interface class ErrorReporter {
  bool get isInitialized;

  Future<void> init();

  Future<void> close();

  Future<void> captureException({
    required Object throwable,
    StackTrace? stackTrace,
  });
}
