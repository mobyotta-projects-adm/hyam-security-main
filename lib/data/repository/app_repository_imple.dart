import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hyam_services/data/models/activity_logs_model.dart';
import 'package:hyam_services/data/models/guard/assigned_job_model.dart';
import 'package:hyam_services/data/models/reports/incident_report_model.dart';
import 'package:hyam_services/data/models/reports/scan_report_model.dart';
import '../../core/failure.dart';
import '../../services/connectivity_service.dart';
import '../../services/http_services.dart';
import '../../utils/logger_utils.dart';
import '../data_source/app_data_source.dart';
import '../models/guard/all_guard_model.dart';
import '../models/guard/user_model.dart';
import 'app_repository.dart';

class AppRepositoryImple extends AppRepository {
  final ConnectivityService connectivityService;
  final AppDataSource appDataSource;

  AppRepositoryImple({
    required this.appDataSource,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, User?>> login(
      {required String email, required String password}) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.login(email: email, password: password);
        if (res['status'] == '200') {
          final userResponseModel = UserResponseModel.fromJson(res);
          AppLogger.i(
              'res -> $res , user -> ${userResponseModel.response?.first}');
          return Right(userResponseModel.response?.first);
        } else {
          return Left(NotFound(
              message:
                  res['message'] ?? 'Failed to login, Invalid Credential'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to login, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await appDataSource.deleteUserSession();
      return const Right(true);
    } catch (e) {
      AppLogger.e(e.toString());
      return const Left(NotFound());
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(
      {required String userId, required File image}) {
    // TODO: implement uploadImage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CustomResponse>> register({
    required String fullName,
    required String emailId,
    required String password,
  }) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.register(
            fullName: fullName, emailId: emailId, password: password);
        if (res['status'] != null && res['status'] == '200') {
          return Right(CustomResponse(
            isSuccess: true,
            data: '',
            message: res['message'],
          ));
        } else {
          return Right(CustomResponse(
            isSuccess: false,
            data: '',
            message: res['message'],
          ));
        }
      } catch (e) {
        return Left(NotFound(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool?>> deleteUserSessionData() async {
    try {
      await appDataSource.deleteUserSession();
      return const Right(true);
    } catch (e) {
      AppLogger.e(e.toString());
      return const Left(NotFound());
    }
  }

  @override
  Future<Either<Failure, User?>> getUserSessionData() async {
    try {
      final res = await appDataSource.getUserSession();
      if (res != null) {
        return Right(res);
      }
      return const Left(NotFound(message: 'Failed to load data!'));
    } catch (e) {
      AppLogger.e(e.toString());
      return const Left(NotFound());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool?>> setUserSessionData(
      {required User user}) async {
    try {
      await appDataSource.setUserSession(userDataModel: user);
      return const Right(true);
    } catch (e) {
      AppLogger.e(e.toString());
      return const Left(NotFound());
    }
  }

  @override
  Future<Either<Failure, List<AssignedJobModel>?>> getAssignedById(
      {required String id}) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.getAssignedById(id: id);
        if (res['status'] == '200') {
          final assignedJobResponse = AssignedJobResponseModel.fromJson(res);
          return Right(assignedJobResponse.response);
        } else {
          return Left(NotFound(
              message: res['response'] ?? 'Failed to load job detail'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to load job detail, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteLatestReportData() async {
    try {
      await appDataSource.deleteLatestReportData();
      return const Right(true);
    } catch (e) {
      AppLogger.e(e.toString());
      return const Left(NotFound());
    }
  }

  @override
  Future<Either<Failure, ScanReportModel?>> getLatestReportData() async {
    try {
      final res = await appDataSource.getLatestReportData();
      return Right(res);
    } catch (e) {
      AppLogger.e('Exception to get latest report data ${e.toString()}');
      return const Left(NotFound());
    }
  }

  @override
  Future<Either<Failure, bool>> setLatestReportData(
      ScanReportModel sendReport) async {
    try {
      await appDataSource.setLatestReportData(sendReport);
      return const Right(true);
    } catch (e) {
      AppLogger.e(e.toString());
      return const Left(NotFound());
    }
  }

  @override
  Future<Either<Failure, bool>> submitScanReportData(
      ScanReportModel sendReport) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.submitScanReportData(sendReport);
        if (res['status'] == 'ok') {
          AppLogger.i('res -> $res , send report res -> ${res.toString()}');
          return const Right(true);
        } else {
          return Left(NotFound(
              message: res['message'] ?? 'Failed to Submit this report'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to login, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, bool>> endJob({required String jobId}) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.endJob(jobId: jobId);
        if (res['status'] == '200') {
          AppLogger.i('res -> $res , end job res -> ${res.toString()}');
          return const Right(true);
        } else {
          return Left(
              NotFound(message: res['response'] ?? 'Failed to End Job'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to End Job, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, bool>> startJob({required String jobId}) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.startJob(jobId: jobId);
        if (res['status'] == '200') {
          AppLogger.i('res -> $res , start job res -> ${res.toString()}');
          return const Right(true);
        } else {
          return Left(
              NotFound(message: res['response'] ?? 'Failed to Start Job'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to Start Job, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, String?>> changeJobStatus(
      {required String jobId, required String jobStatus}) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.changeJobStatus(
            jobId: jobId, jobStatus: jobStatus);
        if (res['status'] == '200') {
          AppLogger.i(
              'res -> $res , change job status res -> ${res.toString()}');
          return Right(res['response'].toString());
        } else {
          return Left(NotFound(
              message: res['response'] ?? 'Failed to change job status'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to change job status, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, List<AssignedJobModel>?>> getIncomingJobs() async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.getAllIncomingJobs();
        if (res['status'] == '200') {
          final assignedJobResponse = AssignedJobResponseModel.fromJson(res);
          return Right(assignedJobResponse.response);
        } else {
          return Left(NotFound(
              message:
                  res['response'] ?? 'Failed to load incoming job detail'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(
            NotFound(message: 'Failed to load incoming job detail, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, AssignedJobModel>> getJobById(
      {required String id}) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.getJobById(id: id);
        if (res['status'] == '200') {
          final assignedJob = AssignedJobModel.fromJson(res);
          return Right(assignedJob);
        } else {
          return Left(NotFound(
              message: res['response'] ?? 'Failed to load assigned job'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(
            NotFound(message: 'Failed to load assigned job detail, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, List<Guard>?>> getAllGuards() async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.getAllGuards();
        if (res['status'] == '200') {
          final allGuardResponseModel = AllGuardResponseModel.fromJson(res);
          return Right(allGuardResponseModel.guards);
        } else {
          return Left(NotFound(
              message: res['response'] ?? 'Failed to load scan report'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to load scan report, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, List<ScanReportModel>?>> getScanReport(
      {required String jobId}) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.getScanReport(jobId: jobId);
        if (res['status'] == '200') {
          final scanReport = ScanReportResponseModel.fromJson(res);
          return Right(scanReport.response);
        } else {
          return Left(NotFound(
              message: res['response'] ?? 'Failed to load scan report'));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to load scan report, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, bool?>> assignJob(
      {required String jobId, required String guardId}) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res =
            await appDataSource.assignJob(jobId: jobId, guardId: guardId);
        if (res['status'] == '200') {
          AppLogger.i('res -> $res , assign job res -> ${res.toString()}');
          return const Right(true);
        } else {
          return Left(
              NotFound(message: res['response'] ?? 'Failed to assign job '));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to assign job, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, bool>> sendIncidentReport(
      {required String jobId,
      required String guardId,
      required String locationName,
      required String locationAddress,
      required String guardName,
      required String incidentDescription,
      required String narrative}) async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.sendIncidentReport(
            jobId: jobId,
            guardId: guardId,
            locationName: locationName,
            locationAddress: locationAddress,
            guardName: guardName,
            incidentDescription: incidentDescription,
            narrative: narrative);
        if (res['status'] == 'ok') {
          AppLogger.i('res -> $res , incident report res -> ${res.toString()}');
          return const Right(true);
        } else {
          return Left(
              NotFound(message: res['response'] ?? 'incident report res -> '));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'incident report exception ->, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, IncidentReportModel?>> getIncidentReportModel({required String jobId, required String guardId}) async{
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res =
        await appDataSource.getIncidentReportModel(jobId: jobId, guardId: guardId);
        if (res['status'] == '200') {
          final incidentReportModel = IncidentReportModel.fromJson(res);
          AppLogger.i('res -> $res , incident report res -> ${res.toString()}');
          return Right(incidentReportModel);
        } else {
          return Left(
              NotFound(message: res['response'] ?? 'Failed to get incident report '));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to get incident report, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, bool>> sendActivityLogReport({    required String dateTime,required String jobId, required String guardId, required String locationAddress, required String guardName, required String activityLogDescription}) async{
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res = await appDataSource.sendActivityLogReport(
            jobId: jobId,
            guardId: guardId,
            locationAddress: locationAddress,
            guardName: guardName,
            activityLogDescription: activityLogDescription,
            dateTime: dateTime,
        );
        if (res['status'] == 'ok') {
          AppLogger.i('res -> $res , activity log report res -> ${res.toString()}');
          return const Right(true);
        } else {
          return Left(
              NotFound(message: res['response'] ?? 'activity log report res -> '));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'activity log report exception ->, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }

  @override
  Future<Either<Failure, ActivityLogsModel?>> getActivityLogs({required String jobId, required String guardId})async {
    if (await connectivityService.hasInternetConnectivity()) {
      try {
        final res =
        await appDataSource.getActivityLogs(jobId: jobId, guardId: guardId);
        if (res['status'] == '200') {
          final incidentReportModel = ActivityLogsModel.fromJson(res);
          AppLogger.i('res -> $res , activity logs report res -> ${res.toString()}');
          return Right(incidentReportModel);
        } else {
          return Left(
              NotFound(message: res['response'] ?? 'Failed to get activity logs report '));
        }
      } catch (e) {
        AppLogger.e(e.toString());
        return Left(NotFound(message: 'Failed to get activity logs report, $e'));
      }
    } else {
      return const Left(NotFound(message: 'Internet connection not found!'));
    }
  }
}
