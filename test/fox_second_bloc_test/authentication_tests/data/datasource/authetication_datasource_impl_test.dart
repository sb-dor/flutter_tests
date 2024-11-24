import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/data/authentication_datasouce.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;

void main() {
  const testEmail = "testEmail";
  const testPassword = "testPassword";

  const data = <String, Object?>{
    "data": {
      "id": 1,
      "name": "testName",
      "photo": "testPhoto",
      "email": "testEmail",
    },
  };

  const data2 = <String, Object?>{
    "data": {},
  };

  const data3 = <String, Object?>{};

  group(
    'AuthenticationDatasourceImplTest',
    () {
      test(
        'loginTestForNull',
        () {
          final mockHttp = http_testing.MockClient(
            (fn) async => http.Response(jsonEncode(data2), 200),
          );

          final authenticationDataSource = AuthenticationDatasourceImpl(mockHttp);

          final login = authenticationDataSource.login(
            email: testEmail,
            password: testPassword,
          );

          expectLater(login, completion(throwsA(Exception())));
        },
      );
    },
  );
}
