import 'package:frontend/helpers/logger.dart';
import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/home/cubit/home_state.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';

export 'package:frontend/module/home/cubit/home_state.dart';

class HomeCubit extends SafeCubit<HomeState> {
  final TaskRepository _taskRepository;

  HomeCubit({TaskRepository? taskRepository})
      : _taskRepository = taskRepository ?? getIt(),
        super(HomeInitial());

  void clear() {
    safeEmit(HomeInitial());
  }

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

  Future<void> fetchArchivedTasks() async {
    if (state is HomeInitial) {
      safeEmit(HomeLoading());
    }
    try {
      final tasks = await _taskRepository.getArchivedTasks();
      safeEmit(HomeLoaded(tasks, filteredTasks: tasks));
    } catch (e, stack) {
      logger.e("$e\n$stack");
      safeEmit(HomeError(e.toString()));
    }
  }

  void searchTasks(String query) {
    if (state is! HomeLoaded) return;

    final tasks = (state as HomeLoaded).tasks;

    final filteredTasks = tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    safeEmit(HomeLoaded(tasks, filteredTasks: filteredTasks));
  }

  void removeTask(int taskId) {
    if (state is! HomeLoaded) return;

    final tasks = (state as HomeLoaded).tasks;

    _taskRepository.deleteTask(taskId);

    final filteredTasks = (state as HomeLoaded).filteredTasks;
    final updatedTasks = tasks.where((task) => task.id != taskId).toList();
    final updatedFilteredTasks =
        filteredTasks.where((task) => task.id != taskId).toList();

    safeEmit(HomeLoaded(updatedTasks, filteredTasks: updatedFilteredTasks));
  }

  void updateTask(Task updatedTask) {
    if (state is! HomeLoaded) return;

    final tasks = (state as HomeLoaded).tasks;
    final filteredTasks = (state as HomeLoaded).filteredTasks;

    final updatedTasks = tasks.map((task) {
      if (task.id == updatedTask.id) {
        return updatedTask;
      }
      return task;
    }).toList();

    final updatedFilteredTasks = filteredTasks.map((task) {
      if (task.id == updatedTask.id) {
        return updatedTask;
      }
      return task;
    }).toList();

    _taskRepository.saveTask(updatedTask);

    safeEmit(HomeLoaded(updatedTasks, filteredTasks: updatedFilteredTasks));
  }
}
