part of 'view_task_cubit.dart';

sealed class ViewTaskState extends Equatable {
  const ViewTaskState();

  @override
  List<Object> get props => [];
}

final class ViewTaskInitial extends ViewTaskState {}

final class ViewTaskLoading extends ViewTaskState {}

final class ViewTaskLoaded extends ViewTaskState {
  final Task task;

  const ViewTaskLoaded(this.task);

  @override
  List<Object> get props => [task];
}

final class ViewTaskError extends ViewTaskState {
  final String message;

  const ViewTaskError(this.message);

  @override
  List<Object> get props => [message];
}
