import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_tests/add_to_cart_test/feature/initialization/logic/app_runner.dart';
import 'package:flutter_tests/dash_test/dash_page.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';
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
void main() {
  AppRunner().initApp();
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
