import 'package:flutter_tests/network/http_rest_client/http/rest_client_http.dart';
import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:http/http.dart' as http;

abstract interface class IPostDatasource {
  Future<bool> savePost(Map<String, Object?> postData);

  Future<void> addText();
}

class PostDatasourceImpl implements IPostDatasource {
  static const _baseUrl = "localUrl";
  final _testEndPoint = 'testUrl';

  final RestClientBase _restClientBase;

  PostDatasourceImpl(http.Client client)
      : _restClientBase = RestClientHttp(
          baseUrl: _baseUrl,
          client: client,
        );

  @override
  Future<bool> savePost(Map<String, Object?> postData) async {
    try {
      await Future.delayed(const Duration(seconds: 3));

      final data = await _restClientBase.post(
        _testEndPoint,
        body: postData,
      );

      if (data != null && data.containsKey('success') && data['success'] is bool) {
        return data['success'] as bool;
      }

      return false;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const WrongResponseTypeException(message: "Wrong response from server"),
        stackTrace,
      );
    }
  }

  @override
  Future<void> addText() async {
    try {
      await Future.delayed(const Duration(seconds: 5));
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const WrongResponseTypeException(message: "Wrong response from server"),
        stackTrace,
      );
    }
  }
}
