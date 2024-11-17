import 'package:flutter_tests/add_to_cart_test/feature/cart/bloc/cart_bloc.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/view/bloc/home_bloc.dart';

class DependencyContainer {
  final HomeBloc homeBloc;

  final CartBloc cartBloc;

  DependencyContainer({
    required this.homeBloc,
    required this.cartBloc,
  });
}
