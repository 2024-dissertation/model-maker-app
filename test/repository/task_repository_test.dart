import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data_source/api_data_source.dart';
import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/models/task_status.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:frontend/module/tasks/repository/task_repository_impl.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'my_user_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiDataSource>(), MockSpec<Logger>()])
void main() {
  late MockApiDataSource mockApiDataSource;
  late TaskRepository taskRepository;

  setUp(() {
    mockApiDataSource = MockApiDataSource();
    logger = MockLogger();

    taskRepository = TaskRepositoryImpl(apiDataSource: mockApiDataSource);
  });

  group('TaskRepository getTask Tests', () {
    test('should return List<Task> when getTasks is called', () async {
      final data = '''
{
    "tasks": [
        {
            "Id": 2,
            "CreatedAt": "2025-01-18T16:54:23.979123Z",
            "UpdatedAt": "2025-01-18T17:04:29.461158Z",
            "DeletedAt": "2025-01-18T17:04:29.461159Z",
            "Title": "Test Title",
            "Description": "Test description",
            "Completed": true,
            "Status": "INITIAL",
            "UserId": 2,
            "Images": null,
            "Mesh": {
                "Id": 24,
                "Filename": "task-2.glb",
                "Url": "/objects/2/task-2.glb",
                "CreatedAt": "2025-01-18T17:04:29.458012Z",
                "UpdatedAt": "2025-01-18T17:04:29.458012Z",
                "TaskId": 2,
                "FileType": "mesh"
            }
        },
        {
            "Id": 1,
            "CreatedAt": "2025-01-18T16:53:37.108412Z",
            "UpdatedAt": "2025-01-18T17:07:43.910028Z",
            "DeletedAt": "2025-01-18T17:07:43.910028Z",
            "Title": "Test task",
            "Description": "Test Description",
            "Completed": true,
            "Status": "INITIAL",
            "UserId": 1,
            "Images": null,
            "Mesh": {
                "Id": 25,
                "Filename": "task-1.glb",
                "Url": "/objects/1/task-1.glb",
                "CreatedAt": "2025-01-18T17:07:43.906099Z",
                "UpdatedAt": "2025-01-18T17:07:43.906099Z",
                "TaskId": 1,
                "FileType": "mesh"
            }
        },
        {
            "Id": 3,
            "CreatedAt": "2025-01-20T15:13:48.67263Z",
            "UpdatedAt": "2025-01-20T15:17:28.031412Z",
            "DeletedAt": "2025-01-20T15:17:28.031413Z",
            "Title": "Task",
            "Description": "Description",
            "Completed": false,
            "Status": "INITIAL",
            "UserId": 1,
            "Images": null,
            "Mesh": null
        },
        {
            "Id": 4,
            "CreatedAt": "2025-01-20T15:24:02.637938Z",
            "UpdatedAt": "2025-01-20T15:24:02.637938Z",
            "DeletedAt": "2025-01-20T15:24:02.637938Z",
            "Title": "Task",
            "Description": "Description",
            "Completed": false,
            "Status": "INITIAL",
            "UserId": 1,
            "Images": null,
            "Mesh": null
        }
    ]
}
''';

      when(mockApiDataSource.getTasks())
          .thenAnswer((_) async => jsonDecode(data));

      // Act
      final result = await taskRepository.getTasks();

      // Assert
      expect(result.length, 4);
      expect(result[0].id, 2);
      expect(result[0].title, 'Test Title');
      expect(result[0].description, 'Test description');
      expect(result[0].completed, true);
      expect(result[0].userID, 2);
      expect(result[0].status, TaskStatus.INITIAL);
      expect(result[0].createdAt, '2025-01-18T16:54:23.979123Z');
      expect(result[0].updatedAt, '2025-01-18T17:04:29.461158Z');
      expect(result[0].deletedAt, '2025-01-18T17:04:29.461159Z');
      expect(result[0].mesh!.id, 24);
      expect(result[0].mesh!.filename, 'task-2.glb');
      expect(result[0].mesh!.url, '/objects/2/task-2.glb');
      expect(result[0].mesh!.createdAt, '2025-01-18T17:04:29.458012Z');
      expect(result[0].mesh!.updatedAt, '2025-01-18T17:04:29.458012Z');
      expect(result[0].mesh!.taskID, 2);

      verify(mockApiDataSource.getTasks()).called(1);
    });

    test('should throw ServerException when getTasks fails', () async {
      when(mockApiDataSource.getTasks()).thenThrow(ServerException());

      // Act
      final call = taskRepository.getTasks();

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });

    test('should throw NetworkException when getTasks fails', () async {
      when(mockApiDataSource.getTasks()).thenThrow(NetworkException());

      // Act
      final call = taskRepository.getTasks();

      // Assert
      expect(call, throwsA(isA<NetworkException>()));
    });

    test('should throw ParsingException when getTasks fails to parse',
        () async {
      // Data without 'user' key
      when(mockApiDataSource.getTasks()).thenAnswer((_) async => {});

      // Act
      final call = taskRepository.getTasks();

      // Assert
      expect(call, throwsA(isA<ParsingException>()));
    });
  });

  group('TaskRepository getTaskById Tests', () {
    test('should return Task when getTaskById is called', () async {
      final data = '''
{
    "task": {
        "Id": 10,
        "CreatedAt": "2025-02-17T23:04:59.696683Z",
        "UpdatedAt": "2025-02-25T14:10:04.720931Z",
        "DeletedAt": "2025-02-25T14:10:04.720932Z",
        "Title": "Test Title",
        "Description": "Test description",
        "Completed": true,
        "Status": "SUCCESS",
        "UserId": 2,
        "Images": [
            {
                "Id": 204,
                "Filename": "task-10-3.jpg",
                "Url": "/uploads/task-10/task-10-3.jpg",
                "CreatedAt": "2025-02-17T23:05:05.787882Z",
                "UpdatedAt": "2025-02-17T23:05:05.787882Z",
                "TaskId": 10,
                "FileType": "upload"
            },
            {
                "Id": 205,
                "Filename": "task-10-5.jpg",
                "Url": "/uploads/task-10/task-10-5.jpg",
                "CreatedAt": "2025-02-17T23:05:05.79347Z",
                "UpdatedAt": "2025-02-17T23:05:05.79347Z",
                "TaskId": 10,
                "FileType": "upload"
            }
        ],
        "Mesh": {
            "Id": 215,
            "Filename": "scene_dense_mesh_refine_texture.ply",
            "Url": "objects/task-10/scene_dense_mesh_refine_texture.ply",
            "CreatedAt": "2025-02-17T23:13:21.892173Z",
            "UpdatedAt": "2025-02-17T23:13:21.892173Z",
            "TaskId": 10,
            "FileType": "mesh"
        }
    }
}
''';

      when(mockApiDataSource.getTaskById(any))
          .thenAnswer((_) async => jsonDecode(data));

      // Act
      final result = await taskRepository.getTaskById(10);

      // Assert
      expect(result, isA<Task>());
      expect(result.id, 10);
      expect(result.title, 'Test Title');
      expect(result.description, 'Test description');
      expect(result.completed, true);
      expect(result.userID, 2);
      expect(result.status, TaskStatus.SUCCESS);
      expect(result.createdAt, '2025-02-17T23:04:59.696683Z');
      expect(result.updatedAt, '2025-02-25T14:10:04.720931Z');
      expect(result.deletedAt, '2025-02-25T14:10:04.720932Z');
      expect(result.images!.length, 2);
      expect(result.mesh!.id, 215);
      expect(result.mesh!.filename, 'scene_dense_mesh_refine_texture.ply');
      expect(result.mesh!.url,
          'objects/task-10/scene_dense_mesh_refine_texture.ply');
      expect(result.mesh!.createdAt, '2025-02-17T23:13:21.892173Z');
      expect(result.mesh!.updatedAt, '2025-02-17T23:13:21.892173Z');
      expect(result.mesh!.taskID, 10);
    });

    test('should throw ServerException when getTaskById fails', () async {
      when(mockApiDataSource.getTaskById(any)).thenThrow(ServerException());

      // Act
      final call = taskRepository.getTaskById(1);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });

    test('should throw NetworkException when getTaskById fails', () async {
      when(mockApiDataSource.getTaskById(any)).thenThrow(NetworkException());

      // Act
      final call = taskRepository.getTaskById(1);

      // Assert
      expect(call, throwsA(isA<NetworkException>()));
    });

    test('should throw ParsingException when getTaskById fails to parse',
        () async {
      // Data without 'user' key
      when(mockApiDataSource.getTaskById(any)).thenAnswer((_) async => {});

      // Act
      final call = taskRepository.getTaskById(1);

      // Assert
      expect(call, throwsA(isA<ParsingException>()));
    });
  });

  group('TaskRepository createTask Tests', () {
    test('should return Task when createTask is called', () async {
      final data = '''
{
    "task": {
        "Id": 21,
        "CreatedAt": "2025-03-02T23:41:48.059815Z",
        "UpdatedAt": "2025-03-02T23:41:48.059815Z",
        "DeletedAt": "2025-03-02T23:41:48.059815Z",
        "Title": "Warhammer",
        "Description": "Test description",
        "Completed": false,
        "Status": "INITIAL",
        "UserId": 2,
        "Images": null,
        "Mesh": null
    }
}
''';

      final payload = {"title": "Warhammer", "description": "Test description"};

      when(mockApiDataSource.createTask(any))
          .thenAnswer((_) async => jsonDecode(data));

      // Act
      final result = await taskRepository.createTask(payload);

      // Assert
      expect(result, isA<Task>());
      expect(result.title, 'Warhammer');
      expect(result.description, 'Test description');
    });

    test('should throw ServerException when createTask fails', () async {
      when(mockApiDataSource.createTask(any)).thenThrow(ServerException());

      final task = Task(
        id: 1,
        title: 'Warhammer',
        description: 'Description',
        completed: false,
        userID: 1,
        createdAt: '',
        updatedAt: '',
        status: TaskStatus.INITIAL,
      );

      // Act
      final call = taskRepository.createTask(task.toMap());

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });

    test('should throw NetworkException when createTask fails', () async {
      when(mockApiDataSource.createTask(any)).thenThrow(NetworkException());

      final task = Task(
        id: 1,
        title: 'Warhammer',
        description: 'Description',
        completed: false,
        userID: 1,
        createdAt: '',
        updatedAt: '',
        status: TaskStatus.INITIAL,
      );

      // Act
      final call = taskRepository.createTask(task.toMap());

      // Assert
      expect(call, throwsA(isA<NetworkException>()));
    });

    test('should throw ParsingException when createTask fails to parse',
        () async {
      // Data without 'user' key
      when(mockApiDataSource.createTask(any)).thenAnswer((_) async => {});

      final task = Task(
        id: 1,
        title: 'Warhammer',
        description: 'Description',
        completed: false,
        userID: 1,
        createdAt: '',
        updatedAt: '',
        status: TaskStatus.INITIAL,
      );

      // Act
      final call = taskRepository.createTask(task.toMap());

      // Assert
      expect(call, throwsA(isA<ParsingException>()));
    });
  });

  group('TaskRepository uploadImages Tests', () {
    test('should return List<TaskFile> when uploadTaskFile is called',
        () async {
      final data = '''
{
    "images": [
        {
            "Id": 512,
            "Filename": "task-21-0.png",
            "Url": "/uploads/task-21/task-21-0.png",
            "CreatedAt": "2025-03-02T23:48:51.60844Z",
            "UpdatedAt": "2025-03-02T23:48:51.60844Z",
            "TaskId": 21,
            "FileType": "upload"
        }
    ],
    "message": "Files uploaded successfully"
}
''';

      when(mockApiDataSource.uploadImages(any, any))
          .thenAnswer((_) async => jsonDecode(data));

      // Act
      final result = await taskRepository.uploadImages(21, ['/images/etc']);

      // Assert
      expect(result.length, 1);
      expect(result[0].id, 512);
      expect(result[0].filename, 'task-21-0.png');
      expect(result[0].url, '/uploads/task-21/task-21-0.png');
      expect(result[0].createdAt, '2025-03-02T23:48:51.60844Z');
      expect(result[0].updatedAt, '2025-03-02T23:48:51.60844Z');
      expect(result[0].taskID, 21);
    });

    test('should throw NetworkException when uploadTaskFile fails', () async {
      when(mockApiDataSource.uploadImages(any, any))
          .thenThrow(NetworkException());

      final data = ['image1', 'image2'];

      // Act
      final call = taskRepository.uploadImages(1, data);

      // Assert
      expect(call, throwsA(isA<NetworkException>()));
    });

    test('should throw ServerException when uploadTaskFile fails', () async {
      when(mockApiDataSource.uploadImages(any, any))
          .thenThrow(ServerException());

      final data = ['image1', 'image2'];

      // Act
      final call = taskRepository.uploadImages(1, data);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });

    test('should throw ParsingException when uploadTaskFile fails', () async {
      when(mockApiDataSource.uploadImages(any, any))
          .thenAnswer((_) async => {});

      final data = ['image1', 'image2'];

      // Act
      final call = taskRepository.uploadImages(1, data);

      // Assert
      expect(call, throwsA(isA<ParsingException>()));
    });
  });

  group('TaskRepository startTask Tests', () {
    test('should return updated status when startTask is called', () async {
      final data = '''
{
    "message": "Task started successfully"
}
''';

      when(mockApiDataSource.startTask(any))
          .thenAnswer((_) async => jsonDecode(data));

      // Act
      final result = await taskRepository.startTask(21);

      // Assert
      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['message'], isA<String>());
      verify(mockApiDataSource.startTask(21)).called(1);
    });

    test('should throw NetworkException when startTask fails', () async {
      when(mockApiDataSource.startTask(any)).thenThrow(NetworkException());

      // Act
      final call = taskRepository.startTask(1);

      // Assert
      expect(call, throwsA(isA<NetworkException>()));
    });

    test('should throw ServerException when startTask fails', () async {
      when(mockApiDataSource.startTask(any)).thenThrow(ServerException());

      // Act
      final call = taskRepository.startTask(1);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });

    test('should throw ParsingException when startTask fails', () async {
      when(mockApiDataSource.startTask(any)).thenThrow(ParsingException());

      // Act
      final call = taskRepository.startTask(1);

      // Assert
      expect(call, throwsA(isA<ParsingException>()));
    });
  });
}
