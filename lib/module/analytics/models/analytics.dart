import 'package:dart_mappable/dart_mappable.dart';

part 'analytics.mapper.dart';

@MappableClass(caseStyle: CaseStyle.pascalCase)
class Analytics with AnalyticsMappable {
  final int id;
  final int totalModels;
  final int totalCollections;

  final Map<String, int> modelsOverTime;
  final Map<String, int> collectionsByModelCount;

  static const empty = Analytics(
    id: 0,
    totalModels: 15,
    totalCollections: 5,
    modelsOverTime: {
      '2023-01-01': 56,
      '2023-01-02': 14,
      '2023-01-03': 76,
      '2023-01-04': 43,
      '2023-01-05': 62,
    },
    collectionsByModelCount: {
      '1': 1,
      '2': 2,
      '3': 3,
      '4': 4,
      '5': 5,
    },
  );

  const Analytics({
    required this.id,
    required this.totalModels,
    required this.totalCollections,
    required this.modelsOverTime,
    required this.collectionsByModelCount,
  });
}
