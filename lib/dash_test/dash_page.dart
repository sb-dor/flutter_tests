import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class DashAssets {
  static const dashBlueImage = "assets/dashes/dash_blue.png";
  static const dashGreenImage = "assets/dashes/dash_green.png";
}

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("Dash app"),
        ),
      ),
    );
  }
}
