import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/tasks/cubit/view_task_cubit.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/models/task_file.dart';
import 'package:frontend/module/tasks/models/task_status.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'my_user_cubit_test.mocks.dart';

class MockStorage extends Mock implements Storage {}

class MockTaskRepository extends Mock implements TaskRepository {}

@GenerateNiceMocks([MockSpec<Logger>()])
void main() {
  late MockTaskRepository mockRepository;
  late MockStorage mockStorage;
  late MockLogger mockLogger;
  late Task testTask;

  setUp(() {
    // Initialize mocks
    mockRepository = MockTaskRepository();
    mockStorage = MockStorage();
    mockLogger = MockLogger();

    when(() => mockStorage.write(any(), any<dynamic>()))
        .thenAnswer((_) async {});

    HydratedBloc.storage = mockStorage;

    // Sample user data
    testTask = Task(
      id: 1,
      title: 'Warhammer',
      description: 'Description',
      completed: false,
      userID: 1,
      createdAt: '',
      updatedAt: '',
      status: TaskStatus.INITIAL,
      images: [
        TaskFile.empty.copyWith(url: 'http://example.com'),
        TaskFile.empty.copyWith(url: 'http://example.com'),
      ],
    );

    logger = mockLogger;
  });

  group('ViewTaskCubit', () {
    test('initial state is ViewTaskInitial', () {
      final cubit = ViewTaskCubit(testTask.id, taskRepository: mockRepository);
      expect(cubit.state, ViewTaskInitial());
    });

    blocTest<ViewTaskCubit, ViewTaskState>(
      'emits [ViewTaskLoading, ViewTaskLoaded] when fetchTask succeeds',
      build: () {
        when(() => mockRepository.getTaskById(testTask.id))
            .thenAnswer((_) async => testTask);
        return ViewTaskCubit(testTask.id, taskRepository: mockRepository);
      },
      act: (cubit) => cubit.fetchTask(),
      expect: () => [ViewTaskLoading(), ViewTaskLoaded(testTask)],
    );

    blocTest<ViewTaskCubit, ViewTaskState>(
      'emits [ViewTaskLoading, ViewTaskError] when fetchTask fails',
      build: () {
        when(() => mockRepository.getTaskById(testTask.id))
            .thenThrow(ParsingException());
        return ViewTaskCubit(testTask.id, taskRepository: mockRepository);
      },
      act: (cubit) => cubit.fetchTask(),
      expect: () => [ViewTaskLoading(), isA<ViewTaskError>()],
    );
  });
}
