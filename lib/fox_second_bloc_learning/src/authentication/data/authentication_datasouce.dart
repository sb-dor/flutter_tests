import 'package:flutter/cupertino.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/models/user_entity.dart';
import 'package:flutter_tests/network/http_rest_client/http/rest_client_http.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:uuid/uuid.dart';
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
  final _loginUrl = 'testUrl';

  // I will not use this client anywhere
  final http.Client _client;

  // For test purpose only!
  // I want to show to myself how to properly test
  // http request and mock them in the future
  AuthenticationDatasourceImpl(this._client);

  @override
  Future<AuthenticatedUser?> login({required String email, required String password}) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // you can write here _client.request
      final RestClientBase restClient = RestClientHttp(
        baseUrl: _baseUrl,
        client: _client,
      );

      final data = await restClient.get(_loginUrl);

      debugPrint("data is: $data");

      return AuthenticatedUser.fromJson(data?['user'] as Map<String, Object?>);
    } catch (error, stackTrace) {
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<AuthenticatedUser?> checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }
}
