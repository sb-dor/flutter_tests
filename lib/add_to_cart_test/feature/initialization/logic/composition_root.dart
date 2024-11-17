import 'package:flutter_tests/add_to_cart_test/feature/cart/bloc/cart_bloc.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/data/repo/home_repository_impl.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/data/source/home_datasource.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/domain/repo/home_repository.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/view/bloc/home_bloc.dart';
import 'package:flutter_tests/add_to_cart_test/feature/initialization/model/dependency_container.dart';
import 'package:http/http.dart' as http;

final class CompositionRoot {
  //
  Future<CompositionResult> compose() async {
    final dependencies = await DependencyFactory().create();

    return CompositionResult(dependencies);
  }
}

class CompositionResult {
  final DependencyContainer dependencyContainer;

  CompositionResult(this.dependencyContainer);
}

abstract class Factory<T> {
  T create();
}

abstract class AsyncFactory<T> {
  Future<T> create();
}

class DependencyFactory extends AsyncFactory<DependencyContainer> {
  //
  @override
  Future<DependencyContainer> create() async {
    final homeBloc = HomeBlocFactory().create();

    final cartBloc = CartBloc();

    final dependencyContainer = DependencyContainer(
      homeBloc: homeBloc,
      cartBloc: cartBloc,
    );

    return dependencyContainer;
  }
}

class HomeBlocFactory extends Factory<HomeBloc> {
  @override
  HomeBloc create() {
    final httpClient = http.Client();

    final HomeDatasource homeDatasource = HomeDataSourceNetwork(httpClient);

    final HomeRepository homeRepository = HomeRepositoryImpl(homeDatasource);

    return HomeBloc(homeRepository);
  }
}
