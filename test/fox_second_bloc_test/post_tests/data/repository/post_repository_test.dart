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
  });

  group(
    'PostRepositoryTest',
    () {
      test(
        'testSavePostIfThePostWasNotSaved',
        () {
          when(mockPostDatasourceImpl.savePost()).thenAnswer((_) async => false);

          final save = postRepositoryImpl.savePost();

          expectLater(
            save,
            completion(isFalse),
          );

          verify(mockPostDatasourceImpl.savePost()).called(1);
        },
      );

      //
      test(
        'testSavePostIfThePostWasSaved',
        () {
          when(mockPostDatasourceImpl.savePost()).thenAnswer((_) async => true);

          final save = postRepositoryImpl.savePost();

          expectLater(save, completion(isTrue));

          verify(mockPostDatasourceImpl.savePost()).called(1);
        },
      );

      // asynchronous code of throwing error
      test(
        'testSavePostIfThePostThrewException',
        () async {
          when(mockPostDatasourceImpl.savePost()).thenThrow(
            const WrongResponseTypeException(message: ''),
          );

          expectLater(
            () async => await postRepositoryImpl.savePost(),
            throwsA(isA<WrongResponseTypeException>()),
          );

          verify(mockPostDatasourceImpl.savePost()).called(1);
        },
      );

      //
      test(
        'TestAddTextFunctionRuns',
        () {
          when(mockPostDatasourceImpl.addText());

          postRepositoryImpl.addText();

          verify(mockPostDatasourceImpl.addText()).called(1);
        },
      );

      //
      test(
        'TestAddTextFunctionThrowsAnError',
        () {
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
