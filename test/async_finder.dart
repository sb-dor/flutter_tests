import 'package:flutter_test/flutter_test.dart';

Future<Finder> asyncFinder({
  required WidgetTester tester,
  required Finder Function() finder,
  Duration limit = const Duration(milliseconds: 15000),
}) async {
  final stopWatch = Stopwatch()..start();
  try {
    var result = finder();
    while (stopWatch.elapsed <= limit) {
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      result = finder();
      if (result.evaluate().isNotEmpty) return result;
    }
    return result;
  } on Object catch (error, stackTrace) {
    //
    rethrow;
  } finally {
    stopWatch.stop();
  }
}

Future<Finder> syncFinder({
  required WidgetTester tester,
  required Finder Function() finder,
  Duration limit = const Duration(milliseconds: 15000),
}) async {
  final stopWatch = Stopwatch()..start();
  try {
    var result = finder();
    while (stopWatch.elapsed <= limit) {
      await tester.pump(const Duration(milliseconds: 100));
      result = finder();
      if (result.evaluate().isNotEmpty) return result;
    }
    return result;
  } on Object catch (error, stackTrace) {
    //
    rethrow;
  } finally {
    stopWatch.stop();
  }
}
