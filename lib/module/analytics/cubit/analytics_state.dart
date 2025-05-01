part of 'analytics_cubit.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object> get props => [];
}

final class AnalyticsInitial extends AnalyticsState {}

final class AnalyticsLoading extends AnalyticsState {}

final class AnalyticsLoaded extends AnalyticsState {
  final Analytics analytics;

  const AnalyticsLoaded(this.analytics);

  @override
  List<Object> get props => [analytics];
}

final class AnalyticsError extends AnalyticsState {
  final String error;

  const AnalyticsError(this.error);

  @override
  List<Object> get props => [error];
}
