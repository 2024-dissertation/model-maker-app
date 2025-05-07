import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/user/models/my_user.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';
import 'package:frontend/module/user/repository/my_user_repository.dart';

import 'my_user_cubit_test.mocks.dart';

class MockStorage extends Mock implements Storage {}

class MockMyUserRepository extends Mock implements MyUserRepository {}

@GenerateNiceMocks([MockSpec<Logger>()])
void main() {
  late MockMyUserRepository mockRepository;
  late MockStorage mockStorage;
  late MockLogger mockLogger;
  late MyUser testUser;

  setUp(() {
    // Initialize mocks
    mockRepository = MockMyUserRepository();
    mockStorage = MockStorage();
    mockLogger = MockLogger();

    when(() => mockStorage.write(any(), any<dynamic>()))
        .thenAnswer((_) async {});

    HydratedBloc.storage = mockStorage;

    // Sample user data
    testUser = MyUser(
      id: 123,
      email: 'test@example.com',
      firebaseUid: '',
      createdAt: '',
      updatedAt: '',
    );

    logger = mockLogger;
  });

  group('MyUserCubit', () {
    test('initial state is MyUserInitial', () {
      final cubit = MyUserCubit(myUserRepository: mockRepository);
      expect(cubit.state, MyUserInitial());
    });

    // blocTest<MyUserCubit, MyUserState>(
    //   'emits [MyUserLoading, MyUserLoaded] when getMyUser succeeds',
    //   build: () {
    //     when(() => mockRepository.getMyUser())
    //         .thenAnswer((_) async => testUser);
    //     return MyUserCubit(myUserRepository: mockRepository);
    //   },
    //   act: (cubit) => cubit.getMyUser(),
    //   expect: () => [MyUserLoading(), MyUserLoaded(testUser)],
    // );

    blocTest<MyUserCubit, MyUserState>(
      'emits [MyUserLoading, MyUserError] when getMyUser fails',
      build: () {
        when(() => mockRepository.getMyUser()).thenThrow(Exception('Failed'));
        return MyUserCubit(myUserRepository: mockRepository);
      },
      act: (cubit) => cubit.getMyUser(),
      expect: () => [MyUserLoading(), isA<MyUserError>()],
    );

    blocTest<MyUserCubit, MyUserState>(
      'emits MyUserInitial when clearMyUser is called',
      build: () => MyUserCubit(myUserRepository: mockRepository),
      act: (cubit) => cubit.clearMyUser(),
      expect: () => [MyUserInitial()],
    );

    blocTest<MyUserCubit, MyUserState>(
      'does not emit when saveUser is called without MyUserLoaded state',
      build: () => MyUserCubit(myUserRepository: mockRepository),
      act: (cubit) => cubit.saveUser(),
      expect: () => [],
    );

    blocTest<MyUserCubit, MyUserState>(
      'calls repository to save user when saveUser is called',
      build: () {
        when(() => mockRepository.saveMyUser(testUser)).thenAnswer(
          (_) async => MyUser.empty,
        );
        return MyUserCubit(myUserRepository: mockRepository);
      },
      seed: () => MyUserLoaded(testUser),
      act: (cubit) => cubit.saveUser(),
      verify: (_) {
        verify(() => mockRepository.saveMyUser(testUser)).called(1);
      },
    );

    blocTest<MyUserCubit, MyUserState>(
      'updates user email when updateEmail is called',
      build: () => MyUserCubit(myUserRepository: mockRepository),
      seed: () => MyUserLoaded(testUser),
      act: (cubit) => cubit.updateEmail('new@example.com'),
      expect: () => [MyUserLoaded(testUser.copyWith(email: 'new@example.com'))],
    );
  });
}
