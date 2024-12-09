import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tests/add_to_cart_test/core/models/cart_model.dart';
import 'package:flutter_tests/add_to_cart_test/core/models/product/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  late List<CartModel> _cartItems;

  CartBloc() : super(const CartInitial(<CartModel>[])) {
    _cartItems = List.from(state.items);

    on<AddToCart>(_addToCart);

    on<RemoveFromCart>(_removeFromCart);
  }

  void _addToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) {
    final findProduct = _cartItems.firstWhereOrNull((e) => e.product?.id == event.product.id);

    if (findProduct != null) {
      findProduct.qty = findProduct.qty! + 1;
    } else {
      final cartItem = CartModel(product: event.product, price: event.product.price, qty: 1);
      _cartItems.add(cartItem);
    }
    emit(CartInitial(_cartItems));
  }

  void _removeFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) {}
}
