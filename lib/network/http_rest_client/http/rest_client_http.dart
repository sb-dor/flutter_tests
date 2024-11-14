import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:http/http.dart' as http;

final class RestClientHttp extends RestClientBase {
  // you can not pass client if you want
  RestClientHttp({required super.url, http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) {
    final uri = buildUri(path: path, queryParams: queryParams);
    final request = http.Request(method, uri);

    if (body != null) {
      // request.bodyBytes =
    }
  }
}
