import 'package:hyam_services/utils/logger_utils.dart';
import 'package:json_store/json_store.dart';

import '../data/models/guard/assigned_job_model.dart';
import '../data/models/guard/user_model.dart';
import '../data/models/reports/scan_report_model.dart';

class AppJsonStore {
  late final JsonStore jsonStore;

  AppJsonStore.init() {
    jsonStore = JsonStore();
  }

  Future<User?> getUserData() async {
    final jsonData = await jsonStore.getItem('guard_session');
    if (jsonData != null) {
      return User.fromJson(jsonData);
    }
    return null;
  }

  Future<void> setUserData(User userDataModel) async {
    await jsonStore.setItem('guard_session', userDataModel.toJson());
  }

  Future<void> deleteUserSessionData() async {
    return await jsonStore.deleteItem('guard_session');
  }

  Future<ScanReportModel?> getLatestReportData() async {
    final jsonData = await jsonStore.getItem('report_data');
    AppLogger.i('latest scan report -> $jsonData');
    if (jsonData != null) {
      return ScanReportModel.fromJson(jsonData);
    }
    return null;
  }

  Future<void> setLatestReportData(ScanReportModel sendReport) async {
    AppLogger.i('set scan report in dir-> ${sendReport.toJson()}');
    await jsonStore.setItem('report_data', sendReport.toJson());
  }

  Future<void> deleteLatestReportData() async {
    return await jsonStore.deleteItem('report_data');
  }


  Future<AssignedJobModel?> getOnGoingJob() async {
    final jsonData = await jsonStore.getItem('on_going_job');
    AppLogger.i('on going job -> $jsonData');
    if (jsonData != null) {
      return AssignedJobModel.fromJson(jsonData);
    }
    return null;
  }

  Future<bool> setOnGoingJob(AssignedJobModel assignedJobModel) async {
   try {
      await jsonStore.setItem(
         'on_going_job', assignedJobModel.toJson());
     return true;
   }catch(e){
     AppLogger.i('on going job set error -> $e');
     return false;
   }
  }


// Future<void> deleteUserSessionData() async {
  //   return await jsonStore.deleteItem('guard_session');
  // }
  //
  // Future<ScanReportModel?> getLatestReportData() async {
  //   final jsonData = await jsonStore.getItem('report_data');
  //   AppLogger.i('latest scan report -> $jsonData');
  //   if (jsonData != null) {
  //     return ScanReportModel.fromJson(jsonData);
  //   }
  //   return null;
  // }
  //
  // Future<void> setLatestReportData(ScanReportModel sendReport) async {
  //   AppLogger.i('set scan report in dir-> ${sendReport.toJson()}');
  //   await jsonStore.setItem('report_data', sendReport.toJson());
  // }
  //
  // Future<void> deleteLatestReportData() async {
  //   return await jsonStore.deleteItem('report_data');
  // }

}
