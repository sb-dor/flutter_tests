import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:flutter_tests/network/repository_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_http_test.mocks.dart';

const _testUrl = "testUrl";

final jsonUTF8 = json.fuse(utf8);

@GenerateMocks([File])
void main() {
  group(
    'RepositoryTest',
    () {
      test(
        'getTestDataFunctionTest',
        () async {
          const estimatedDataInString = '{"data": {"hello": "world"}}';

          final clientTest = http_testing.MockClient(
            (request) async {
              return http.Response(estimatedDataInString, 200);
            },
          );

          final repoTest = RepositoryTest(clientTest);

          expectLater(
            repoTest.getTestData(),
            completion(
              equals({"hello": "world"}),
            ),
          );
        },
      );

      test(
        'getTestDataFunctionTestWithFile',
        () {
          const estimatedData = <String, Object?>{
            "data": true,
          };

          const estimatedDataInString = '{"data": true}';

          final testClient = http_testing.MockClient(
            (req) async => http.Response(estimatedDataInString, 200),
          );

          final repo = RepositoryTest(testClient);

          final file = MockFile();

          when(file.readAsBytes()).thenAnswer((_) async => Uint8List(100));

          expectLater(
            repo.getTestData(file: file),
            completion(
              equals(estimatedData),
            ),
          );
        },
      );

      test(
        'getTestDataFunctionTestWithoutFile',
        () {
          const estimatedData = <String, Object?>{
            "data": false,
          };

          const estimatedDataInString = '{"data": false}';

          final testClient = http_testing.MockClient(
            (req) async => http.Response(estimatedDataInString, 200),
          );

          final repo = RepositoryTest(testClient);

          expectLater(repo.getTestData(), completion(equals(estimatedData)));
        },
      );
    },
  );
}

final class TestRestApiClient extends RestClientBase {
  TestRestApiClient({required super.baseUrl});

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required RequestType method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    List<http.MultipartFile>? files,
  }) {
    // TODO: implement send
    throw UnimplementedError();
  }
}
