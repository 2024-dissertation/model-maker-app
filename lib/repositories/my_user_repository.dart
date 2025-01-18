import 'package:frontend/data_source/api_data_source.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/model/task_file.dart';
import 'package:frontend/model/user.dart';

class MyUserRepository {
  final ApiDataSource _fDataSource = getIt();

  Future<MyUser> getMyUser() async {
    final data = await _fDataSource.getMyUser();
    return MyUser.fromMap(data['user']);
  }

  Future<MyUser> updateMyUser(MyUser user) async {
    final data = await _fDataSource.saveMyUser(user);
    return MyUser.fromMap(data['user']);
  }

  Future<void> saveMyUser(MyUser myUser) {
    return _fDataSource.saveMyUser(myUser);
  }

  Future<void> createUser(MyUser myUser) {
    return _fDataSource.createUser(myUser);
  }

  Future<List<Task>> getTasks() async {
    final data = await _fDataSource.getTasks();
    return data['tasks'].map<Task>((task) => Task.fromMap(task)).toList();
  }

  Future<Task> getTaskById(int taskId) async {
    final data = await _fDataSource.getTaskById(taskId);
    return Task.fromMap(data['task']);
  }

  Future<void> saveTask(Task task) {
    return _fDataSource.saveTask(task);
  }

  Future<Task> createTask(Map<String, dynamic> task) async {
    final data = await _fDataSource.createTask(task);
    return Task.fromMap(data['task']);
  }

  Future<List<TaskFile>> uploadImages(int taskId, List<String> paths) async {
    final data = await _fDataSource.uploadImages(taskId, paths);
    return data['images']
        .map<TaskFile>((image) => TaskFile.fromMap(image))
        .toList();
  }

  Future<Map<String, dynamic>> startTask(int taskId) {
    return _fDataSource.startTask(taskId);
  }
}
