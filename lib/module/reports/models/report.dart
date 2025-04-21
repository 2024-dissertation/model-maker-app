import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/module/reports/models/report_type.dart';

part 'report.mapper.dart';

@MappableClass(caseStyle: CaseStyle.pascalCase)
class Report with ReportMappable {
  final int id;
  final String title;
  final String body;
  final ReportType reportType;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Report({
    required this.id,
    required this.title,
    required this.body,
    required this.reportType,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
