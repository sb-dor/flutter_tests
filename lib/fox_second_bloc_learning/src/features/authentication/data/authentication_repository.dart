
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/models/user_entity.dart';

import 'authentication_datasouce.dart';

abstract interface class IAuthenticationRepository {
  Future<AuthenticatedUser?> login({
    required final String email,
    required final String password,
  });

  Future<bool> logout();

  Future<AuthenticatedUser?> checkAuth();
}

final class AuthenticationRepositoryImpl implements IAuthenticationRepository {
  final IAuthenticationDatasource _authenticationDatasource;

  AuthenticationRepositoryImpl(this._authenticationDatasource);

  @override
  Future<AuthenticatedUser?> login({required String email, required String password}) =>
      _authenticationDatasource.login(email: email, password: password);

  @override
  Future<bool> logout() => _authenticationDatasource.logout();

  @override
  Future<AuthenticatedUser?> checkAuth() => _authenticationDatasource.checkAuth();
}
