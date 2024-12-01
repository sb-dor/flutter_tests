import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/core/constants.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/data/authentication_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/models/user_entity.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/widget/authentication_widget.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_state.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/state_model/post_state_model.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/models/post.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

import 'fox_second_bloc_integration_test.mocks.dart';

class FoxSecondBlocAuthenticationIntegrationTest extends StatelessWidget {
  final PostBloc postBloc;
  final AuthenticationBloc authenticationBloc;
  final Widget screen;

  const FoxSecondBlocAuthenticationIntegrationTest({
    super.key,
    required this.postBloc,
    required this.authenticationBloc,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => authenticationBloc),
        BlocProvider(create: (_) => postBloc),
      ],
      child: MaterialApp(
        home: screen,
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // final Post post = Post(
  //   title: titleTextControllerKey,
  //   content: contentTextControllerKey,
  //   author: authorTextControllerKey,
  // );
  const String testEmail = "temp_email";
  const String testPassword = "temp_password";
  late AuthenticatedUser user = const AuthenticatedUser(
    uid: "uid",
    displayName: "displayName",
    photoURL: "photoURL",
    email: "email",
  );
  late MockPostDatasourceImpl mockPostDatasourceImpl;
  late MockAuthenticationDatasourceImpl mockAuthenticationDatasourceImpl;
  late PostBloc postBloc;
  late AuthenticationBloc authenticationBloc;
  late Widget app;

  setUp(
    () {
      mockPostDatasourceImpl = MockPostDatasourceImpl();
      mockAuthenticationDatasourceImpl = MockAuthenticationDatasourceImpl();
      final IPostRepository postRepository = PostRepositoryImpl(mockPostDatasourceImpl);
      final IAuthenticationRepository authenticationRepository =
          AuthenticationRepositoryImpl(mockAuthenticationDatasourceImpl);
      const initialState = PostState.initial(PostStateModel(posts: <Post>[]));
      postBloc = PostBloc(postRepository: postRepository, initialState: initialState);
      //
      authenticationBloc = AuthenticationBloc(
        repository: authenticationRepository,
        user: user,
      );
      //
      app = FoxSecondBlocAuthenticationIntegrationTest(
        authenticationBloc: authenticationBloc,
        postBloc: postBloc,
        screen: const AuthenticationWidget(),
      );
    },
  );

  tearDown(
    () {
      authenticationBloc.close();
      postBloc.close();
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
          ).thenAnswer((_) async => MockAuthenticatedUser());

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
            (_) async => MockAuthenticatedUser(),
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
