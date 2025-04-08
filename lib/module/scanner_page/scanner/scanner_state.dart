import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/module/tasks/models/task.dart';

part 'scanner_state.mapper.dart';

@MappableClass()
final class ScannerState with ScannerStateMappable {
  final List<String> paths;
  final Task? createdTask;

  final String? error;

  const ScannerState(this.paths, this.createdTask, this.error);
}
