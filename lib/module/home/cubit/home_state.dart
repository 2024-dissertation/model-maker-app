import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/module/tasks/models/task.dart';

part 'home_state.mapper.dart';

@MappableClass()
sealed class HomeState with HomeStateMappable {
  const HomeState();
}

@MappableClass()
final class HomeInitial extends HomeState with HomeInitialMappable {}

@MappableClass()
final class HomeLoading extends HomeState with HomeLoadingMappable {}

@MappableClass()
final class HomeLoaded extends HomeState with HomeLoadedMappable {
  final List<Task> tasks;
  final List<Task> filteredTasks;

  const HomeLoaded(this.tasks, {this.filteredTasks = const []});
}

@MappableClass()
final class HomeError extends HomeState with HomeErrorMappable {
  final String message;

  const HomeError(this.message);
}
