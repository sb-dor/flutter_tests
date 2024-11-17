import 'package:flutter/material.dart';

class MaterialContext extends StatelessWidget {
  final Widget child;

  const MaterialContext({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
    );
  }
}
