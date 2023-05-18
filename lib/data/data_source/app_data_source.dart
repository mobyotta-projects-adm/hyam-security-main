import '../models/guard/user_model.dart';
import '../models/reports/scan_report_model.dart';

abstract class AppDataSource {
  Future<dynamic> login({required String email, required String password});

  Future<dynamic> register(
      {required String fullName,
      required String emailId,
      required String password});

  Future<User> getUserById();

  Future<bool> logout();

  Future<void> deleteUserSession();

  Future<void> setUserSession({required User userDataModel});

  Future<User?> getUserSession();

  Future<ScanReportModel?> getLatestReportData();

  Future<void> setLatestReportData(ScanReportModel sendReport);

  Future<void> deleteLatestReportData();

  Future<dynamic> submitScanReportData(ScanReportModel sendReport);

  Future<dynamic> getAssignedById({required String id});

  Future<dynamic> getJobById({required String id});

  Future<dynamic> startJob({required String jobId});

  Future<dynamic> endJob({required String jobId});

  Future<dynamic> getAllIncomingJobs();

  Future<dynamic> changeJobStatus(
      {required String jobId, required String jobStatus});

  Future<dynamic> getAllGuards();

  Future<dynamic> getScanReport({required String jobId});

  Future<dynamic> assignJob({required String jobId, required String guardId});

  Future<dynamic> sendIncidentReport({
    required String jobId,
    required String guardId,
    required String locationName,
    required String locationAddress,
    required String guardName,
    required String incidentDescription,
    required String narrative,
  });

  Future<dynamic> getIncidentReportModel({
    required String jobId,
    required String guardId,
  });

  Future<dynamic> sendActivityLogReport({
    required String jobId,
    required String guardId,
    required String locationAddress,
    required String guardName,
    required String activityLogDescription,
    required String dateTime,
  });

 Future<dynamic> getActivityLogs({
    required String jobId,
    required String guardId,
  });

}
