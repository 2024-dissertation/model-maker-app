import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/helpers/helpers.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/user/models/my_user.dart';
import 'package:frontend/module/user/repository/my_user_repository.dart';

part 'my_user_state.dart';

class MyUserCubit extends Cubit<MyUserState> {
  final MyUserRepository _myUserRepository = getIt();

  MyUserCubit() : super(MyUserInitial());

  Future<void> getMyUser() async {
    safeEmit(MyUserLoading());
    try {
      final myUser = await _myUserRepository.getMyUser();
      safeEmit(MyUserLoaded(myUser));
    } catch (e) {
      logger.e(e.toString());
      safeEmit(MyUserError(e.toString()));
      throw Exception("Failed to get my user");
    }
  }

  void clearMyUser() {
    safeEmit(MyUserInitial());
  }

  Future<void> saveUser() async {
    if (state is! MyUserLoaded) return;

    try {
      await _myUserRepository.saveMyUser((state as MyUserLoaded).myUser);
    } catch (e) {
      logger.e(e);
      return;
    }
  }

  void updateEmail(String email) {
    if (state is! MyUserLoaded) return;

    safeEmit(
      MyUserLoaded(
        (state as MyUserLoaded).myUser.copyWith(email: email),
      ),
    );
  }
}
