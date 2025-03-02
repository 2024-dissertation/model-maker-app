part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<Task> tasks;
  final List<Task> filteredTasks;

  const HomeLoaded(this.tasks, {this.filteredTasks = const []});

  @override
  List<Object> get props => [tasks, filteredTasks];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

final class HomeLoading extends HomeState {}
