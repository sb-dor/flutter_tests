import 'package:flutter/cupertino.dart';
import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:http/http.dart' as http;

/// conditional import in Dart
/// indicates that the Dart code is being compiled to run in a JavaScript environment
///
///   •	If the condition is false (e.g., running on mobile/desktop):
/// 	•	Only check_exception_io.dart is imported.
/// 	•	The check_exception_browser.dart file is completely ignored.
///  	•	If the condition is true (e.g., running on the web with JavaScript interop enabled):
/// 	•	Only check_exception_browser.dart is imported.
/// 	•	The check_exception_io.dart file is completely ignored.
///
import 'package:flutter_tests/network/http_rest_client/http/check_exception_io.dart'
    if (dart.library.js_interop) 'package:flutter_tests/network/http_rest_client/http/check_exception_browser.dart';

// RestClientHttp is class that extends RestClientBase
// "RestClientBase" is not using anywhere, it's just a abstract class that other classes should extend
// implementations will be used only
final class RestClientHttp extends RestClientBase {
  // you can not pass client if you want
  RestClientHttp({
    required super.baseUrl,
    http.Client? client, // you don't have to send client, uses for tests most of all
  }) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required RequestType method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);
      final request = http.Request(method.name, uri);

      if (body != null) {
        request.bodyBytes = encodeBody(body);
        request.headers['content-type'] = 'application/json;charset=utf-8';
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await _client.send(request);

      final responseStream = await http.Response.fromStream(response);

      // see what's sending server here
      // all server messages, this kinda things
      debugPrint("body is: ${responseStream.body}");

      return await decodeResponse(
        // leave StringBodyResponse for the start (it shows server errors)
        // when you finish requesting to the server
        // change it to BytesResponseBody if you want

        /// It’s better to convert through bytes and [UTF-8];
        /// otherwise, you might encounter something like ‘unknown character code.’, "\" <- like this one
        BytesResponseBody(responseStream.bodyBytes),
        statusCode: response.statusCode,
      );
    } on RestClientException {
      rethrow;
    } on http.ClientException catch (e, stack) {
      debugPrint("error is: $e");
      // TODO: write en error exception
      // write exceptions in the future
      // when you will get what is going on here
      final checkException = checkHttpException(e);

      if (checkException != null) {
        Error.throwWithStackTrace(checkException, stack);
      }

      Error.throwWithStackTrace(
        ClientException(message: e.message, cause: e),
        stack,
      );
    }
  }
}
