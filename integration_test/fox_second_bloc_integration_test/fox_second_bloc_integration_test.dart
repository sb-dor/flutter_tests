import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/core/constants.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/data/authentication_datasouce.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/data/authentication_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/models/user_entity.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/widget/authentication_widget.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_state.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/state_model/post_state_model.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_datasource.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/models/post.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test/async_finder.dart';
import 'fox_second_bloc_integration_test.mocks.dart';

class FoxSecondBlocIntegrationTest extends StatelessWidget {
  final PostBloc postBloc;
  final AuthenticationBloc authenticationBloc;
  final Widget screen;

  const FoxSecondBlocIntegrationTest({
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

// https://stackoverflow.com/questions/68275811/is-there-a-way-to-let-mockito-generate-mocks-for-integration-tests-in-a-flutter
@GenerateMocks([PostDatasourceImpl, AuthenticationDatasourceImpl, AuthenticatedUser])
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
      app = FoxSecondBlocIntegrationTest(
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

  // I could create keys for each of textControllers
  // but i think that it's good
  const List<String> textOfControllers = [
    titleTextControllerKey,
    contentTextControllerKey,
    authorTextControllerKey,
  ];

  testWidgets(
    'TestApp',
    (tester) async {
      when(mockAuthenticationDatasourceImpl.checkAuth()).thenAnswer(
        (_) async => null,
      );

      when(mockAuthenticationDatasourceImpl.login(email: testEmail, password: testPassword))
          .thenAnswer(
        (_) async => MockAuthenticatedUser(),
      );

      when(mockPostDatasourceImpl.savePost(any)).thenAnswer((_) async => true);

      when(mockAuthenticationDatasourceImpl.logout()).thenAnswer((_) async => true);

      await tester.runAsync(
        () async {
          await tester.pumpWidget(app);

          //
          await tester.pumpAndSettle();

          final findTextButton = find.byKey(const ValueKey(authenticationTextButtonKey));
          //
          expect(findTextButton, findsOneWidget);

          await tester.tap(findTextButton);

          await asyncFinder(
            tester: tester,
            finder: () => find.text('Post page'),
          );

          final findFloatingAddButton = find.byKey(const ValueKey(addPostFloatingButtonPostPage));

          expect(findFloatingAddButton, findsOneWidget);

          await tester.tap(findFloatingAddButton);

          await tester.pumpAndSettle();

          for (final each in textOfControllers) {
            final findTextController = find.byKey(ValueKey(each));

            expect(findTextController, findsOneWidget);

            await tester.enterText(findTextController, each);

            await tester.pumpAndSettle();
          }

          final findSavePostButton = find.byKey(const ValueKey(savePostFloatingButtonPostPage));

          expect(findSavePostButton, findsOneWidget);

          await tester.tap(findSavePostButton);

          final findAWidgetsWithPost = await syncFinder(
            tester: tester,
            finder: () => find.byWidgetPredicate(
              (widget) =>
                  widget.key != null &&
                  widget.key is ValueKey<String> &&
                  (widget.key as ValueKey<String>).value.contains("post_widget_"),
            ),
          );
          //
          expect(findAWidgetsWithPost, findsAny);

          final findLogoutButton = find.byKey(const ValueKey(logoutTextButtonKey));

          expect(findLogoutButton, findsOneWidget);

          await tester.pumpAndSettle();

          await tester.tap(findLogoutButton);

          await syncFinder(
            tester: tester,
            finder: () => find.text("Authentication"),
          );

          verify(mockPostDatasourceImpl.savePost(any)).called(1);

          verify(
            mockAuthenticationDatasourceImpl.login(email: testEmail, password: testPassword),
          ).called(1);

          verify(mockAuthenticationDatasourceImpl.logout()).called(1);

          verify(mockAuthenticationDatasourceImpl.checkAuth());
        },
      );
    },
  );
}
