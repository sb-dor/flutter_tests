import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/data/home_repository_impl.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/data/source/home_datasource.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../fixtures/home_fixtures.dart';
import 'home_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HomeDatasource>()])
void main() {
  late HomeRepositoryImpl homeRepoImpl;
  late MockHomeDatasource mockHomeDataSourceNetwork;

  setUpAll(() {
    mockHomeDataSourceNetwork = MockHomeDatasource();
    homeRepoImpl = HomeRepositoryImpl(mockHomeDataSourceNetwork);
  });

  group(
    'HomeRepository',
    () {
      //
      test(
        'should have list of products',
        () async {
          final tempProducts = productsTest;

          when(mockHomeDataSourceNetwork.getProducts()).thenAnswer((_) async => tempProducts);

          expectLater(homeRepoImpl.products(), completion(equals(tempProducts)));
        },
      );

      test('should return empty list', () async {
        when(mockHomeDataSourceNetwork.getProducts()).thenAnswer((_) async => List.empty());

        expectLater(homeRepoImpl.products(), completion(isEmpty));
      });
    },
  );
}
