abstract interface class RestClient {
  //
  /// sends a get request to the given [path]
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });

  /// sends a post request to the given [path]
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  });

  /// sends a post request to the given [path]
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  });

  /// sends a delete request to the given [path]
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });

  /// sends a patch request to the given [path]
  Future<Map<String, Object?>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });
}
