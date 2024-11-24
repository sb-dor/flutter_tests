import 'package:freezed_annotation/freezed_annotation.dart';

abstract interface class UserEntity {
  @literal
  const factory UserEntity.notAuthenticated() = NotAuthenticatedUser;

  const factory UserEntity.authenticated({
    required final String uid,
    required final String? displayName,
    required final String? photoURL,
    required final String? email,
  }) = AuthenticatedUser;

  T when<T extends Object?>({
    required final T Function(AuthenticatedUser user) authenticated,
    required final T Function() notAuthenticated,
  });
}

class NotAuthenticatedUser implements UserEntity {
  // @literal
  const NotAuthenticatedUser();

  @override
  T when<T extends Object?>(
          {required T Function(AuthenticatedUser user) authenticated,
          required T Function() notAuthenticated}) =>
      notAuthenticated();
}

class AuthenticatedUser implements UserEntity {
  final String uid;
  final String? displayName;
  final String? photoURL;
  final String? email;

  const AuthenticatedUser({
    required this.uid,
    required this.displayName,
    required this.photoURL,
    required this.email,
  });

  @override
  T when<T extends Object?>(
          {required T Function(AuthenticatedUser user) authenticated,
          required T Function() notAuthenticated}) =>
      authenticated(this);

  factory AuthenticatedUser.fromJson(Map<String, Object?> json) => AuthenticatedUser(
        uid: json['id'] as String,
        displayName: json['name'] as String,
        photoURL: json['photo'] as String,
        email: json['email'] as String,
      );
}
