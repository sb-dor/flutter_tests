import 'dart:convert';
import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';

// encodes any data not to String but to List<int>
final jsonUTF8 = json.fuse(utf8);

void main() {
  const testUrl = 'test/url';

  group(
    'RestClientHttp',
    () {
      test(
        'encodeBodyWithValidMap',
        () {
          final testClient = TestRestClientBase(baseUrl: testUrl);
          final body = {"key": 1, "key2": 2, "key3": true, "key4": <dynamic>[]};
          final encodedBody =
              testClient.encodeBody(body); // taking only "encodeBody" function from this class
          debugPrint('encodedbody: $encodedBody');
          final expectedBody = jsonUTF8.encode(body);
          debugPrint("ecpectedbody: $expectedBody");
          expect(encodedBody, equals(expectedBody));
        },
      );

      test(
        'encodeBodyWithEmptyMap',
        () {
          final testClient = TestRestClientBase(baseUrl: testUrl);
          final body = <String, Object?>{};
          final encodedBody = testClient.encodeBody(body);
          const expectedBody = [123, 125]; // -> {}
          expect(encodedBody, equals(expectedBody));
        },
      );

      test('encodeBodyWithInvalidMap', () {
        final testClient = TestRestClientBase(baseUrl: testUrl);
        final body = {"data": const TestClass()};
        expect(() => testClient.encodeBody(body), throwsA(isA<ClientException>()));
      });

      test(
        'decodeResponseWithNull',
        () {
          final testClient = TestRestClientBase(baseUrl: testUrl);

          /// uses for future functions
          /// Matches a Future that completes successfully with a value that matches matcher [completion]
          expectLater(testClient.decodeResponse(null), completion(isNull));
        },
      );

      test(
        'decodeResponseWithEmptyBody',
        () {
          final testClient = TestRestClientBase(baseUrl: testUrl);
          expectLater(
              testClient.decodeResponse(const BytesResponseBody(<int>[])), completion(isNull));
        },
      );

      test(
        'decodeResponseWithMapBody',
        () {
          final testClient = TestRestClientBase(baseUrl: testUrl);
          final body = {"data": "some_data"};
          final encodedBody = jsonUTF8.encode(body);
          expectLater(
            testClient.decodeResponse(BytesResponseBody(encodedBody)),
            completion(equals(body)),
          );
        },
      );
    },
  );
}

class TestClass {
  const TestClass();
}

final class TestRestClientBase extends RestClientBase {
  TestRestClientBase({required super.baseUrl});

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
