import 'package:dio/dio.dart';
import 'package:frontend/data_source/api_data_source.dart';
import 'package:frontend/helpers/globals.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/auth/repository/auth_repository.dart';
import 'package:frontend/module/auth/repository/auth_repository_impl.dart';
import 'package:frontend/module/collections/repository/collection_repository.dart';
import 'package:frontend/module/collections/repository/collection_repository_impl.dart';
import 'package:frontend/module/reports/repository/report_repository.dart';
import 'package:frontend/module/reports/repository/report_repository_impl.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:frontend/module/tasks/repository/task_repository_impl.dart';
import 'package:frontend/module/user/repository/my_user_repository.dart';
import 'package:frontend/module/user/repository/my_user_repository_impl.dart';

void injectDependencies() {
  final _client = Dio();
  _client.options.baseUrl = Globals.baseUrl;
  _client.options.validateStatus = (status) => status! < 500;

  getIt.registerLazySingleton(() => ApiDataSource(client: _client));

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<MyUserRepository>(() => MyUserRepositoryImpl());
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl());
  getIt.registerLazySingleton<ReportRepository>(() => ReportRepositoryImpl());
  getIt.registerLazySingleton<CollectionRepository>(
      () => CollectionRepositoryImpl());
}
