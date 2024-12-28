import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:frontend/logger.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/model/user.dart';

class ApiDataSource {
  final Dio _client;

  firebase_auth.User get currentUser {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated exception');
    return user;
  }

  ApiDataSource({Dio? client}) : _client = client ?? Dio() {
    _client.options.baseUrl = 'http://localhost:3333';
  }

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
      throw Exception('Request failed');
    }
  }

  Future<Map<String, dynamic>> _post(
      String path, Map<String, dynamic> data) async {
    try {
      // add auth header
      _client.options.headers['Authorization'] =
          'Bearer ${await currentUser.getIdToken()}';
      final response = await _client.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      logger.e('Failed to get $path with data ${e.response?.data}');
      throw Exception('Request failed');
    }
  }

  /// User
  ///
  Future<Map<String, dynamic>> getMyUser() async {
    return _get('/login');
  }

  Future<Map<String, dynamic>> saveMyUser(MyUser data) async {
    return _post('/user', data.toMap());
  }

  Future<Map<String, dynamic>> createUser(MyUser data) async {
    return _post('/register', data.toMap());
  }

  /// Task
  ///
  Future<Map<String, dynamic>> getTasks() async {
    return _get('/tasks');
  }

  Future<Map<String, dynamic>> getTaskById(int id) async {
    return _get('/tasks/$id');
  }

  Future<Map<String, dynamic>> saveTask(Task data) async {
    return _post('/tasks', data.toMap());
  }
}
