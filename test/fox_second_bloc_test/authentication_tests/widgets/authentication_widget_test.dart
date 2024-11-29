import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/core/constants.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/data/authentication_datasouce.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/data/authentication_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/models/user_entity.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/widget/authentication_widget.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/initialization/logic/composition_root.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_widget_test.mocks.dart';

class AuthenticationWidgetTest extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;

  const AuthenticationWidgetTest({
    super.key,
    required this.authenticationBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => authenticationBloc),
        BlocProvider(create: (_) => PostBlocFactory().create()),
      ],
      child: const MaterialApp(
        home: AuthenticationWidget(),
      ),
    );
  }
}

@GenerateMocks([AuthenticationDatasourceImpl, AuthenticatedUser])
void main() {
  const String testEmail = 'temp_email';
  const String testPassword = 'temp_password';
  late AuthenticatedUser mockedAuthenticatedUser = MockAuthenticatedUser();
  late MockAuthenticationDatasourceImpl mockAuthenticationDatasourceImpl;
  late AuthenticationBloc authenticationBloc;
  late Widget app;

  setUp(
    () {
      mockAuthenticationDatasourceImpl = MockAuthenticationDatasourceImpl();
      final IAuthenticationRepository repository = AuthenticationRepositoryImpl(
        mockAuthenticationDatasourceImpl,
      );
      authenticationBloc = AuthenticationBloc(repository: repository);
      app = AuthenticationWidgetTest(authenticationBloc: authenticationBloc);
    },
  );

  tearDown(
    () {
      authenticationBloc.close();
    },
  );

  group(
    'AuthenticationWidgetTest',
    () {
      testWidgets(
        'AuthenticationWidgetTextButtonClickAndAuthTest',
        (tester) async {
          when(mockAuthenticationDatasourceImpl.checkAuth()).thenAnswer(
            (_) async => null,
          );

          when(
            mockAuthenticationDatasourceImpl.login(
              email: testEmail,
              password: testPassword,
            ),
          ).thenAnswer((_) async => mockedAuthenticatedUser);

          //
          await tester.runAsync(() async {
            await tester.pumpWidget(app);
            //

            await tester.pumpAndSettle();

            final findTextButton = find.byKey(const ValueKey(authenticationTextButtonKey));
            //
            expect(findTextButton, findsOneWidget);

            await tester.tap(findTextButton);

            await tester.pumpAndSettle();
          });
        },
      );

      //
      testWidgets(
        'AuthenticationWidgetAlreadyAuthenticatedTest',
        (tester) async {
          when(mockAuthenticationDatasourceImpl.checkAuth()).thenAnswer(
            (_) async => mockedAuthenticatedUser,
          );

          //
          await tester.runAsync(() async {
            await tester.pumpWidget(app);
            //

            await tester.pumpAndSettle();

            final findText = find.text('Post page');

            expect(findText, findsOneWidget);
            //
          });
        },
      );
    },
  );
}
