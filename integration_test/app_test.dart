import 'package:flutter_tests/main.dart' as app;
import 'package:integration_test/integration_test.dart';

// run code in your terminal:
// flutter drive --target=test_driver/test_dash_driver/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  app.main();
}
