part of 'my_user_cubit.dart';

sealed class MyUserState extends Equatable {
  const MyUserState();

  @override
  List<Object> get props => [];
}

final class MyUserInitial extends MyUserState {}

final class MyUserLoading extends MyUserState {}

final class MyUserLoaded extends MyUserState {
  final MyUser myUser;

  const MyUserLoaded(this.myUser);

  @override
  List<Object> get props => [myUser];
}

final class MyUserError extends MyUserState {
  final String message;

  const MyUserError(this.message);

  @override
  List<Object> get props => [message];
}
