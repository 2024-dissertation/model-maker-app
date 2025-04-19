import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(AnalyticsInitial());
}
