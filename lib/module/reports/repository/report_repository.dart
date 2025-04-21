import 'package:frontend/module/reports/models/report.dart';

abstract class ReportRepository {
  Future<List<Report>> getReports();
  Future<Report> getReportById(int reportId);
  Future<Report> createReport(Map<String, dynamic> report);
}
