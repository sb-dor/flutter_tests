import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/data/authentication_datasouce.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/data/authentication_repository.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/widget/authentication_widget.dart';
import 'package:mockito/annotations.dart';

import 'authentication_widget_test.mocks.dart';

Widget runnerApp(AuthenticationBloc authenticationBloc) {
  return BlocProvider(
    create: (_) => authenticationBloc,
    child: const MaterialApp(
      home: AuthenticationWidget(),
    ),
  );
}

@GenerateMocks([AuthenticationDatasourceImpl])
void main() {
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
      app = runnerApp(authenticationBloc);
    },
  );

  tearDown(
    () {
      authenticationBloc.close();
    },
  );

  group(
    'AuthenticationWidgetTest',
    () {},
  );
}
