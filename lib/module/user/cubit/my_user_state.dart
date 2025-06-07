import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/module/user/models/my_user.dart';

part 'my_user_state.mapper.dart';

@MappableClass()
sealed class MyUserState with MyUserStateMappable {
  const MyUserState();

  bool get isAuthenticated => switch (this) {
        MyUserLoaded() => true,
        _ => false,
      };
}

@MappableClass()
final class MyUserInitial extends MyUserState with MyUserInitialMappable {
  const MyUserInitial();
}

@MappableClass()
final class MyUserLoading extends MyUserState with MyUserLoadingMappable {
  const MyUserLoading();
}

@MappableClass()
final class MyUserLoaded extends MyUserState with MyUserLoadedMappable {
  final MyUser myUser;

  const MyUserLoaded(this.myUser);
}

@MappableClass()
final class MyUserSignedOut extends MyUserState with MyUserSignedOutMappable {
  const MyUserSignedOut();
}

@MappableClass()
final class MyUserError extends MyUserState with MyUserErrorMappable {
  final String message;

  const MyUserError(this.message);
}
