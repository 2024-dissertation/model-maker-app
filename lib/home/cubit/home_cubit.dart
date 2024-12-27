import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/repositories/my_user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MyUserRepository _myUserRepository = getIt();

  HomeCubit() : super(HomeInitial());

  Future<void> fetchTasks() async {
    emit(HomeLoading());
    try {
      final tasks = await _myUserRepository.getTasks();
      emit(HomeLoaded(tasks));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
