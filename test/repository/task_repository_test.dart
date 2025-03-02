import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data_source/api_data_source.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/tasks/models/task_status.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:frontend/module/tasks/repository/task_repository_impl.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'my_user_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiDataSource>(), MockSpec<Logger>()])
void main() {
  setUp(() {
    logger = MockLogger();
  });

  group('Task Repository Tests', () {
    late MockApiDataSource mockApiDataSource;
    late TaskRepository taskRepository;

    setUp(() {
      mockApiDataSource = MockApiDataSource();
      taskRepository = TaskRepositoryImpl(apiDataSource: mockApiDataSource);
    });

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
        },
        {
            "Id": 9,
            "CreatedAt": "2025-02-17T21:25:12.144949Z",
            "UpdatedAt": "2025-02-17T23:04:42.983502Z",
            "DeletedAt": "2025-02-17T23:04:42.983505Z",
            "Title": "Test Title",
            "Description": "Test description",
            "Completed": false,
            "Status": "INPROGRESS",
            "UserId": 2,
            "Images": null,
            "Mesh": null
        },
        {
            "Id": 5,
            "CreatedAt": "2025-01-20T15:24:21.838719Z",
            "UpdatedAt": "2025-01-20T15:25:30.786755Z",
            "DeletedAt": "2025-01-20T15:25:30.786756Z",
            "Title": "Task",
            "Description": "Description",
            "Completed": true,
            "Status": "INITIAL",
            "UserId": 1,
            "Images": null,
            "Mesh": {
                "Id": 81,
                "Filename": "task-5.glb",
                "Url": "/objects/5/task-5.glb",
                "CreatedAt": "2025-01-20T15:25:30.785078Z",
                "UpdatedAt": "2025-01-20T15:25:30.785078Z",
                "TaskId": 5,
                "FileType": "mesh"
            }
        },
        {
            "Id": 12,
            "CreatedAt": "2025-02-17T23:33:10.750219Z",
            "UpdatedAt": "2025-02-20T09:49:17.918507Z",
            "DeletedAt": "2025-02-20T09:49:17.918507Z",
            "Title": "Test Title",
            "Description": "Test description",
            "Completed": false,
            "Status": "INPROGRESS",
            "UserId": 2,
            "Images": null,
            "Mesh": null
        },
        {
            "Id": 14,
            "CreatedAt": "2025-02-20T10:39:35.097944Z",
            "UpdatedAt": "2025-02-20T10:43:24.86747Z",
            "DeletedAt": "2025-02-20T10:43:24.867471Z",
            "Title": "cup",
            "Description": "Description",
            "Completed": false,
            "Status": "INPROGRESS",
            "UserId": 1,
            "Images": null,
            "Mesh": null
        },
        {
            "Id": 11,
            "CreatedAt": "2025-02-17T23:19:41.994009Z",
            "UpdatedAt": "2025-02-17T23:23:01.542396Z",
            "DeletedAt": "2025-02-17T23:23:01.542398Z",
            "Title": "Test Title",
            "Description": "Test description",
            "Completed": false,
            "Status": "FAILED",
            "UserId": 2,
            "Images": null,
            "Mesh": null
        },
        {
            "Id": 6,
            "CreatedAt": "2025-02-07T18:49:29.441251Z",
            "UpdatedAt": "2025-02-08T15:56:33.592913Z",
            "DeletedAt": "2025-02-08T15:56:33.592913Z",
            "Title": "Test Title",
            "Description": "Test description",
            "Completed": true,
            "Status": "INITIAL",
            "UserId": 2,
            "Images": null,
            "Mesh": {
                "Id": 166,
                "Filename": "task-6.glb",
                "Url": "/objects/6/task-6.glb",
                "CreatedAt": "2025-02-08T15:56:33.584135Z",
                "UpdatedAt": "2025-02-08T15:56:33.584135Z",
                "TaskId": 6,
                "FileType": "mesh"
            }
        },
        {
            "Id": 7,
            "CreatedAt": "2025-02-08T16:02:41.78701Z",
            "UpdatedAt": "2025-02-08T16:02:59.613645Z",
            "DeletedAt": "2025-02-08T16:02:59.613646Z",
            "Title": "Task",
            "Description": "Description",
            "Completed": true,
            "Status": "INITIAL",
            "UserId": 1,
            "Images": null,
            "Mesh": {
                "Id": 170,
                "Filename": "task-7.glb",
                "Url": "/objects/7/task-7.glb",
                "CreatedAt": "2025-02-08T16:02:59.611179Z",
                "UpdatedAt": "2025-02-08T16:02:59.611179Z",
                "TaskId": 7,
                "FileType": "mesh"
            }
        },
        {
            "Id": 15,
            "CreatedAt": "2025-02-20T11:40:59.568639Z",
            "UpdatedAt": "2025-02-20T11:41:19.272152Z",
            "DeletedAt": "2025-02-20T11:41:19.272152Z",
            "Title": "cup 2",
            "Description": "Description",
            "Completed": false,
            "Status": "INPROGRESS",
            "UserId": 1,
            "Images": null,
            "Mesh": null
        },
        {
            "Id": 8,
            "CreatedAt": "2025-02-08T16:03:38.612269Z",
            "UpdatedAt": "2025-02-08T16:04:16.810888Z",
            "DeletedAt": "2025-02-08T16:04:16.810888Z",
            "Title": "Task",
            "Description": "Description",
            "Completed": true,
            "Status": "INITIAL",
            "UserId": 1,
            "Images": null,
            "Mesh": {
                "Id": 181,
                "Filename": "task-8.glb",
                "Url": "/objects/8/task-8.glb",
                "CreatedAt": "2025-02-08T16:04:16.805124Z",
                "UpdatedAt": "2025-02-08T16:04:16.805124Z",
                "TaskId": 8,
                "FileType": "mesh"
            }
        },
        {
            "Id": 16,
            "CreatedAt": "2025-02-20T11:46:25.216473Z",
            "UpdatedAt": "2025-02-20T12:06:23.997411Z",
            "DeletedAt": "2025-02-20T12:06:23.997411Z",
            "Title": "dice",
            "Description": "Description",
            "Completed": true,
            "Status": "SUCCESS",
            "UserId": 1,
            "Images": null,
            "Mesh": {
                "Id": 331,
                "Filename": "final_model.glb",
                "Url": "objects/task-16/mvs/final_model.glb",
                "CreatedAt": "2025-02-20T12:06:23.989646Z",
                "UpdatedAt": "2025-02-20T12:06:23.989646Z",
                "TaskId": 16,
                "FileType": "mesh"
            }
        },
        {
            "Id": 13,
            "CreatedAt": "2025-02-18T14:11:43.681113Z",
            "UpdatedAt": "2025-02-20T12:15:00.833222Z",
            "DeletedAt": "2025-02-20T12:15:00.833222Z",
            "Title": "Test Title",
            "Description": "Test description",
            "Completed": true,
            "Status": "SUCCESS",
            "UserId": 2,
            "Images": null,
            "Mesh": {
                "Id": 332,
                "Filename": "final_model.glb",
                "Url": "objects/task-13/mvs/final_model.glb",
                "CreatedAt": "2025-02-20T12:15:00.830316Z",
                "UpdatedAt": "2025-02-20T12:15:00.830316Z",
                "TaskId": 13,
                "FileType": "mesh"
            }
        },
        {
            "Id": 18,
            "CreatedAt": "2025-02-20T12:35:17.601663Z",
            "UpdatedAt": "2025-02-20T12:35:17.601663Z",
            "DeletedAt": "2025-02-20T12:35:17.601663Z",
            "Title": "Test Title",
            "Description": "Test description",
            "Completed": false,
            "Status": "INITIAL",
            "UserId": 2,
            "Images": null,
            "Mesh": null
        },
        {
            "Id": 19,
            "CreatedAt": "2025-02-20T15:19:13.333893Z",
            "UpdatedAt": "2025-02-20T15:20:32.78615Z",
            "DeletedAt": "2025-02-20T15:20:32.786154Z",
            "Title": "dice 3",
            "Description": "Description",
            "Completed": false,
            "Status": "FAILED",
            "UserId": 1,
            "Images": null,
            "Mesh": null
        },
        {
            "Id": 10,
            "CreatedAt": "2025-02-17T23:04:59.696683Z",
            "UpdatedAt": "2025-02-25T14:10:04.720931Z",
            "DeletedAt": "2025-02-25T14:10:04.720932Z",
            "Title": "Test Title",
            "Description": "Test description",
            "Completed": true,
            "Status": "SUCCESS",
            "UserId": 2,
            "Images": null,
            "Mesh": {
                "Id": 510,
                "Filename": "final_model.glb",
                "Url": "objects/task-10/mvs/final_model.glb",
                "CreatedAt": "2025-02-25T14:10:04.700609Z",
                "UpdatedAt": "2025-02-25T14:10:04.700609Z",
                "TaskId": 10,
                "FileType": "mesh"
            }
        },
        {
            "Id": 17,
            "CreatedAt": "2025-02-20T12:22:56.768639Z",
            "UpdatedAt": "2025-02-25T14:27:09.272671Z",
            "DeletedAt": "2025-02-25T14:27:09.272671Z",
            "Title": "warhammer",
            "Description": "Description",
            "Completed": true,
            "Status": "SUCCESS",
            "UserId": 1,
            "Images": null,
            "Mesh": {
                "Id": 511,
                "Filename": "final_model.glb",
                "Url": "objects/task-17/mvs/final_model.glb",
                "CreatedAt": "2025-02-25T14:27:09.255389Z",
                "UpdatedAt": "2025-02-25T14:27:09.255389Z",
                "TaskId": 17,
                "FileType": "mesh"
            }
        },
        {
            "Id": 20,
            "CreatedAt": "2025-02-26T17:13:58.615888Z",
            "UpdatedAt": "2025-02-26T17:13:58.615888Z",
            "DeletedAt": "2025-02-26T17:13:58.615888Z",
            "Title": "Warhammer",
            "Description": "Test description",
            "Completed": false,
            "Status": "INITIAL",
            "UserId": 2,
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
      expect(result.length, 20);
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
  });
}
