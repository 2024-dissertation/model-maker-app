import 'package:frontend/model/task.dart';
import 'package:frontend/model/user.dart';

abstract class MyUserRepository {
  Future<MyUser> getMyUser();

  Future<void> saveMyUser(MyUser myUser);

  Future<void> createUser(MyUser myUser);

  Future<List<Task>> getTasks();

  Future<Task> getTaskById(int taskId);

  Future<void> saveTask(Task task);
}
