
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/post/bloc/post_bloc.dart';

class FoxDependencyContainer {
  final AuthenticationBloc authenticationBloc;

  final PostBloc postBloc;

  FoxDependencyContainer({
    required this.authenticationBloc,
    required this.postBloc,
  });
}
