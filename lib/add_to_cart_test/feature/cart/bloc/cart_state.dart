part of 'cart_bloc.dart';

@immutable
sealed class CartState {
  final List<CartModel> items;

  const CartState(this.items);
}

final class CartInitial extends CartState {
  const CartInitial(super.items);
}
