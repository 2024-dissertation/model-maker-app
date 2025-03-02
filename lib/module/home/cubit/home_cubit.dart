import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/helpers/helpers.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TaskRepository _taskRepository = getIt();

  HomeCubit() : super(HomeInitial());

  Future<void> fetchTasks() async {
    if (state is HomeInitial) {
      safeEmit(HomeLoading());
    }
    try {
      final tasks = await _taskRepository.getTasks();
      safeEmit(HomeLoaded(tasks, filteredTasks: tasks));
    } catch (e, stack) {
      logger.e("$e\n$stack");
      safeEmit(HomeError(e.toString()));
    }
  }

  void searchTasks(String query) {
    if (state is HomeLoaded) {
      final tasks = (state as HomeLoaded).tasks;
      final filteredTasks = tasks.where((task) {
        return task.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      safeEmit(HomeLoaded(tasks, filteredTasks: filteredTasks));
    }
  }

  void removeTask(int taskId) {
    if (state is HomeLoaded) {
      final tasks = (state as HomeLoaded).tasks;
      final filteredTasks = (state as HomeLoaded).filteredTasks;
      final updatedTasks = tasks.where((task) => task.id != taskId).toList();
      final updatedFilteredTasks =
          filteredTasks.where((task) => task.id != taskId).toList();
      safeEmit(HomeLoaded(updatedTasks, filteredTasks: updatedFilteredTasks));
    }
  }
}
