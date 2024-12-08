import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tests/add_to_cart_test/feature/initialization/logic/app_runner.dart';
import 'package:flutter_tests/dash_test/dash_page.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';
import 'package:flutter_tests/logger/error_reporter/error_reporter.dart';
import 'package:flutter_tests/logger/error_reporter/impl/sentry_error_reporter.dart';
import 'package:flutter_tests/logger/log_observers/impl/error_reporter_log_observer/error_reporter_log_observer.dart';
import 'package:flutter_tests/logger/log_observers/impl/printing_observer/printing_log_observer.dart';
import 'package:flutter_tests/logger/logger.dart';
import 'package:flutter_tests/todo_test/todo_page.dart';
import 'package:flutter_tests/todo_test/todo_provider.dart';
import 'package:provider/provider.dart';

import 'favorites_test/screens/favorites_home_page.dart';
import 'listview_scroll_test/listview_scroll_test.dart';
import 'network/network_test_page.dart';

// https://docs.flutter.dev/testing/overview
// https://docs.flutter.dev/cookbook/testing/widget/finders
// https://docs.flutter.dev/cookbook/testing/widget/scrolling
// https://docs.flutter.dev/cookbook/testing/widget/tap-drag
// https://docs.flutter.dev/testing/integration-tests
void main() async {
  List<UsableItem> items = [
    Weapon(1, "Weapn desc", "sword"),
    Armor(1, "Armor desc", "Armor"),
    // Grass(1, "Grass desc", "Grass"),
  ];

  final ErrorReporter sentryReporter = SentryErrorReporter();
  await sentryReporter.init();
  final logger = AppLogger(
    [
      ErrorReporterLogObserver(sentryReporter),
      if (kDebugMode) PrintingLogObserver(LogLevel.trace),
    ],
  );

  for (final each in items) {
    each.use();
  }
  // AppRunner().initApp();
  // runZonedGuarded(
  //   () {
  //     WidgetsFlutterBinding.ensureInitialized();
  //     runApp(
  //       MultiProvider(
  //         providers: [
  //           ChangeNotifierProvider<Favorites>(
  //             create: (_) => Favorites(),
  //           ),
  //           ChangeNotifierProvider<TodoProvider>(
  //             create: (_) => TodoProvider(),
  //           ),
  //         ],
  //         child: MaterialApp(
  //           home: const NetworkTestPage(),
  //           theme: ThemeData(
  //             colorScheme: ColorScheme.fromSeed(
  //               seedColor: Colors.deepPurple,
  //             ),
  //             useMaterial3: true,
  //           ),
  //         ),
  //       ),
  //     );
  //   },
  //   (error, sTrace) {
  //     debugPrint("error is $error | trace: $sTrace");
  //     // debug error
  //   },
  // );
}

abstract class Item {
  int id;
  String? desc;
  String? name;

  Item(this.id, this.desc, this.name);

  String description();
}

abstract class UsableItem {
  void use();
}

class Weapon extends Item implements UsableItem {
  Weapon(super.id, super.desc, super.name);

  @override
  String description() => "$desc";

  @override
  void use() => debugPrint("using -> $name");
}

class Armor extends Item implements UsableItem {
  Armor(super.id, super.desc, super.name);

  @override
  String description() => "$desc";

  @override
  void use() => debugPrint("using -> $name");
}

class Grass extends Item {
  Grass(super.id, super.desc, super.name);

  @override
  String description() => "$desc";
}
