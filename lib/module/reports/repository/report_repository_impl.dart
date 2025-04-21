import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/app/repository/abstract_repository.dart';
import 'package:frontend/module/reports/models/report.dart';
import 'package:frontend/module/reports/repository/report_repository.dart';

class ReportRepositoryImpl extends AbstractRepository
    implements ReportRepository {
  ReportRepositoryImpl({super.apiDataSource});

  @override
  Future<Report> createReport(Map<String, dynamic> report) async {
    try {
      final data = await apiDataSource.createReport(report);
      return ReportMapper.fromMap(data['report']);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<Report> getReportById(int reportId) async {
    try {
      final data = await apiDataSource.getReportById(reportId);
      return ReportMapper.fromMap(data['report']);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<List<Report>> getReports() async {
    try {
      final data = await apiDataSource.getReports();
      return (data['reports'] as List<dynamic>)
          .map((e) {
            try {
              return ReportMapper.fromMap(e);
            } catch (error) {
              logger.e('Failed to parse report $e');
              return null;
            }
          })
          .where((element) => element != null)
          .toList()
          .cast<Report>();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }
}
