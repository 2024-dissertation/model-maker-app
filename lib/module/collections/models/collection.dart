import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/module/tasks/models/task.dart';

part 'collection.mapper.dart';

@MappableClass(caseStyle: CaseStyle.pascalCase)
class Collection with CollectionMappable {
  final int id;
  final String name;
  final List<Task>? tasks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Collection({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.tasks,
  });
}
