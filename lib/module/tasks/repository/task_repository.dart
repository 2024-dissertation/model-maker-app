import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/models/task_file.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> getTaskById(int taskId);
  Future<Task> createTask(Map<String, dynamic> task);
  Future<List<TaskFile>> uploadImages(int taskId, List<String> paths);
  Future<Map<String, dynamic>> startTask(int taskId);
  Future<List<String>> getImages(int taskId);
}
