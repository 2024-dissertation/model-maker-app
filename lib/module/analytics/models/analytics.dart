import 'package:dart_mappable/dart_mappable.dart';

part 'analytics.mapper.dart';

@MappableClass(caseStyle: CaseStyle.pascalCase)
class WeekOfTask with WeekOfTaskMappable {
  final String date;
  final int count;

  const WeekOfTask({
    required this.date,
    required this.count,
  });
}

@MappableClass(caseStyle: CaseStyle.pascalCase)
class AnalyticsCollection with AnalyticsCollectionMappable {
  final int count;
  final String name;

  const AnalyticsCollection({
    required this.count,
    required this.name,
  });
}

@MappableClass(caseStyle: CaseStyle.pascalCase)
class Analytics with AnalyticsMappable {
  final int collectionTotal;
  final int tasksTotal;
  final int tasksSuccess;
  final int tasksFailed;
  final List<WeekOfTask>? weekOfTasks;
  final List<AnalyticsCollection>? collections;

  const Analytics({
    required this.collectionTotal,
    required this.tasksTotal,
    required this.tasksSuccess,
    required this.tasksFailed,
    this.weekOfTasks,
    this.collections,
  });
}
