import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/app/repository/abstract_repository.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/models/task_file.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';

class TaskRepositoryImpl extends AbstractRepository implements TaskRepository {
  TaskRepositoryImpl({super.apiDataSource});

  @override
  Future<List<Task>> getTasks() async {
    try {
      final data = await apiDataSource.getTasks();
      return (data['tasks'] as List<dynamic>)
          .map((e) {
            try {
              return TaskMapper.fromMap(e);
            } catch (error) {
              logger.e('Failed to parse task $e');
              return null;
            }
          })
          .where((element) => element != null)
          .toList()
          .cast<Task>();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<Task> getTaskById(int taskId) async {
    try {
      final data = await apiDataSource.getTaskById(taskId);
      return TaskMapper.fromMap(data['task']);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<Task> createTask(Map<String, dynamic> task) async {
    try {
      final data = await apiDataSource.createTask(task);
      return TaskMapper.fromMap(data['task']);
    } catch (e, stack) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e, stackTrace: stack);
      throw ParsingException();
    }
  }

  @override
  Future<List<TaskFile>> uploadImages(int taskId, List<String> paths) async {
    try {
      final data = await apiDataSource.uploadImages(taskId, paths);

      return (data['images'] as List<dynamic>)
          .map((e) {
            try {
              return TaskFileMapper.fromMap(e);
            } catch (error) {
              logger.e('Failed to parse task file $e');
              return null;
            }
          })
          .where((element) => element != null)
          .toList()
          .cast<TaskFile>();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<Map<String, dynamic>> startTask(int taskId) {
    try {
      return apiDataSource.startTask(taskId);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }
}
