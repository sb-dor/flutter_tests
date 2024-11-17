part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

final class GetProducts extends HomeEvent {
  const GetProducts();
}
