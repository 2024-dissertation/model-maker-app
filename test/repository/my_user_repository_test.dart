import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data_source/api_data_source.dart';
import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/user/models/my_user.dart';
import 'package:frontend/module/user/repository/my_user_repository.dart';
import 'package:frontend/module/user/repository/my_user_repository_impl.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'my_user_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiDataSource>(), MockSpec<Logger>()])
void main() {
  setUp(() {
    logger = MockLogger();
  });

  group('MyUserRepository getMyUser Tests', () {
    late MockApiDataSource mockApiDataSource;
    late MyUserRepository myUserRepository;

    setUp(() {
      mockApiDataSource = MockApiDataSource();
      myUserRepository = MyUserRepositoryImpl(apiDataSource: mockApiDataSource);
    });

    test('should return user when getMyUser is called', () async {
      final data = '''
{
    "user": {
        "Id": 2,
        "CreatedAt": "2025-01-18T16:54:23.963373Z",
        "UpdatedAt": "2025-02-04T13:51:06.143185Z",
        "DeletedAt": null,
        "Email": "laister.sam@gmail.com",
        "FirebaseUid": "fZ2FW27YhLe6Va7VUQVwYfPlVVU2"
    }
}
''';

      when(mockApiDataSource.getMyUser())
          .thenAnswer((_) async => jsonDecode(data));

      // Act
      final result = await myUserRepository.getMyUser();

      // Assert
      expect(result.id, 2);
      expect(result.email, 'laister.sam@gmail.com');
      expect(result.firebaseUid, 'fZ2FW27YhLe6Va7VUQVwYfPlVVU2');
      expect(result.createdAt, '2025-01-18T16:54:23.963373Z');
      expect(result.updatedAt, '2025-02-04T13:51:06.143185Z');
      expect(result.deletedAt, null);

      expect(result.dtCreatedAt, DateTime.parse('2025-01-18T16:54:23.963373Z'));
      expect(result.dtUpdatedAt, DateTime.parse('2025-02-04T13:51:06.143185Z'));
      expect(result.dtDeletedAt, null);

      verify(mockApiDataSource.getMyUser()).called(1);
    });

    test('should throw ServerException when getMyUser fails', () async {
      when(mockApiDataSource.getMyUser()).thenThrow(ServerException());

      // Act
      final call = myUserRepository.getMyUser();

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });

    test('should throw NetworkException when getMyUser fails', () async {
      when(mockApiDataSource.getMyUser()).thenThrow(NetworkException());

      // Act
      final call = myUserRepository.getMyUser();

      // Assert
      expect(call, throwsA(isA<NetworkException>()));
    });

    test('should throw ParsingException when getMyUser fails to parse',
        () async {
      // Data without 'user' key
      when(mockApiDataSource.getMyUser()).thenAnswer((_) async => {});

      // Act
      final call = myUserRepository.getMyUser();

      // Assert
      expect(call, throwsA(isA<ParsingException>()));
    });
  });

  group('MyUserRepository saveMyUser Tests', () {
    late MockApiDataSource mockApiDataSource;
    late MyUserRepository myUserRepository;

    setUp(() {
      mockApiDataSource = MockApiDataSource();
      myUserRepository = MyUserRepositoryImpl(apiDataSource: mockApiDataSource);
    });

    test('should return user when saveMyUser is called', () async {
      final data = '''
{
    "user": {
        "Id": 2,
        "CreatedAt": "2025-01-18T16:54:23.963373Z",
        "UpdatedAt": "2025-02-04T13:51:06.143185Z",
        "DeletedAt": null,
        "Email": "laister.sam@gmail.com",
        "FirebaseUid": "fZ2FW27YhLe6Va7VUQVwYfPlVVU2"
    }
}
''';

      final MyUser myUser = MyUser(
        id: 2,
        email: 'laister.sam@gmail.com',
        firebaseUid: 'fZ2FW27YhLe6Va7VUQVwYfPlVVU2',
        createdAt: '2025-01-18T16:54:23.963373Z',
        updatedAt: '2025-02-04T13:51:06.143185Z',
        deletedAt: null,
      );

      when(mockApiDataSource.saveMyUser(any))
          .thenAnswer((_) async => jsonDecode(data));

      // Act
      final result = await myUserRepository.saveMyUser(myUser);

      // Assert
      expect(result.id, 2);
      expect(result.email, 'laister.sam@gmail.com');
      expect(result.firebaseUid, 'fZ2FW27YhLe6Va7VUQVwYfPlVVU2');
      expect(result.createdAt, '2025-01-18T16:54:23.963373Z');
      expect(result.updatedAt, '2025-02-04T13:51:06.143185Z');
      expect(result.deletedAt, null);

      expect(result.dtCreatedAt, DateTime.parse('2025-01-18T16:54:23.963373Z'));
      expect(result.dtUpdatedAt, DateTime.parse('2025-02-04T13:51:06.143185Z'));
      expect(result.dtDeletedAt, null);

      verify(mockApiDataSource.saveMyUser(any)).called(1);
    });

    test('should throw ServerException when saveMyUser fails', () async {
      when(mockApiDataSource.saveMyUser(any)).thenThrow(ServerException());

      final MyUser myUser = MyUser(
        id: 2,
        email: 'laister.sam@gmail.com',
        firebaseUid: 'fZ2FW27YhLe6Va7VUQVwYfPlVVU2',
        createdAt: '2025-01-18T16:54:23.963373Z',
        updatedAt: '2025-02-04T13:51:06.143185Z',
        deletedAt: null,
      );

      // Act
      final call = myUserRepository.saveMyUser(myUser);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });

    test('should throw NetworkException when getMyUser fails', () async {
      when(mockApiDataSource.saveMyUser(any)).thenThrow(NetworkException());

      final MyUser myUser = MyUser(
        id: 2,
        email: 'laister.sam@gmail.com',
        firebaseUid: 'fZ2FW27YhLe6Va7VUQVwYfPlVVU2',
        createdAt: '2025-01-18T16:54:23.963373Z',
        updatedAt: '2025-02-04T13:51:06.143185Z',
        deletedAt: null,
      );

      // Act
      final call = myUserRepository.saveMyUser(myUser);

      // Assert
      expect(call, throwsA(isA<NetworkException>()));
    });

    test('should throw ParsingException when getMyUser fails to parse',
        () async {
      // Data without 'user' key
      when(mockApiDataSource.saveMyUser(any)).thenAnswer((_) async => {});

      final MyUser myUser = MyUser(
        id: 2,
        email: 'laister.sam@gmail.com',
        firebaseUid: 'fZ2FW27YhLe6Va7VUQVwYfPlVVU2',
        createdAt: '2025-01-18T16:54:23.963373Z',
        updatedAt: '2025-02-04T13:51:06.143185Z',
        deletedAt: null,
      );

      // Act
      final call = myUserRepository.saveMyUser(myUser);

      // Assert
      expect(call, throwsA(isA<ParsingException>()));
    });
  });
}
