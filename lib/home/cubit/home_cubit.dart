import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/repositories/my_user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MyUserRepository _myUserRepository = getIt();

  HomeCubit() : super(HomeInitial());

  Future<void> fetchTasks() async {
    if (state is HomeInitial) {
      emit(HomeLoading());
    }
    try {
      final tasks = await _myUserRepository.getTasks();
      emit(HomeLoaded(tasks, filteredTasks: tasks));
    } catch (e, stack) {
      logger.e("$e\n$stack");
      emit(HomeError(e.toString()));
    }
  }

  void searchTasks(String query) {
    if (state is HomeLoaded) {
      final tasks = (state as HomeLoaded).tasks;
      final filteredTasks = tasks.where((task) {
        return task.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(HomeLoaded(tasks, filteredTasks: filteredTasks));
    }
  }

  void removeTask(int taskId) {
    if (state is HomeLoaded) {
      final tasks = (state as HomeLoaded).tasks;
      final filteredTasks = (state as HomeLoaded).filteredTasks;
      final updatedTasks = tasks.where((task) => task.id != taskId).toList();
      final updatedFilteredTasks =
          filteredTasks.where((task) => task.id != taskId).toList();
      emit(HomeLoaded(updatedTasks, filteredTasks: updatedFilteredTasks));
    }
  }
}
