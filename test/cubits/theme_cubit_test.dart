import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:frontend/module/theme/cubit/theme_cubit.dart';
import 'package:frontend/module/theme/cubit/theme_state.dart';

// Mock storage for HydratedBloc
class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(
      () => storage.write(any(), any<dynamic>()),
    ).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('ThemeCubit', () {
    test('initial state is ThemeState.light', () {
      final cubit = ThemeCubit();
      expect(cubit.state, ThemeState.light);
    });

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeState.dark] when setTheme(ThemeState.dark) is called',
      build: () => ThemeCubit(),
      act: (cubit) => cubit.setTheme(ThemeState.dark),
      expect: () => [ThemeState.dark],
    );

    blocTest<ThemeCubit, ThemeState>(
      'toggles theme correctly',
      build: () => ThemeCubit(),
      act: (cubit) {
        cubit.toggleTheme(); // light -> dark
        cubit.toggleTheme(); // dark -> light
      },
      expect: () => [ThemeState.dark, ThemeState.light],
    );

    test('fromJson() correctly converts JSON to ThemeState', () {
      final cubit = ThemeCubit();
      expect(cubit.fromJson({'theme': 'dark'}), ThemeState.dark);
      expect(cubit.fromJson({'theme': 'light'}), ThemeState.light);
    });

    test('toJson() correctly converts ThemeState to JSON', () {
      final cubit = ThemeCubit();
      expect(cubit.toJson(ThemeState.dark), {'theme': 'dark'});
      expect(cubit.toJson(ThemeState.light), {'theme': 'light'});
    });
  });
}
