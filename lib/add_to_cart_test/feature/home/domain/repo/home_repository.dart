import 'package:flutter_tests/add_to_cart_test/core/models/product/product.dart';

abstract interface class HomeRepository {
  Future<List<Product>> products();
}
