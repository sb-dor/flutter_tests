import 'package:flutter/cupertino.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/models/user_entity.dart';
import 'package:flutter_tests/network/http_rest_client/http/rest_client_http.dart';
import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:http/http.dart' as http;

abstract interface class IAuthenticationDatasource {
  Future<AuthenticatedUser?> login({
    required final String email,
    required final String password,
  });

  Future<bool> logout();

  Future<AuthenticatedUser?> checkAuth();
}

class AuthenticationDatasourceImpl implements IAuthenticationDatasource {
  final _baseUrl = "localUrl";
  final _testEndPoint = 'testUrl';

  // I will not use this client anywhere
  final http.Client _client;

  // For test purpose only!
  // I want to show to myself how to properly test
  // http request and mock them in the future
  AuthenticationDatasourceImpl(this._client);

  @override
  Future<AuthenticatedUser?> login({
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final RestClientBase restClient = RestClientHttp(
        baseUrl: _baseUrl,
        client: _client,
      );

      final data = await restClient.get(_testEndPoint);

      return AuthenticatedUser.fromJson(data?['user'] as Map<String, Object?>);
    } on TypeError catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const WrongResponseTypeException(message: 'Something went wrong'),
        stackTrace,
      );
    } on UnimplementedError catch (error, stackTrace) {
      // your own exceptions
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final RestClientBase restClientBase = RestClientHttp(
        baseUrl: _baseUrl,
        client: _client,
      );

      final data = await restClientBase.get(_testEndPoint);

      if (data != null && data.containsKey('success') && data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } on TypeError catch (error, stackTrace) {
      Error.throwWithStackTrace(
        WrongResponseTypeException(message: "Server responding with wrong type", cause: error),
        stackTrace,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<AuthenticatedUser?> checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));

    final RestClientBase restClientBase = RestClientHttp(baseUrl: _baseUrl, client: _client);

    final json = await restClientBase.get(_testEndPoint);

    if (json != null && json.containsKey('user') && json['user'] != null) {
      return AuthenticatedUser.fromJson(json['user'] as Map<String, Object?>);
    }

    return null;
  }
}
