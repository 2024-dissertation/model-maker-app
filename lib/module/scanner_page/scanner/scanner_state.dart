part of 'scanner_cubit.dart';

sealed class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

final class ScannerInitial extends ScannerState {}

final class ScannerLoaded extends ScannerState {
  final List<String> paths;
  final Task? createdTask;

  const ScannerLoaded(this.paths, this.createdTask);

  @override
  List<Object?> get props => [paths, createdTask];

  ScannerState copyWith({
    List<String>? paths,
    Task? createdTask,
  }) {
    return ScannerLoaded(
      paths ?? this.paths,
      createdTask ?? this.createdTask,
    );
  }
}

final class ScannerError extends ScannerState {
  final String message;

  const ScannerError(this.message);

  @override
  List<Object> get props => [message];
}
