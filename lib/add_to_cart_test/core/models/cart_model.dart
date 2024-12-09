import 'package:flutter_tests/add_to_cart_test/core/models/product/product.dart';

class CartModel {
  final Product? product;
  final double? price;
  double? qty;

  CartModel({
    required this.product,
    required this.price,
    required this.qty,
  });
}
