import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/home/cubit/home_cubit.dart';
import 'package:frontend/module/tasks/cubit/view_task_cubit.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'home_cubit_test.mocks.dart';

class MockStorage extends Mock implements Storage {}

class MockTaskRepository extends Mock implements TaskRepository {}

@GenerateNiceMocks([MockSpec<Logger>()])
void main() {
  late MockTaskRepository mockRepository;
  late MockStorage mockStorage;
  late MockLogger mockLogger;

  setUp(() {
    // Initialize mocks
    mockRepository = MockTaskRepository();
    mockStorage = MockStorage();
    mockLogger = MockLogger();

    when(() => mockStorage.write(any(), any<dynamic>()))
        .thenAnswer((_) async {});

    HydratedBloc.storage = mockStorage;

    logger = mockLogger;
  });

  group('HomeCubit', () {
    test('initial state is HomeInitial', () {
      final cubit = HomeCubit(taskRepository: mockRepository);
      expect(cubit.state, HomeInitial());
    });

    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoading, HomeLoaded] when fetchTasks succeeds',
      build: () {
        when(() => mockRepository.getTasks())
            .thenAnswer((_) async => [Task.empty]);
        return HomeCubit(taskRepository: mockRepository);
      },
      act: (cubit) => cubit.fetchTasks(),
      expect: () => [
        HomeLoading(),
        HomeLoaded([Task.empty], filteredTasks: [Task.empty])
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoaded] when searchTasks finds no results',
      build: () {
        return HomeCubit(taskRepository: mockRepository);
      },
      seed: () => HomeLoaded([Task.empty], filteredTasks: [Task.empty]),
      act: (cubit) => cubit.searchTasks('cat'),
      expect: () => [
        HomeLoaded([Task.empty], filteredTasks: [])
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoaded] when searchTasks finds results',
      build: () {
        return HomeCubit(taskRepository: mockRepository);
      },
      act: (cubit) => cubit.searchTasks('Task'),
      seed: () => HomeLoaded([Task.empty]),
      expect: () => [
        HomeLoaded([Task.empty], filteredTasks: [Task.empty])
      ],
    );

    // blocTest<HomeCubit, HomeState>(
    //   'emits [HomeLoaded] when removeTask succeeds',
    //   build: () {
    //     return HomeCubit(taskRepository: mockRepository);
    //   },
    //   act: (cubit) => cubit.removeTask(1),
    //   seed: () => HomeLoaded([Task.empty]),
    //   expect: () => [HomeLoaded([], filteredTasks: [])],
    // );
  });
}
