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
    List<http.MultipartFile>? files,
  }) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);

      late http.BaseRequest request;

      // Check if files are included, and use MultipartRequest if needed
      if (files != null && files.isNotEmpty) {
        final multipartRequest = http.MultipartRequest(method.name, uri);

        // Add files to the multipart request
        // file's name will be added with it's field which you added from http.MultipartFile
        // take a look inside network/http_rest_client/repository_test.dart
        multipartRequest.files.addAll(files);

        // Add headers if provided
        if (headers != null) {
          multipartRequest.headers.addAll(headers);
        }

        // Add other fields in the body to the multipart request
        if (body != null) {
          body.forEach((key, value) {
            multipartRequest.fields[key] = value.toString();
          });
        }

        request = multipartRequest;
      } else {
        // Fallback to regular Request for non-multipart data
        final regularRequest = http.Request(method.name, uri);

        if (body != null) {
          regularRequest.bodyBytes = encodeBody(body);
          regularRequest.headers['content-type'] = 'application/json;charset=utf-8';
        }

        if (headers != null) {
          regularRequest.headers.addAll(headers);
        }

        request = regularRequest;
      }

      final response = await _client.send(request);

      final responseStream = await http.Response.fromStream(response);

      // Log the server's response body
      debugPrint("body is: ${responseStream.body}");

      return await decodeResponse(
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
