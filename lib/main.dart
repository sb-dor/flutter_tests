import 'package:flutter/material.dart';
import 'package:flutter_tests/dash_test/dash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: DashPage(),
    ),
  );
}
