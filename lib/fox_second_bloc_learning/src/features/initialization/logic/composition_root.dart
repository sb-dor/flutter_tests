// the main reason and the main concept of doing so
// is that we want to achieve injections without getIt pattern (Service locator, which is good for service location)
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/data/authentication_datasouce.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/data/authentication_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/initialization/model/fox_dependency_container.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_state.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/state_model/post_state_model.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_datasource.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/models/post.dart';
import 'package:http/http.dart';

final class CompositionRoot {
  Future<CompositionResult> composeResult() async {
    final dependencyContainerFactory = DependencyFactory().create();

    return CompositionResult(dependencyContainerFactory);
  }
}

final class CompositionResult {
  final FoxDependencyContainer dependencyContainer;

  CompositionResult(this.dependencyContainer);
}

class DependencyFactory extends Factory<FoxDependencyContainer> {
  @override
  FoxDependencyContainer create() {
    final authenticationBloc = AuthenticationBlocFactory().create();

    final postBloc = PostBlocFactory().create();

    return FoxDependencyContainer(
      authenticationBloc: authenticationBloc,
      postBloc: postBloc,
    );
  }
}

abstract class Factory<T> {
  T create();
}

abstract class AsyncFactory<T> {
  Future<T> create();
}

class AuthenticationBlocFactory extends Factory<AuthenticationBloc> {
  @override
  AuthenticationBloc create() {
    final IAuthenticationDatasource authenticationDatasource = AuthenticationDatasourceImpl(
      Client(),
    );
    final IAuthenticationRepository authenticationRepository = AuthenticationRepositoryImpl(
      authenticationDatasource,
    );
    return AuthenticationBloc(
      repository: authenticationRepository,
    );
  }
}

class PostBlocFactory extends Factory<PostBloc> {
  @override
  PostBloc create() {
    final IPostDatasource postDatasource = PostDatasourceImpl(
      Client(),
    );
    final IPostRepository postRepository = PostRepositoryImpl(
      postDatasource,
    );
    const PostState initialState = PostState.initial(
      PostStateModel(
        posts: <Post>[],
      ),
    );

    return PostBloc(
      postRepository: postRepository,
      initialState: initialState,
    );
  }
}
