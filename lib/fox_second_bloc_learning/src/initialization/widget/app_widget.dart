import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  final Widget screen;

  const AppWidget({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: screen,
    );
  }
}
