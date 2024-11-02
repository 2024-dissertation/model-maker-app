part of 'scanner_cubit.dart';

sealed class ScannerState extends Equatable {
  final List<String> paths;

  const ScannerState({this.paths = const []});

  ScannerState copyWith({List<String>? paths});

  @override
  List<Object?> get props => [paths];
}

final class ScannerInitial extends ScannerState {
  const ScannerInitial({super.paths});

  @override
  ScannerState copyWith({List<String>? paths}) {
    return ScannerInitial(paths: paths ?? this.paths);
  }
}
