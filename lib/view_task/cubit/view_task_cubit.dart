import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/helpers.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/repositories/my_user_repository.dart';

part 'view_task_state.dart';

class ViewTaskCubit extends Cubit<ViewTaskState> {
  final MyUserRepository _myUserRepository = getIt();

  ViewTaskCubit(int taskId) : super(ViewTaskInitial()) {
    _fetchTask(taskId);
  }

  ViewTaskCubit.preLoaded(Task task) : super(ViewTaskLoaded(task));

  Future<void> _fetchTask(int taskId) async {
    if (state is ViewTaskInitial) {
      safeEmit(ViewTaskLoading());
    }

    try {
      final task = await _myUserRepository.getTaskById(taskId);
      safeEmit(ViewTaskLoaded(task));
    } catch (e) {
      safeEmit(ViewTaskError(e.toString()));
      throw Exception("Failed to load task");
    }
  }

  Future<List<String>> getImages(int taskId) async {
    try {
      final task = await _myUserRepository.getTaskById(taskId);
      return task.images.map((e) => e.url).toList();
    } catch (e) {
      safeEmit(ViewTaskError(e.toString()));
      throw Exception("Failed to load images");
    }
  }
}
