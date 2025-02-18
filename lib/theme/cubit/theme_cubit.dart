import 'package:flutter/cupertino.dart';
import 'package:frontend/helpers.dart';
import 'package:frontend/theme/cubit/theme_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light);

  // static ThemeState _getInitialTheme() {
  //   // Get system theme
  //   final brightness =
  //       WidgetsBinding.instance.platformDispatcher.platformBrightness;
  //   return brightness == Brightness.dark ? ThemeState.dark : ThemeState.light;
  // }

  void setTheme(ThemeState theme) {
    safeEmit(theme);
  }

  void toggleTheme() {
    safeEmit(state == ThemeState.dark ? ThemeState.light : ThemeState.dark);
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeStateMapper.fromValue(json['theme']);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'theme': state.toValue()};
  }
}
