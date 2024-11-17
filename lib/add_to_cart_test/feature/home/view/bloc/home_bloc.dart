import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tests/add_to_cart_test/core/models/product/product.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/domain/repo/home_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc(this._homeRepository) : super(const HomeLoading()) {
    //
    on<GetProducts>(_getProducts);
  }

  void _getProducts(
    GetProducts event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    final getProducts = await _homeRepository.products();
    emit(HomeLoaded(getProducts));
  }
}
