part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeError extends HomeState {
  const HomeError();
}

final class HomeLoaded extends HomeState {
  final List<Product> product;

  const HomeLoaded(this.product);
}
