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
  const String addTempText = "tempText";
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
    },
  );

  group(
    'PostRepositoryAddText',
    () {
      // FOR ASYNC VOID FUNCTIONS
      // test(
      //   'testAddTextFunctionRuns',
      //       () {
      //     when(mockPostDatasourceImpl.addText(addTempText)).thenAnswer((_) async {});
      //
      //     postRepositoryImpl.addText(addTempText);
      //
      //     verify(mockPostDatasourceImpl.addText(addTempText)).called(1);
      //   },
      // );

      test(
        'testAddTextFunctionEndsSuccessfully',
        () async {
          when(mockPostDatasourceImpl.addText(addTempText)).thenAnswer((_) async => true);

          expectLater(
             postRepositoryImpl.addText(addTempText),
            completion(isTrue),
          );

          verify(mockPostDatasourceImpl.addText(addTempText)).called(1);
        },
      );

      test(
        'testAddTextFunctionEndsWithFail',
        () async {
          when(mockPostDatasourceImpl.addText(addTempText)).thenAnswer((_) async => false);

          expectLater(
            postRepositoryImpl.addText(addTempText),
            completion(isFalse),
          );

          verify(mockPostDatasourceImpl.addText(addTempText)).called(1);
        },
      );

      //
      test(
        'testAddTextFunctionThrowsAnError',
        () async {
          when(mockPostDatasourceImpl.addText(addTempText)).thenThrow(
            const WrongResponseTypeException(message: ''),
          );

          expectLater(
            () async => await postRepositoryImpl.addText(addTempText),
            throwsA(isA<WrongResponseTypeException>()),
          );

          verify(mockPostDatasourceImpl.addText(addTempText)).called(1);
        },
      );
    },
  );
}
