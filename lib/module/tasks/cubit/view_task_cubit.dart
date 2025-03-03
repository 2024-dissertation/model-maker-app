import 'package:equatable/equatable.dart';
import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';

part 'view_task_state.dart';

class ViewTaskCubit extends SafeCubit<ViewTaskState> {
  final TaskRepository _taskRepository;

  final int taskId;

  ViewTaskCubit(this.taskId, {TaskRepository? taskRepository})
      : _taskRepository = taskRepository ?? getIt(),
        super(ViewTaskInitial());

  ViewTaskCubit.preLoaded(Task task, {TaskRepository? taskRepository})
      : taskId = task.id,
        _taskRepository = taskRepository ?? getIt(),
        super(ViewTaskLoaded(task));

  Future<void> fetchTask() async {
    if (state is ViewTaskInitial) {
      safeEmit(ViewTaskLoading());
    }

    try {
      final task = await _taskRepository.getTaskById(taskId);
      safeEmit(ViewTaskLoaded(task));
    } catch (e) {
      safeEmit(ViewTaskError(e.toString()));
    }
  }
}
