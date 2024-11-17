import 'package:flutter_tests/add_to_cart_test/core/models/product/product.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/data/source/home_datasource.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/domain/repo/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource _homeDatasource;

  HomeRepositoryImpl(this._homeDatasource);

  @override
  Future<List<Product>> products() => _homeDatasource.getProducts();
}
