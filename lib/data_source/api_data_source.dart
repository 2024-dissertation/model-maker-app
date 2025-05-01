import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/chatbox/models/chat_message.dart';
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

  Future<dynamic> _delete(String path) async {
    try {
      _client.options.headers['Authorization'] =
          'Bearer ${await currentUser.getIdToken()}';
      final response = await _client.delete(path);
      logger.d('DELETE $path ${response.statusCode} ${response.data}');
      return response.data;
    } on DioException catch (e) {
      logger.e('Failed to delete $path with data ${e.response?.data}');
      throw ServerException(message: 'Request failed');
    }
  }

  Future<Map<String, dynamic>> _put(String path, Object? data) async {
    try {
      // add auth header
      _client.options.headers['Authorization'] =
          'Bearer ${await currentUser.getIdToken()}';

      if (data is FormData) {
        logger.d('PUT $path ${data.fields}');
      }
      final response = await _client.put(path, data: data);
      logger.d('PUT $path ${response.statusCode} ${response.data}');
      return response.data;
    } on DioException catch (e) {
      logger.e('Failed to put $path with data ${e.response?.data}');
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

  Future<void> deleteTask(int taskId) async {
    return _delete('/tasks/$taskId');
  }

  Future<Map<String, dynamic>> saveTask(Map<String, dynamic> data) async {
    return _put('/tasks', data);
  }

  Future<Map<String, dynamic>> sendMessage(int taskId, String message) async {
    final data = {
      'message': message,
      'sender': 'USER',
    };
    return _post('/tasks/$taskId/message', data);
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

  // Collections
  Future<Map<String, dynamic>> getCollections() async {
    return _get('/collections');
  }

  Future<Map<String, dynamic>> getCollectionById(int id) async {
    return _get('/collections/$id');
  }

  Future<Map<String, dynamic>> createCollection(
      Map<String, dynamic> data) async {
    return _post('/collections', data);
  }

  Future<Map<String, dynamic>> updateCollection(
      Map<String, dynamic> data) async {
    return _put('/collections', data);
  }

  Future<dynamic> deleteCollection(int collectionId) async {
    return _delete('/collections/$collectionId');
  }

  // Reports

  Future<Map<String, dynamic>> getReports() async {
    return _get('/reports');
  }

  Future<Map<String, dynamic>> getReportById(int id) async {
    return _get('/reports/$id');
  }

  Future<Map<String, dynamic>> createReport(Map<String, dynamic> data) async {
    return _post('/reports', data);
  }

  Future<Map<String, dynamic>> updateReport(
      int reportId, Map<String, dynamic> data) async {
    return _patch('/reports/$reportId', data);
  }

  Future<Map<String, dynamic>> deleteReport(int reportId) async {
    return _post('/reports/$reportId/delete', null);
  }

  Future<Map<String, dynamic>> getAnalytics() async {
    return _get('/analytics');
  }
}
