
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/bloc/post_bloc.dart';

class FoxDependencyContainer {
  final AuthenticationBloc authenticationBloc;

  final PostBloc postBloc;

  FoxDependencyContainer({
    required this.authenticationBloc,
    required this.postBloc,
  });
}
