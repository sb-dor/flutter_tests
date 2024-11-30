import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/core/constants.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/data/authentication_datasouce.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/data/authentication_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_state.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/state_model/post_state_model.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_datasource.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/models/post.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/widgets/post_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../async_finder.dart';
import 'post_page_test.mocks.dart';

class PostPageTest extends StatelessWidget {
  final PostBloc postBloc;
  final AuthenticationBloc authenticationBloc;

  const PostPageTest({
    super.key,
    required this.postBloc,
    required this.authenticationBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => authenticationBloc),
        BlocProvider(create: (_) => postBloc),
      ],
      child: const MaterialApp(
        home: PostPage(),
      ),
    );
  }
}

@GenerateMocks([PostDatasourceImpl, AuthenticationDatasourceImpl])
void main() {
  final Post post = Post(
    title: titleTextControllerKey,
    content: contentTextControllerKey,
    author: authorTextControllerKey,
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
      authenticationBloc = AuthenticationBloc(repository: authenticationRepository);
      app = PostPageTest(authenticationBloc: authenticationBloc, postBloc: postBloc);
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

  group(
    'PostPageTest',
    () {
      testWidgets(
        'postPageTest',
        (tester) async {
          await tester.runAsync(
            () async {
              when(mockPostDatasourceImpl.savePost(any)).thenAnswer((_) async => true);

              await tester.pumpWidget(app);

              final findFloatingAddButton =
                  find.byKey(const ValueKey(addPostFloatingButtonPostPage));

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

              // await tester.pumpAndSettle();

              final findAWidgetWithPost = await asyncFinder(
                tester: tester,
                finder: () => find.byKey(ValueKey("${Post}_")),
              );
              //
              // expect(findAWidgetWithPost, findsAny);
            },
          );
        },
      );
    },
  );
}
