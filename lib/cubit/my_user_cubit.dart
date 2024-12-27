import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/repositories/my_user_repository.dart';

part 'my_user_state.dart';

class MyUserCubit extends Cubit<MyUserState> {
  final MyUserRepository _myUserRepository = getIt();
  MyUserCubit() : super(MyUserInitial());

  Future<void> getMyUser() async {
    emit(MyUserLoading());
    try {
      final myUser = await _myUserRepository.getMyUser();
      emit(MyUserLoaded(myUser));
    } catch (e) {
      logger.e(e.toString());
      emit(MyUserError(e.toString()));
      throw Exception("Failed to get my user");
    }
  }

  void clearMyUser() {
    emit(MyUserInitial());
  }
}
