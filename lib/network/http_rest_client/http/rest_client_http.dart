import 'package:flutter/cupertino.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:http/http.dart' as http;

final class RestClientHttp extends RestClientBase {
  // you can not pass client if you want
  RestClientHttp({required super.baseUrl, http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) async {
    // try {
      final uri = buildUri(path: path, queryParams: queryParams);
      final request = http.Request(method, uri);

      if (body != null) {
        request.bodyBytes = encodeBody(body);
        request.headers['content-type'] = 'application/json;charset=utf-8';
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await _client.send(request);

      final responseStream = await http.Response.fromStream(response);
      return await decodeResponse(
        BytesResponseBody(responseStream.bodyBytes),
        statusCode: response.statusCode,
      );
    // } catch (e) {
    //   debugPrint("error is: $e");
    //   // TODO: write en error exception
    //   // write exceptions in the future
    //   // when you will get what is going on here
    // }
  }
}
