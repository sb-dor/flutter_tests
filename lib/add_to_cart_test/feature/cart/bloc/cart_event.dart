part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;

  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final Product product;

  RemoveFromCart(this.product);
}
