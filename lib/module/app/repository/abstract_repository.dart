import 'package:frontend/data_source/api_data_source.dart';
import 'package:frontend/main/main.dart';

abstract class AbstractRepository {
  final ApiDataSource apiDataSource;

  AbstractRepository({ApiDataSource? apiDataSource})
      : apiDataSource = apiDataSource ?? getIt<ApiDataSource>();
}
