import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_tests/main.dart' as app;


// run code in your terminal:
// flutter drive --target=test_driver/test_dash_driver/dash_app.dart
void main() {
  enableFlutterDriverExtension();

  app.main();
}
