import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';

final jsonUTF8 = json.fuse(utf8);

void main() {
  group(
    'RestClientHttp',
    () {
      test(
        'encodeBodyWithValidMap',
        () {
          final testClient = TestRestClientBase(baseUrl: 'test/url');
          final body = {"key": 1, "key2": 2, "key3": true, "key4": <dynamic>[]};
          final encodedBody = testClient.encodeBody(body);
          debugPrint('encodedbody: $encodedBody');
          final expectedBody = jsonUTF8.encode(body);
          debugPrint("ecpectedbody: $expectedBody");
          expect(encodedBody, equals(expectedBody));
        },
      );
    },
  );
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
  }) {
    // TODO: implement send
    throw UnimplementedError();
  }
}
