import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/data/authentication_datasouce.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/data/authentication_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/models/user_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'athentication_repository_impl_test.mocks.dart';

@GenerateMocks([AuthenticationDatasourceImpl, AuthenticatedUser])
void main() {
  const testEmail = 'testEmail';
  const testPassword = 'testPassword';
  final AuthenticatedUser user = MockAuthenticatedUser();
  late MockAuthenticationDatasourceImpl mockAuthenticationDatasourceImpl;
  late AuthenticationRepositoryImpl authenticationRepositoryImpl;

  setUp(
    () {
      mockAuthenticationDatasourceImpl = MockAuthenticationDatasourceImpl();

      authenticationRepositoryImpl = AuthenticationRepositoryImpl(
        mockAuthenticationDatasourceImpl,
      );
    },
  );

  group(
    'AuthenticationDataSourceImpl',
    () {
      //
      test(
        'authenticationLoginTestForNull',
        () async {
          when(
            mockAuthenticationDatasourceImpl.login(
              email: testEmail,
              password: testPassword,
            ),
          ).thenAnswer(
            (_) => Future.value(null),
          );

          final checkLogin = authenticationRepositoryImpl.login(
            email: testEmail,
            password: testPassword,
          );

          expectLater(checkLogin, completion(null));
        },
      );

      //
      test(
        'authenticationLoginTestForAuthenticatedUser',
        () {
          when(
            mockAuthenticationDatasourceImpl.login(
              email: testEmail,
              password: testPassword,
            ),
          ).thenAnswer(
            (_) => Future.value(user),
          );

          final checkLogin = authenticationRepositoryImpl.login(
            email: testEmail,
            password: testPassword,
          );

          expectLater(checkLogin, completion(isNotNull));
        },
      );

      test(
        'authenticationLogOutError',
        () {
          when(
            mockAuthenticationDatasourceImpl.logout(),
          ).thenAnswer(
            (_) => Future.value(false),
          );

          final logout = authenticationRepositoryImpl.logout();

          expectLater(logout, completion(isFalse));
        },
      );

      test(
        'authenticationLogOutSuccessful',
        () {
          when(
            mockAuthenticationDatasourceImpl.logout(),
          ).thenAnswer(
            (_) => Future.value(true),
          );

          final logout = authenticationRepositoryImpl.logout();

          expectLater(logout, completion(isTrue));
        },
      );

      test(
        'authenticationCheckAuthenticationNull',
        () {
          when(
            mockAuthenticationDatasourceImpl.checkAuth(),
          ).thenAnswer(
                (_) => Future.value(null),
          );

          final checkAuth = authenticationRepositoryImpl.checkAuth();

          expectLater(checkAuth, completion(isTrue));
        },
      );

      test(
        'authenticationCheckAuthenticationSuccessful',
            () {
          when(
            mockAuthenticationDatasourceImpl.checkAuth(),
          ).thenAnswer(
                (_) => Future.value(user),
          );

          final checkAuth = authenticationRepositoryImpl.checkAuth();

          expectLater(checkAuth, completion(isNotNull));
        },
      );
    },
  );
}
