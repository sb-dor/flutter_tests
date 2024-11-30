import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_datasource.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/models/post.dart';
import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:http/testing.dart' as http_testing;
import 'package:http/http.dart' as http;

void main() {
  const String addTempText = "tempText";
  final post = Post(title: "Temp title", content: "Temp content", author: "Me");

  final body = {
    "data": {"success": true},
  };
  final body2 = {
    "data": {"success": false},
  };
  final body3 = {
    "error": <String, Object?>{"message": "Server error"},
  };

  final body4 = {'Un expected error': ""};

  group(
    'PostDataSourceSavePostTest',
    () {
      test(
        'savePostEndsWithSuccess',
        () async {
          final mockedClient = http_testing.MockClient(
            (_) async => http.Response(jsonEncode(body), 200),
          );

          final postDatasourceImpl = PostDatasourceImpl(mockedClient);

          final savePost = postDatasourceImpl.savePost(post.toJson());

          await expectLater(savePost, completion(isTrue));
        },
      );

      //
      test(
        'savePostEndsWithFail',
        () async {
          final mockedClient = http_testing.MockClient(
            (_) async => http.Response(jsonEncode(body2), 200),
          );

          final postDatasourceImpl = PostDatasourceImpl(mockedClient);

          final savePost = postDatasourceImpl.savePost(post.toJson());

          await expectLater(savePost, completion(isFalse));
        },
      );

      test(
        'savePostEndsWithServerError',
        () async {
          final mockedClient = http_testing.MockClient(
            (_) async => http.Response(jsonEncode(body3), 200),
          );

          final postDatasourceImpl = PostDatasourceImpl(mockedClient);

          final savePost = postDatasourceImpl.savePost(post.toJson());

          await expectLater(savePost, throwsA(isA<StructuredBackendException>()));
        },
      );

      test(
        'savePostEndsWithUnExpectedError',
        () async {
          final mockedClient = http_testing.MockClient(
            (_) async => http.Response(jsonEncode(body4), 200),
          );

          final postDatasource = PostDatasourceImpl(mockedClient);

          final savePost = postDatasource.savePost(post.toJson());

          await expectLater(savePost, completion(isFalse));
        },
      );
    },
  );

  group(
    'PostDatasourceAddTextTest',
    () {

      test(
        'addTextFunctionEndsWithSuccess',
            () async {
          final mockedClient = http_testing.MockClient(
                (_) async => http.Response(jsonEncode(body), 200),
          );

          final repositoryDatasourceImpl = PostDatasourceImpl(mockedClient);

          final addText = repositoryDatasourceImpl.addText(addTempText);

          expectLater(addText, completion(isTrue));
        },
      );

      test(
        'addTextFunctionEndsWithFail',
            () async {
          final mockedClient = http_testing.MockClient(
                (_) async => http.Response(jsonEncode(body2), 200),
          );

          final repositoryDatasourceImpl = PostDatasourceImpl(mockedClient);

          final addText = repositoryDatasourceImpl.addText(addTempText);

          expectLater(addText, completion(isFalse));
        },
      );

      test(
        'addTextFunctionEndsWithError',
        () async {
          final mockedClient = http_testing.MockClient(
            (_) async => http.Response(jsonEncode(body3), 200),
          );

          final repositoryDatasourceImpl = PostDatasourceImpl(mockedClient);

          final addText = repositoryDatasourceImpl.addText(addTempText);

          expectLater(addText, throwsA(isA<StructuredBackendException>()));
        },
      );

      test(
        'addTextFunctionEndsWithEUnexpectedError',
            () async {
          final mockedClient = http_testing.MockClient(
                (_) async => http.Response(jsonEncode(body4), 200),
          );

          final repositoryDatasourceImpl = PostDatasourceImpl(mockedClient);

          final addText = repositoryDatasourceImpl.addText(addTempText);

          expectLater(addText, completion(isFalse));
        },
      );
    },
  );
}
