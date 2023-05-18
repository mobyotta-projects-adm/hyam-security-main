import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hyam_services/data/models/activity_logs_model.dart';
import 'package:hyam_services/data/models/guard/all_guard_model.dart';
import 'package:hyam_services/data/models/guard/assigned_job_model.dart';
import 'package:hyam_services/data/models/reports/incident_report_model.dart';
import 'package:hyam_services/data/models/reports/scan_report_model.dart';
import '../../core/failure.dart';
import '../../services/http_services.dart';
import '../models/guard/user_model.dart';

abstract class AppRepository {
  Future<Either<Failure, User?>> login(
      {required String email, required String password});

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, CustomResponse>> register({
    required String fullName,
    required String emailId,
    required String password,
  });

  Future<Either<Failure, User?>> getUserSessionData();

  Future<Either<Failure, bool?>> deleteUserSessionData();

  Future<Either<Failure, bool?>> setUserSessionData({required User user});

  Future<Either<Failure, List<AssignedJobModel>?>> getAssignedById(
      {required String id});

  Future<Either<Failure, ScanReportModel?>> getLatestReportData();

  Future<Either<Failure, bool>> setLatestReportData(ScanReportModel sendReport);

  Future<Either<Failure, bool>> deleteLatestReportData();

  Future<Either<Failure, bool>> submitScanReportData(
      ScanReportModel sendReport);

  Future<Either<Failure, bool>> startJob({required String jobId});

  Future<Either<Failure, bool>> endJob({required String jobId});

  Future<Either<Failure, List<AssignedJobModel>?>> getIncomingJobs();

  Future<Either<Failure, String?>> changeJobStatus(
      {required String jobId, required String jobStatus});

  Future<Either<Failure, AssignedJobModel>> getJobById({required String id});

  Future<Either<Failure, List<Guard>?>> getAllGuards();

  Future<Either<Failure, List<ScanReportModel>?>> getScanReport(
      {required String jobId});

  Future<Either<Failure, bool?>> assignJob(
      {required String jobId, required String guardId});

  Future<Either<Failure, bool>> sendIncidentReport(
      {required String jobId,
      required String guardId,
      required String locationName,
      required String locationAddress,
      required String guardName,
      required String incidentDescription,
      required String narrative});

  Future<Either<Failure, IncidentReportModel?>> getIncidentReportModel({
    required String jobId,
    required String guardId,
  });

  Future<Either<Failure, bool>> sendActivityLogReport(
      {required String jobId,
      required String guardId,
      required String locationAddress,
      required String guardName,
      required String activityLogDescription,    required String dateTime,});

  Future<Either<Failure, ActivityLogsModel?>>  getActivityLogs({required String jobId, required String guardId});
}
