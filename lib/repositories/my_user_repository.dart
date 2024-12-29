import 'package:frontend/model/task.dart';
import 'package:frontend/model/task_file.dart';
import 'package:frontend/model/user.dart';

abstract class MyUserRepository {
  Future<MyUser> getMyUser();

  Future<void> saveMyUser(MyUser myUser);

  Future<void> createUser(MyUser myUser);

  Future<List<Task>> getTasks();

  Future<Task> getTaskById(int taskId);

  Future<void> saveTask(Task task);

  Future<Task> createTask(Map<String, dynamic> task);

  Future<List<TaskFile>> uploadImages(int taskId, List<String> paths);

  Future<Map<String, dynamic>> startTask(int taskId);
}
