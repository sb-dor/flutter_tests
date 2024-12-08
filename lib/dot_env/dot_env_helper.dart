import 'package:flutter_dotenv/flutter_dotenv.dart';

final class DotEnvHelper {
  static DotEnvHelper? _internal;

  static DotEnvHelper get internal => _internal ??= DotEnvHelper._();

  DotEnvHelper._();

  late DotEnv _dotEnv;

  DotEnv get dotEnv => _dotEnv;

  Future<void> init() async {
    _dotEnv = DotEnv();
    await _dotEnv.load(fileName: ".env");
  }
}
