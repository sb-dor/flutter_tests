import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_event.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_state.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/state_model/post_state_model.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_datasource.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/models/post.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_bloc_test.mocks.dart';

@GenerateMocks([PostDatasourceImpl])
void main() {
  final Post post = Post(title: "test", content: "test", author: "test");
  const String testText = "test";
  late MockPostDatasourceImpl mockPostDatasourceImpl;
  late IPostRepository iPostRepository;
  late PostBloc postBloc;

  setUp(
    () {
      const initialStateForBloc = PostState.initial(PostStateModel(posts: <Post>[]));
      mockPostDatasourceImpl = MockPostDatasourceImpl();
      iPostRepository = PostRepositoryImpl(mockPostDatasourceImpl);
      postBloc = PostBloc(
        postRepository: iPostRepository,
        initialState: initialStateForBloc,
      );
    },
  );

  tearDown(
    () {
      postBloc.close();
    },
  );

  group(
    'PostBlocTest',
    () {
      test(
        'addPostTestSuccessfully',
        () async {
          when(mockPostDatasourceImpl.savePost(post.toJson())).thenAnswer((_) async => true);

          postBloc.add(AddPost(post: post));

          await expectLater(
            postBloc.stream,
            emitsInOrder([
              isA<SendingState>(),
              isA<PostSuccessfulState>().having(
                (s) => s.postStateModel.posts,
                'hasSomethingInsideList',
                allOf(
                  isA<List<Post>>(),
                  isNotEmpty,
                  hasLength(1),
                ),
              ),
            ]),
          );

          verify(mockPostDatasourceImpl.savePost(post.toJson())).called(1);
        },
      );

      //
      test(
        'addPostTestEndsWithFailure',
        () async {
          when(mockPostDatasourceImpl.savePost(post.toJson())).thenAnswer((_) async => false);

          postBloc.add(AddPost(post: post));

          await expectLater(
            postBloc.stream,
            emitsInOrder([
              isA<SendingState>(),
              isA<SendErrorState>(),
            ]),
          );

          verify(mockPostDatasourceImpl.savePost(post.toJson())).called(1);
        },
      );

      test(
        'addPostTestEndsWithException',
        () async {
          when(mockPostDatasourceImpl.savePost(post.toJson())).thenThrow(
            Exception(),
          );

          postBloc.add(AddPost(post: post));

          await expectLater(
            postBloc.stream,
            emitsInOrder([
              isA<SendingState>(),
              isA<PostErrorState>(),
            ]),
          );

          verify(mockPostDatasourceImpl.savePost(post.toJson())).called(1);
        },
      );
    },
  );
}
