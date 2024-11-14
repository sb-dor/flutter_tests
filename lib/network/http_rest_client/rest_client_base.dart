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
