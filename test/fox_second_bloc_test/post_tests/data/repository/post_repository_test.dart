import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_datasource.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/data/post_repository.dart';
import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'post_repository_test.mocks.dart';

@GenerateMocks([PostDatasourceImpl])
void main() {
  late PostRepositoryImpl postRepositoryImpl;
  late MockPostDatasourceImpl mockPostDatasourceImpl;

  setUp(() {
    mockPostDatasourceImpl = MockPostDatasourceImpl();
    postRepositoryImpl = PostRepositoryImpl(mockPostDatasourceImpl);
    // it was for checking purpose whether setUp calls everytime regardless group function or whether it works
    // out of groups too
    debugPrint("is it calling itself");
  });

  // tearDown(() {
  //   reset(mockPostDatasourceImpl);
  //   debugPrint("tear down calling itself");
  // });

  final toJson = <String, Object?>{
    "id": 1,
    "any": "any",
  };

  group(
    'PostRepositoryTest',
    () {
      test(
        'testSavePostIfThePostWasNotSaved',
        () {
          when(mockPostDatasourceImpl.savePost(toJson)).thenAnswer((_) async => false);

          final save = postRepositoryImpl.savePost(toJson);

          expectLater(
            save,
            completion(isFalse),
          );

          verify(mockPostDatasourceImpl.savePost(toJson)).called(1);
        },
      );

      //
      test(
        'testSavePostIfThePostWasSaved',
        () {
          when(mockPostDatasourceImpl.savePost(toJson)).thenAnswer((_) async => true);

          final save = postRepositoryImpl.savePost(toJson);

          expectLater(save, completion(isTrue));

          verify(mockPostDatasourceImpl.savePost(toJson)).called(1);
        },
      );

      // asynchronous code of throwing error
      test(
        'testSavePostIfThePostThrewException',
        () async {
          when(mockPostDatasourceImpl.savePost(toJson)).thenThrow(
            const WrongResponseTypeException(message: ''),
          );

          expectLater(
            () async => await postRepositoryImpl.savePost(toJson),
            throwsA(isA<WrongResponseTypeException>()),
          );

          verify(mockPostDatasourceImpl.savePost(toJson)).called(1);
        },
      );

      //
      test(
        'testAddTextFunctionRuns',
        () {
          when(mockPostDatasourceImpl.addText()).thenAnswer((_) async {});

          postRepositoryImpl.addText();

          verify(mockPostDatasourceImpl.addText()).called(1);
        },
      );

      //
      test(
        'testAddTextFunctionThrowsAnError',
        () async {
          when(mockPostDatasourceImpl.addText()).thenThrow(
            const WrongResponseTypeException(message: ''),
          );

          expectLater(
            () async => await postRepositoryImpl.addText(),
            throwsA(isA<WrongResponseTypeException>()),
          );

          verify(mockPostDatasourceImpl.addText()).called(1);
        },
      );
    },
  );
}
