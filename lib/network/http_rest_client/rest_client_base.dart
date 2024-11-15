import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'rest_client.dart';

abstract base class RestClientBase implements RestClient {
  final Uri baseUrl;

  RestClientBase({required String url}) : baseUrl = Uri.parse(url);

  final _jsonUTF8 = json.fuse(utf8);

  /// Sends a request to the server
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  });

  @override
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) =>
      send(
        path: path,
        method: "GET",
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) =>
      send(
        path: path,
        method: "POST",
        body: body,
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) =>
      send(
        path: path,
        method: "PUT",
        body: body,
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) =>
      send(
        path: path,
        method: "DELETE",
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
        method: "PATCH",
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
        StringResponseBody(:final String data) => await _decodeString(data),
        MapResponseBody(:final Map<String, Object?> data) => data,
        BytesResponseBody(:final List<int> data) => _decodeBytes(data),
      };

      if (decodeBody case {"error": final Map<String, Object?> error}) {
        // TODO: write en error exception
      }

      //
    } on Object catch (e, trace) {
      // TODO: write en error exception
      // write exceptions in the future
      // when you will get what is goint on here
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
        debugLabel: kDebugMode ? "Decode bytes compute" : null,
      )) as Map<String, Object?>;
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
