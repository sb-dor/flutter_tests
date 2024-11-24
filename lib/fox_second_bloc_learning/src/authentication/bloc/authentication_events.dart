import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_events.freezed.dart';

@freezed
class AuthenticationBlocEvents with _$AuthenticationBlocEvents {
  const factory AuthenticationBlocEvents.logIn({
    required String email,
    required String password,
  }) = LogInAuthenticationEvent;

  const factory AuthenticationBlocEvents.logOut() = LogOutAuthenticationEvent;

  const factory AuthenticationBlocEvents.checkAuth() = CheckAuthenticationEvent;
}
