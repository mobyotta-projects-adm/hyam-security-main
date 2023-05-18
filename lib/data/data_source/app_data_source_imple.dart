import 'package:hyam_services/data/models/reports/scan_report_model.dart';

import '../../services/app_json_store.dart';
import '../../services/base_api.dart';
import '../../services/http_services.dart';
import '../models/guard/user_model.dart';
import 'app_data_source.dart';

class AppDataSourceImple extends AppDataSource {
  final ApiProvider apiProvider;
  final AppJsonStore appJsonStore;

  AppDataSourceImple({required this.apiProvider, required this.appJsonStore});

  @override
  Future<User?> getUserSession() async {
    return await appJsonStore.getUserData();
  }

  @override
  Future<void> deleteUserSession() async {
    await appJsonStore.deleteUserSessionData();
  }

  @override
  Future<User?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<dynamic> login(
      {required String email, required String password}) async {
    var data = ({
      "email": email,
      "password": password,
    });
    return await apiProvider.post(
      url: BaseApi.login,
      data: data,
    );
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<User> getUserById() {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future register(
      {required String fullName,
      required String emailId,
      required String password}) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> setUserSession({required User userDataModel}) async {
    await appJsonStore.setUserData(userDataModel);
  }

  @override
  Future<void> deleteLatestReportData() async {
    await appJsonStore.deleteUserSessionData();
  }

  @override
  Future<ScanReportModel?> getLatestReportData() async {
    return await appJsonStore.getLatestReportData();
  }

  @override
  Future<void> setLatestReportData(ScanReportModel sendReport) async {
    await appJsonStore.setLatestReportData(sendReport);
  }

  @override
  Future<dynamic> getAssignedById({required String id}) async {
    return await apiProvider.get(
      '${BaseApi.getAssignedJobById}?guardid=$id',
    );
  }

  @override
  Future submitScanReportData(ScanReportModel sendReport) async {
    var data = ({
      "guard_id": sendReport.guardId,
      "job_id": sendReport.jobId,
      "checkpoint_no": sendReport.chekpointNo,
      "job_name": sendReport.jobName,
      "job_address": sendReport.jobAddress,
      "unique_code": sendReport.uniqueCode,
      "geotag": sendReport.geotag,
      "checkpoint_date_time": sendReport.checkpointDateTime,
      "description": sendReport.description,
    });
    return await apiProvider.post(
      url: BaseApi.sendScanReport,
      data: data,
    );
  }

  @override
  Future endJob({required String jobId}) async {
    var data = ({
      "jobid": jobId,
    });
    return await apiProvider.post(
      url: BaseApi.endJob,
      data: data,
    );
  }

  @override
  Future startJob({required String jobId}) async {
    var data = ({
      "jobid": jobId,
    });
    return await apiProvider.post(
      url: BaseApi.startJob,
      data: data,
    );
  }

  @override
  Future<dynamic> changeJobStatus(
      {required String jobId, required String jobStatus}) async {
    var data = ({
      "jobid": jobId,
      "jobstatus": jobStatus,
    });
    return await apiProvider.post(
      url: BaseApi.changeJobStatus,
      data: data,
    );
  }

  @override
  Future<dynamic> getAllIncomingJobs() async {
    return await apiProvider.get(
      BaseApi.getAllIncomingJobs,
    );
  }

  @override
  Future getJobById({required String id}) async {
    return await apiProvider.get(
      '${BaseApi.getJobByID}?jobid=$id',
    );
  }

  @override
  Future getAllGuards() async {
    return await apiProvider.get(
      BaseApi.getAllGuards,
    );
  }

  @override
  Future getScanReport({required String jobId}) async {
    return await apiProvider.get(
      '${BaseApi.getReportsByJobID}?jobid=$jobId',
    );
  }

  @override
  Future assignJob({required String jobId, required String guardId}) async {
    var data = ({
      "jobassignto": guardId,
      "jobid": jobId,
    });
    return await apiProvider.post(
      url: BaseApi.assignJobToGuard,
      data: data,
    );
  }

  @override
  Future sendIncidentReport(
      {required String jobId,
      required String guardId,
      required String locationName,
      required String locationAddress,
      required String guardName,
      required String incidentDescription,
      required String narrative}) async {
    var data = ({
      "guard_id": guardId,
      "job_id": jobId,
      "location_name": locationName,
      "location_address": locationAddress,
      "guard_name": guardName,
      "incident_description": incidentDescription,
      "narrative": narrative,
    });
    return await apiProvider.post(
      url: BaseApi.sendIncidentReport,
      data: data,
    );
  }

  @override
  Future getIncidentReportModel({required String jobId, required String guardId}) async{
    return await apiProvider.get(
      '${BaseApi.getIncidentsByJobAndGuard}?jobid=$jobId&guardid=$guardId',
    );
  }

  @override
  Future sendActivityLogReport({    required String dateTime,required String jobId, required String guardId, required String locationAddress, required String guardName, required String activityLogDescription}) async{
    var data = ({
      "guard_id": guardId,
      "job_id": jobId,
      "actlog_location": locationAddress,
      "guard_name": guardName,
      "actlog_description": activityLogDescription,
      "actlog_time": dateTime,
    });
    return await apiProvider.post(
      url: BaseApi.sendActivityLog,
      data: data,
    );
  }

  @override
  Future getActivityLogs({required String jobId, required String guardId}) async{
    return await apiProvider.get(
      '${BaseApi.getActivityLogByGuardAndJob}?jobid=$jobId&guardid=$guardId',
    );
  }
}
