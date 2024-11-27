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

          // the reason was that initial state for AuthenticationBloc was inProgress()
          // but when you add login event again, inside there is a if statement that checks
          // whether it's in progress or not, that is why I created another state "LoginInProgress"
          // now it's working fine

          // NOTE! remember for test purpose, you better pass initial state through
          // constructor for the bloc, it will be easier to test

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

      blocTest(
        'emits [loginProcess, errorState] when login failed',
        build: () => authenticationBloc,
        act: (bloc) {
          when(
            mockAuthenticationDatasourceImpl.login(
              email: testEmail,
              password: testPassword,
            ),
          ).thenThrow(Exception());

          // because of that logic throws an error
          // we can not handle that properly
          // that is why I removed "rethrow" from _login function
          // maybe, there are another good solutions for that
          // but I haven't found those yet
          bloc.add(
            const AuthenticationBlocEvents.logIn(
              email: testEmail,
              password: testPassword,
            ),
          );
        },
        expect: () => [
          const AuthenticationStates.loginProgress(),
          const AuthenticationStates.error(),
        ],
      );

      //
      blocTest(
        'emits [inProgress, unAuthenticated] when logout event works',
        build: () => authenticationBloc,
        act: (bloc) {
          when(
            mockAuthenticationDatasourceImpl.logout(),
          ).thenAnswer(
            (_) async => true,
          );

          bloc.add(const AuthenticationBlocEvents.logOut());
        },
        expect: () => <AuthenticationStates>[
          const AuthenticationStates.inProgress(),
          const AuthenticationStates.unAuthenticated(),
        ],
      );

      blocTest(
        'emits [inProgress, error] when logout event works',
        build: () => authenticationBloc,
        act: (bloc) {
          when(
            mockAuthenticationDatasourceImpl.logout(),
          ).thenThrow(Exception());

          bloc.add(const AuthenticationBlocEvents.logOut());
        },
        expect: () => <AuthenticationStates>[
          const AuthenticationStates.inProgress(),
          const AuthenticationStates.error(),
        ],
      );
      
      //
      blocTest(
        'emits [inProgress, error] when logout event works and logout was not successful',
        build: () => authenticationBloc,
        act: (bloc) {
          when(
            mockAuthenticationDatasourceImpl.logout(),
          ).thenAnswer((_) async => false);

          bloc.add(const AuthenticationBlocEvents.logOut());
        },
        expect: () => <AuthenticationStates>[
          const AuthenticationStates.inProgress(),
          const AuthenticationStates.error(),
        ],
      );
    },
  );
}
