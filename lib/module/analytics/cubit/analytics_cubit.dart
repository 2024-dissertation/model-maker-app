import 'package:equatable/equatable.dart';
import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/analytics/models/analytics.dart';
import 'package:frontend/module/user/repository/my_user_repository.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends SafeCubit<AnalyticsState> {
  final MyUserRepository myUserRepository = getIt();

  AnalyticsCubit() : super(AnalyticsInitial()) {
    getAnalytics();
  }

  Future<void> getAnalytics() async {
    if (state is AnalyticsInitial) {
      safeEmit(AnalyticsLoading());
    }
    try {
      final analytics = await myUserRepository.getAnalytics();
      safeEmit(AnalyticsLoaded(analytics));
    } catch (e) {
      safeEmit(AnalyticsError(e.toString()));
    }
  }
}
