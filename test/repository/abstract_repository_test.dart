import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/module/app/repository/abstract_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/data_source/api_data_source.dart';
import 'package:frontend/main/main.dart';

import 'abstract_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiDataSource>()])
void main() {
  group('AbstractRepository', () {
    late MockApiDataSource mockApiDataSource;

    setUp(() {
      mockApiDataSource = MockApiDataSource();
    });

    test('uses provided ApiDataSource if given', () {
      final repository = TestRepository(apiDataSource: mockApiDataSource);
      expect(repository.apiDataSource, equals(mockApiDataSource));
    });

    test('uses getIt<ApiDataSource>() when no ApiDataSource is provided', () {
      final mockInjectedApiDataSource = MockApiDataSource();
      getIt.registerSingleton<ApiDataSource>(mockInjectedApiDataSource);

      final repository = TestRepository();

      expect(repository.apiDataSource, equals(mockInjectedApiDataSource));
    });
  });
}

// Concrete implementation for testing
class TestRepository extends AbstractRepository {
  TestRepository({super.apiDataSource});
}
