import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/bloc/authentication_events.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/bloc/authentication_states.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/data/authentication_datasouce.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/data/authentication_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/models/user_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../data/repository/athentication_repository_impl_test.mocks.dart';

@GenerateMocks([AuthenticationDatasourceImpl, AuthenticatedUser])
void main() {
  const testEmail = 'testEmail';
  const testPassword = 'testPassword';
  late AuthenticationBloc authenticationBloc;
  late MockAuthenticatedUser authenticatedUser;
  late MockAuthenticationDatasourceImpl mockAuthenticationDatasourceImpl;

  setUp(
    () {
      authenticatedUser = MockAuthenticatedUser();
      mockAuthenticationDatasourceImpl = MockAuthenticationDatasourceImpl();
      final repoImpl = AuthenticationRepositoryImpl(mockAuthenticationDatasourceImpl);
      authenticationBloc = AuthenticationBloc(
        repository: repoImpl,
        user: const UserEntity.notAuthenticated(),
      );
    },
  );

  group(
    'AuthenticationBlocTesting',
    () {
      blocTest<AuthenticationBloc, AuthenticationStates>(
        'emits [inProgress, authenticated] when checkAuth is successful',
        build: () => authenticationBloc,
        act: (bloc) {
          when(mockAuthenticationDatasourceImpl.checkAuth()).thenAnswer(
            (_) async => authenticatedUser,
          );

          bloc.add(
            const AuthenticationBlocEvents.checkAuth(),
          );
        },
        expect: () => <AuthenticationStates>[
          // Initial state transition
          const AuthenticationStates.inProgress(),
          // Successful login
          AuthenticationStates.authenticated(authenticatedUser),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationStates>(
        'emits [inProgress, notAuthenticated] when checkAuth is successful',
        build: () => authenticationBloc,
        act: (bloc) {
          when(mockAuthenticationDatasourceImpl.checkAuth()).thenAnswer(
            (_) async => null,
          );

          bloc.add(
            const AuthenticationBlocEvents.checkAuth(),
          );
        },
        expect: () => <AuthenticationStates>[
          // Initial state transition
          const AuthenticationStates.inProgress(),
          // Successful login
          const AuthenticationStates.unAuthenticated(),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationStates>(
        'emits [inProgress, noUser] when login is successful',
        build: () => authenticationBloc,
        act: (bloc) {
          when(mockAuthenticationDatasourceImpl.login(email: testEmail, password: testPassword))
              .thenAnswer(
            (_) async => null,
          );

          bloc.add(
            const AuthenticationBlocEvents.logIn(email: testEmail, password: testPassword),
          );
        },
        expect: () => <AuthenticationStates>[
          // Initial state transition
          const AuthenticationStates.loginProgress(),
          // Successful login
          const AuthenticationStates.unAuthenticated(),
        ],
      );
    },
  );
}
