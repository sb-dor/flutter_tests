import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/main.dart' as app;
import 'package:integration_test/integration_test.dart';

// run code in your terminal:
// flutter drive --target=test_driver/test_dash_driver/app_test.dart
void main() {
  // The ensureInitialized() function verifies if the integration test driver is initialized,
  // reinitializing it if required.
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Setting framePolicy to fullyLive is good for testing animated code.

  // https://codelabs.developers.google.com/codelabs/flutter-app-testing?en=ru&hl=en#7
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  app.main();
}
