import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/module/user/models/my_user.dart';

void main() {
  group('MyUser JSON Parsing', () {
    test('should correctly parse JSON into UserMeBasic', () {
      final json = '''
{
    "Id": 2,
    "CreatedAt": "2025-01-18T16:54:23.963373Z",
    "UpdatedAt": "2025-02-04T13:51:06.143185Z",
    "DeletedAt": null,
    "Email": "laister.sam@gmail.com",
    "FirebaseUid": "fZ2FW27YhLe6Va7VUQVwYfPlVVU2"
}
''';

      // Convert JSON to Object
      final result = MyUserMapper.fromJson(json);

      // Assertions
      expect(result.id, 2);
      expect(result.email, 'laister.sam@gmail.com');
      expect(result.firebaseUid, 'fZ2FW27YhLe6Va7VUQVwYfPlVVU2');
      expect(result.createdAt, '2025-01-18T16:54:23.963373Z');
      expect(result.updatedAt, '2025-02-04T13:51:06.143185Z');
      expect(result.deletedAt, null);

      expect(result.dtCreatedAt, DateTime.parse('2025-01-18T16:54:23.963373Z'));
      expect(result.dtUpdatedAt, DateTime.parse('2025-02-04T13:51:06.143185Z'));
      expect(result.dtDeletedAt, null);
    });

    test('should correctly parse JSON Map into UserMeBasic', () {
      final json = '''
{
    "Id": 2,
    "CreatedAt": "2025-01-18T16:54:23.963373Z",
    "UpdatedAt": "2025-02-04T13:51:06.143185Z",
    "DeletedAt": null,
    "Email": "laister.sam@gmail.com",
    "FirebaseUid": "fZ2FW27YhLe6Va7VUQVwYfPlVVU2"
}
''';

      // Convert JSON to Object
      final result = MyUserMapper.fromMap(jsonDecode(json));

      // Assertions
      expect(result.id, 2);
      expect(result.email, 'laister.sam@gmail.com');
      expect(result.firebaseUid, 'fZ2FW27YhLe6Va7VUQVwYfPlVVU2');
      expect(result.createdAt, '2025-01-18T16:54:23.963373Z');
      expect(result.updatedAt, '2025-02-04T13:51:06.143185Z');
      expect(result.deletedAt, null);

      expect(result.dtCreatedAt, DateTime.parse('2025-01-18T16:54:23.963373Z'));
      expect(result.dtUpdatedAt, DateTime.parse('2025-02-04T13:51:06.143185Z'));
      expect(result.dtDeletedAt, null);
    });
  });
}
