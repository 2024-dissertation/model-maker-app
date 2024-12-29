import 'package:frontend/data_source/api_data_source.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/model/task_file.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/repositories/my_user_repository.dart';

class MyUserRepositoryImp extends MyUserRepository {
  final ApiDataSource _fDataSource = getIt();

  @override
  Future<MyUser> getMyUser() async {
    final data = await _fDataSource.getMyUser();
    return MyUser.fromMap(data['user']);
  }

  @override
  Future<void> saveMyUser(MyUser myUser) {
    return _fDataSource.saveMyUser(myUser);
  }

  @override
  Future<void> createUser(MyUser myUser) {
    return _fDataSource.createUser(myUser);
  }

  @override
  Future<List<Task>> getTasks() async {
    final data = await _fDataSource.getTasks();
    return data['tasks'].map<Task>((task) => Task.fromMap(task)).toList();
  }

  @override
  Future<Task> getTaskById(int taskId) async {
    final data = await _fDataSource.getTaskById(taskId);
    return Task.fromMap(data['task']);
  }

  @override
  Future<void> saveTask(Task task) {
    return _fDataSource.saveTask(task);
  }

  @override
  Future<Task> createTask(Map<String, dynamic> task) async {
    final data = await _fDataSource.createTask(task);
    return Task.fromMap(data['task']);
  }

  @override
  Future<List<TaskFile>> uploadImages(int taskId, List<String> paths) async {
    final data = await _fDataSource.uploadImages(taskId, paths);
    return data['images']
        .map<TaskFile>((image) => TaskFile.fromMap(image))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> startTask(int taskId) {
    return _fDataSource.startTask(taskId);
  }
}
