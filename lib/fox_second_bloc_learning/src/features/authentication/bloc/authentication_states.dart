import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/models/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_states.freezed.dart';

@freezed
sealed class AuthenticationStates with _$AuthenticationStates {
  // map comes from inside
  UserEntity? get authenticatedUser => maybeMap(
        authenticated: (state) => state.user,
        inProgress: (state) => state.user,
        orElse: () => null,
      );

  // checks only your preferred state and returns anything that related to return function
  // other functions will not be considered and you can return anything you want
  // also you can create like this for each state
  // in order to not emit same state again and again
  //
  // NOTE!
  // if you want to use transformers with freezed
  // the best solution for transformer is "concurrent()"
  // but you have to created getters for each state (optional, one is enough)
  // in order to check whether specific state is working and you can not to emit particular
  // state again while it's in precess (you can call other events at that time)
  bool get isInProgress => maybeMap(orElse: () => false, inProgress: (_) => true);

  bool get loginProgress => maybeMap(orElse: () => false, loginProgress: (_) => true);

  const AuthenticationStates._();

  const factory AuthenticationStates.authenticated(UserEntity user) = AuthenticatedState;

  const factory AuthenticationStates.loginProgress({
    @Default(UserEntity.notAuthenticated()) UserEntity user,
  }) = LoginProgressState;

  const factory AuthenticationStates.inProgress({
    @Default(UserEntity.notAuthenticated()) UserEntity user,
  }) = InProgressAuthenticationState;

  const factory AuthenticationStates.unAuthenticated({
    @Default(UserEntity.notAuthenticated()) UserEntity user,
  }) = UnAuthenticated;

  const factory AuthenticationStates.error({
    @Default(UserEntity.notAuthenticated()) UserEntity user,
    String? message,
  }) = ErrorAuthenticatedState;
}
