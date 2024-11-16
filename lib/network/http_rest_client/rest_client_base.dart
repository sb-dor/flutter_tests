import 'dart:convert';
import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'rest_client.dart';
import 'package:http/http.dart' as http;

enum RequestType { GET, POST, PUT, DELETE, PATCH }

// this abstract class, it will not be used, only for implementation and for testing
// classes that implementing this class will be used
abstract base class RestClientBase implements RestClient {
  final Uri baseUrl;

  RestClientBase({required String baseUrl}) : baseUrl = Uri.parse(baseUrl);

  final _jsonUTF8 = json.fuse(utf8);

  /// Sends a request to the server
  /// if you want to use this, you have to directly send the type of send function
  /// better use function below this function -> [get], [post], [put], [delete], [patch] <-
  Future<Map<String, Object?>?> send({
    required String path,
    required RequestType method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    List<http.MultipartFile>? files,
  });

  @override
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) =>
      send(
        path: path,
        method: RequestType.GET,
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    List<http.MultipartFile>? files,
  }) =>
      send(
        path: path,
        method: RequestType.POST,
        body: body,
        headers: headers,
        queryParams: queryParams,
        files: files,
      );

  @override
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    List<http.MultipartFile>? files,
  }) =>
      send(
        path: path,
        method: RequestType.PUT,
        body: body,
        headers: headers,
        queryParams: queryParams,
        files: files,
      );

  @override
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) =>
      send(
        path: path,
        method: RequestType.DELETE,
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) =>
      send(
        path: path,
        method: RequestType.PATCH,
        body: body,
        headers: headers,
        queryParams: queryParams,
      );

  /// Builds [Uri] from [path], [queryParams] and [baseUri]
  @protected
  @visibleForTesting
  Uri buildUri({required String path, Map<String, String?>? queryParams}) {
    final finalPath = p.join(baseUrl.path, path);
    // Creates a new Uri based on this one, but with some parts replaced.
    // This method takes the same parameters as the Uri constructor, and they have the same meaning
    return baseUrl.replace(
      path: finalPath,
      // get original queryParameters and also sending queryParams if it exists
      queryParameters: {...baseUrl.queryParameters, ...?queryParams},
    );
  }

  //
  @protected
  @visibleForTesting
  Future<Map<String, Object?>?> decodeResponse(
    ResponseBody<Object>? body, {
    int? statusCode,
  }) async {
    if (body == null) return null;
    try {
      // ResponseBody class has "data" field, and that is why every -> :final Type data <- should be called "data"
      // you can name "data" whatever you want
      final decodeBody = switch (body) {
        MapResponseBody(:final Map<String, Object?> data) => data,
        StringResponseBody(:final String data) => await _decodeString(data),
        BytesResponseBody(:final List<int> data) => await _decodeBytes(data),
      };

      // if server is sending "error" data you have to deal with it
      // you can write your own error like -> "success" : false
      // doesn't matter
      if (decodeBody case {"error": final Map<String, Object?> error}) {
        // TODO: write en error exception
        throw StructuredBackendException(
          error: error,
          statusCode: statusCode,
        );
      }

      // this code also checks whether everything went great in server
      // you can write your own logic like -> "success" : true
      if (decodeBody case {"data": final Map<String, Object?> data}) {
        return data;
      }

      // does not matter what you are sending
      //
      return decodeBody;

      //
    } on RestClientException {
      rethrow;
    } on Object catch (e, trace) {
      debugPrint("converting error is: $e");
      // TODO: write en error exception
      // write exceptions in the future
      // when you will get what is going on here
      Error.throwWithStackTrace(
        ClientException(
          message: 'Error occurred during decoding',
          statusCode: statusCode,
          cause: e,
        ),
        trace,
      );
    }
  }

  /// encodes [body] to JSON and then to UTF8
  @protected
  @visibleForTesting
  List<int> encodeBody(Map<String, Object?> body) {
    try {
      return _jsonUTF8.encode(body);
    } on Object catch (e, sTrace) {
      throw Error(); // temp
      // TODO: write en error exception
      // write exceptions in the future
      // when you will get what is going on here
    }
  }

  /// Decodes a [String] to a [Map<String, Object?>]
  Future<Map<String, Object?>?> _decodeString(String stringBody) async {
    if (stringBody.isEmpty) return null;

    // run in another isolate in order to convert string into Map
    if (stringBody.length > 1000) {
      return (await compute(
        jsonDecode,
        stringBody,
        debugLabel: kDebugMode ? "Decode String compute" : null,
      )) as Map<String, Object?>;
    }

    return jsonDecode(stringBody) as Map<String, Object?>;
  }

  /// Decodes a [List<int>] to a [Map<String, Object?>]
  Future<Map<String, Object?>?> _decodeBytes(List<int> bytesBody) async {
    if (bytesBody.isEmpty) return null;

    // run in another isolate in order to convert bytes into Map
    if (bytesBody.length > 1000) {
      return (await compute(
        _jsonUTF8.decode,
        bytesBody,
        debugLabel: kDebugMode ? 'Decode Bytes Compute' : null,
      ))! as Map<String, Object?>;
    }

    return _jsonUTF8.decode(bytesBody) as Map<String, Object?>;
  }
}

// A sealed class representing the response body
@immutable
sealed class ResponseBody<T> {
  final T data;

  const ResponseBody(this.data);
}

class StringResponseBody extends ResponseBody<String> {
  const StringResponseBody(super.data);
}

class MapResponseBody extends ResponseBody<Map<String, Object?>> {
  const MapResponseBody(super.data);
}

class BytesResponseBody extends ResponseBody<List<int>> {
  const BytesResponseBody(super.data);
}
