part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthUnknown extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class AuthLoading extends AuthState {}

final class AuthUnauth extends AuthState {}
