import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart' as async;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/data/authentication_datasouce.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/models/user_entity.dart';
import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;

void main() {
  const testEmail = "testEmail";
  const testPassword = "testPassword";

  const data = <String, Object?>{
    "data": {
      "user": {
        "id": "1",
        "name": "testName",
        "photo": "testPhoto",
        "email": "testEmail",
      },
    }
  };

  const data2 = <String, Object?>{
    "data": {},
  };

  const data3 = <String, Object?>{};

  const data4 = <String, Object?>{
    "data": {"user": null},
  };

  group('AuthenticationDatasourceImplTest', () {
    test(
      'loginTestForNull',
      () async {
        final mockHttp = http_testing.MockClient(
          (fn) async => http.Response(jsonEncode(data2), 200),
        );

        final authenticationDataSource = AuthenticationDatasourceImpl(mockHttp);

        // if data is throwing any exception and function asynchronous
        // don't use completion method in order to handle that
        expectLater(
          authenticationDataSource.login(
            email: testEmail,
            password: testPassword,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    //
    test(
      'loginTestForUser',
      () {
        final mockedClient = http_testing.MockClient(
          (_) async => http.Response(jsonEncode(data), 200),
        );

        final authenticationDatasource = AuthenticationDatasourceImpl(mockedClient);

        expectLater(
          authenticationDatasource.login(email: testEmail, password: testPassword),
          completion(isNotNull),
        );
      },
    );

    //

    test(
      'logoutTestForFailed',
      () {
        final mockedClient = http_testing.MockClient(
          (_) async {
            return http.Response(jsonEncode({'success': false}), 200);
          },
        );

        final authenticationRepo = AuthenticationDatasourceImpl(mockedClient);

        expectLater(authenticationRepo.logout(), completion(isFalse));
      },
    );

    test(
      'logoutTestForUnExpectedValueFalse',
      () {
        final mockedClient = http_testing.MockClient(
          (_) async {
            return http.Response(jsonEncode(data3), 200);
          },
        );

        final authenticationRepo = AuthenticationDatasourceImpl(mockedClient);

        expectLater(authenticationRepo.logout(), completion(isFalse));
      },
    );

    test(
      'logoutTestForUnExpectedValueFalse',
      () {
        final mockedClient = http_testing.MockClient(
          (_) async {
            return http.Response(jsonEncode(data3), 200);
          },
        );

        final authenticationRepo = AuthenticationDatasourceImpl(mockedClient);

        expectLater(authenticationRepo.logout(), completion(isFalse));
      },
    );

    test(
      'logoutTestForUnExpectedValueException',
      () {
        final mockedClient = http_testing.MockClient(
          (_) async {
            return http.Response(jsonEncode(""), 200);
          },
        );

        final authenticationRepo = AuthenticationDatasourceImpl(mockedClient);

        // throws error during decoding
        expectLater(
          authenticationRepo.logout(),
          throwsA(isA<ClientException>()),
        );
      },
    );

    test(
      'checkAuthTestNoUser',
      () {
        final mockClient = http_testing.MockClient(
          (_) async => http.Response(
            jsonEncode(data4),
            200,
          ),
        );

        final authenticationDatasource = AuthenticationDatasourceImpl(mockClient);

        expectLater(
          authenticationDatasource.checkAuth(),
          completion(isNull),
        );
      },
    );

    test(
      'checkAuthTestUserNoUser2',
          () {
        final mockClient = http_testing.MockClient(
              (_) async => http.Response(
            jsonEncode(data3),
            200,
          ),
        );

        final authenticationDatasource = AuthenticationDatasourceImpl(mockClient);

        expectLater(
          authenticationDatasource.checkAuth(),
          completion(isNull),
        );
      },
    );

    test(
      'checkAuthTestUserNoUser3',
          () {
        final mockClient = http_testing.MockClient(
              (_) async => http.Response(
            jsonEncode(data2),
            200,
          ),
        );

        final authenticationDatasource = AuthenticationDatasourceImpl(mockClient);

        expectLater(
          authenticationDatasource.checkAuth(),
          completion(isNull),
        );
      },
    );

    test(
      'checkAuthTestUserAuthenticated',
          () {
        final mockClient = http_testing.MockClient(
              (_) async => http.Response(
            jsonEncode(data),
            200,
          ),
        );

        final authenticationDatasource = AuthenticationDatasourceImpl(mockClient);

        expectLater(
          authenticationDatasource.checkAuth(),
          completion(isA<UserEntity>()),
        );
      },
    );

    test(
      'checkAuthTestUserBadResponse',
          () {
        final mockClient = http_testing.MockClient(
              (_) async => http.Response(
            jsonEncode("Bad response"),
            200,
          ),
        );

        final authenticationDatasource = AuthenticationDatasourceImpl(mockClient);

        expectLater(
          authenticationDatasource.checkAuth(),
          throwsA(isA<ClientException>()),
        );
      },
    );
  });
}
