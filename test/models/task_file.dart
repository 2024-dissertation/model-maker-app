import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/models/task_status.dart';

void main() {
  group('Task JSON Parsing', () {
    test('should correctly parse JSON into Task', () {
      final json = '''
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
        },
        {
            "Id": 206,
            "Filename": "task-10-8.jpg",
            "Url": "/uploads/task-10/task-10-8.jpg",
            "CreatedAt": "2025-02-17T23:05:05.794674Z",
            "UpdatedAt": "2025-02-17T23:05:05.794674Z",
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
''';

      // Convert JSON to Object
      final result = TaskMapper.fromJson(json);

      // Assertions
      expect(result.id, 10);
      expect(result.title, 'Test Title');
      expect(result.description, 'Test description');
      expect(result.completed, true);
      expect(result.userID, 2);
      expect(result.createdAt, '2025-02-17T23:04:59.696683Z');
      expect(result.updatedAt, '2025-02-25T14:10:04.720931Z');
      expect(result.deletedAt, '2025-02-25T14:10:04.720932Z');
      expect(result.status, TaskStatus.SUCCESS);
      expect(result.images.length, 3);
      expect(result.mesh!.id, 215);
      expect(result.mesh!.filename, 'scene_dense_mesh_refine_texture.ply');
      expect(result.mesh!.url,
          'objects/task-10/scene_dense_mesh_refine_texture.ply');
      expect(result.mesh!.createdAt, '2025-02-17T23:13:21.892173Z');
      expect(result.mesh!.updatedAt, '2025-02-17T23:13:21.892173Z');
      expect(result.mesh!.taskID, 10);
    });
  });
}
