import 'package:equatable/equatable.dart';
import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';

part 'view_task_state.dart';

class ViewTaskCubit extends SafeCubit<ViewTaskState> {
  final TaskRepository _myUserRepository = getIt();

  final int taskId;

  ViewTaskCubit(this.taskId) : super(ViewTaskInitial());

  ViewTaskCubit.preLoaded(Task task)
      : taskId = task.id,
        super(ViewTaskLoaded(task));

  Future<void> fetchTask() async {
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
      if (task.images == null) {
        return [];
      }
      return task.images!.map((e) => e.url).toList();
    } catch (e) {
      safeEmit(ViewTaskError(e.toString()));
      throw Exception("Failed to load images");
    }
  }
}
