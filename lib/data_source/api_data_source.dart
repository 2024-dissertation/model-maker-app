import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/gen/assets.gen.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/user/models/my_user.dart';

class ApiDataSource {
  final Dio _client;

  firebase_auth.User get currentUser {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated exception');
    return user;
  }

  const ApiDataSource({required Dio client}) : _client = client;

  /// Get | Post

  Future<Map<String, dynamic>> _get(String path) async {
    try {
      _client.options.headers['Authorization'] =
          'Bearer ${await currentUser.getIdToken()}';
      final response = await _client.get(path);
      logger.d('GET $path ${response.statusCode} ${response.data}');
      return response.data;
    } on DioException catch (e) {
      logger.e('Failed to get $path with data ${e.response?.data}');
      throw ServerException(message: 'Request failed');
    }
  }

  Future<Map<String, dynamic>> _post(String path, Object? data) async {
    try {
      // Add auth header
      _client.options.headers['Authorization'] =
          'Bearer ${await currentUser.getIdToken()}';

      if (data is FormData) {
        logger.d('POST $path with form data: ${data.fields}');
      } else {
        logger.d('POST $path with data: $data');
      }

      final response = await _client.post(path, data: data);
      logger.d('POST $path ${response.statusCode} ${response.data}');
      return response.data;
    } on DioException catch (e) {
      logger.e('Failed to post $path with error: ${e.response?.data}');
      throw ServerException(message: 'Request failed');
    }
  }

  Future<Map<String, dynamic>> _patch(String path, Object? data) async {
    try {
      // add auth header
      _client.options.headers['Authorization'] =
          'Bearer ${await currentUser.getIdToken()}';

      if (data is FormData) {
        logger.d('PATCH $path ${data.fields}');
      }
      final response = await _client.patch(path, data: data);
      logger.d('PATCH $path ${response.statusCode} ${response.data}');
      return response.data;
    } on DioException catch (e) {
      logger.e('Failed to patch $path with data ${e.response?.data}');
      throw ServerException(message: 'Request failed');
    }
  }

  /// User
  ///
  Future<Map<String, dynamic>> getMyUser() async {
    return _post('/verify', {});
  }

  Future<Map<String, dynamic>> saveMyUser(MyUser data) async {
    return _patch('/verify', data.toMap());
  }

  /// Task
  ///
  Future<Map<String, dynamic>> getTasks() async {
    return _get('/tasks');
  }

  Future<Map<String, dynamic>> getTaskById(int id) async {
    return _get('/tasks/$id');
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    return _post('/tasks', data);
  }

  Future<Map<String, dynamic>> uploadImages(int taskId, List<String> paths) {
    List<File> files = paths.map((path) => File(path)).toList();

    final formData = FormData.fromMap({
      'files': files
          .map(
            (file) => MultipartFile.fromFileSync(file.path),
          )
          .toList(),
    });
    return _post('/tasks/$taskId/upload', formData);
  }

  Future<Map<String, dynamic>> startTask(int taskId) async {
    return _post('/tasks/$taskId/start', null);
  }
}
