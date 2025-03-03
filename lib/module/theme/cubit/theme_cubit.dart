import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/module/theme/cubit/theme_state.dart';

class ThemeCubit extends SafeHydratedCubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light);

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
