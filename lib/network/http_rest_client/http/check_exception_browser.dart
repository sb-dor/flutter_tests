import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:http/http.dart' as http;

// coverage:ignore-start
/// Checks the [http.ClientException] and tries to parse it.
Object? checkHttpException(http.ClientException e) {
  if (e.message.contains('XMLHttpRequest error')) {
    return ConnectionException(message: e.message, cause: e);
  }

  return null;
}
// coverage:ignore-end