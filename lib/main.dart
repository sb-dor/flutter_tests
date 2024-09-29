import 'package:flutter/material.dart';
import 'package:flutter_tests/dash_test/dash_page.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';
import 'package:flutter_tests/todo_test/todo_page.dart';
import 'package:flutter_tests/todo_test/todo_provider.dart';
import 'package:provider/provider.dart';

import 'favorites_test/screens/favorites_home_page.dart';
import 'listview_scroll_test/listview_scroll_test.dart';

// https://docs.flutter.dev/testing/overview
// https://docs.flutter.dev/cookbook/testing/widget/finders
// https://docs.flutter.dev/cookbook/testing/widget/scrolling
// https://docs.flutter.dev/cookbook/testing/widget/tap-drag
// https://docs.flutter.dev/testing/integration-tests
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Favorites>(
          create: (_) => Favorites(),
        ),
        ChangeNotifierProvider<TodoProvider>(
          create: (_) => TodoProvider(),
        ),
      ],
      child: MaterialApp(
        home: const TodoPage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
      ),
    ),
  );
}
