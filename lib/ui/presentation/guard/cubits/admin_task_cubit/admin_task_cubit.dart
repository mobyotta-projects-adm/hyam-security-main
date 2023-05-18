import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_geocoder/model.dart';
import 'package:hyam_services/data/models/activity_logs_model.dart';
import 'package:hyam_services/data/models/reports/incident_report_model.dart';
import 'package:hyam_services/data/repository/app_repository.dart';
import 'package:hyam_services/locator.dart';
import 'package:hyam_services/router/app_routes.gr.dart';
import 'package:hyam_services/utils/logger_utils.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../../../data/models/guard/all_guard_model.dart';
import '../../../../../data/models/guard/assigned_job_model.dart';
import '../../../../../data/models/reports/scan_report_model.dart';
import '../../../../../utils/flushbar_utility.dart';

part 'admin_task_state.dart';

class AdminTaskCubit extends Cubit<AdminTaskState> {
  AdminTaskCubit() : super(const AdminTaskState.init());

  final router = getItInjector<AppRouter>();
  final dataRepo = getItInjector<AppRepository>();

  init() async {
    final result = await dataRepo.getIncomingJobs();
    result.fold((l) {
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('Failed to load Assigned Jobs ${l.message}');
    }, (r) {
      if (r != null && r.isNotEmpty) {
        emit(state.copyWith(incomingJobs: r));
      }
    });
    loadGuard();
  }

  Future<void> reloadStatus() async {
    final result = await dataRepo.getIncomingJobs();
    result.fold((l) {}, (r) {
      if (r != null && r.isNotEmpty) {
        final index = r.indexWhere((element) =>
            state.selectedJob?.id.toString() == element.id.toString());
        if (index != null) {
          final updatedJob = r[index];
          emit(state.copyWith(
            selectedJob: updatedJob,
            incomingJobs: r,
          ));
        } else {
          emit(state.copyWith(incomingJobs: r));
        }
      }
    });
  }

  void getReportByJobId({required String jobId}) async {
    final result = await dataRepo.getScanReport(
        jobId: state.selectedJob?.id.toString() ?? '');
    result.fold((l) {

    }, (r) {
      if (r != null && r.isNotEmpty) {
        emit(state.copyWith(scanReports: r));
      }
    });
    loadGuard();
  }

  void getIncidentReport({required String jobId,required String guardId}) async {
    final result = await dataRepo.getIncidentReportModel(
        jobId: state.selectedJob?.id.toString() ?? '',
        guardId: guardId,
    );

    result.fold((l) {

    }, (r) {
      if (r != null && r.response!.isNotEmpty) {
        emit(
          state.copyWith(incidentReportModel: r),
        );
      }
    });
  }

  void loadGuard() async {
    final res = await dataRepo.getAllGuards();
    res.fold((l) {
      emit(state.copyWith(allGuardList: []));
    }, (r) {
      emit(state.copyWith(allGuardList: r ?? []));
    });
  }

  void reloadGuard(BuildContext context) async {
    context.loaderOverlay.show();
    final res = await dataRepo.getAllGuards();
    res.fold((l) {
      emit(state.copyWith(allGuardList: []));
    }, (r) {
      emit(state.copyWith(allGuardList: r ?? []));
    });
    context.loaderOverlay.hide();
  }

  void changeJobStatus() async {
    AppLogger.i('on Change job status....');
    router.navigatorKey.currentState!.context.loaderOverlay.show();
    final status = await dataRepo.changeJobStatus(
      jobId: state.selectedJob!.id.toString(),
      jobStatus: state.selectedJob!.jobOngoingStatus == '0' ? '1' : '0',
    );

    status.fold((l) {
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar(l.message ?? 'Failed to Change Status');
    }, (r) async {
      await reloadStatus();
      router.navigatorKey.currentState!.context.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar(r ?? 'Job Status Changed Successfully !');
    });
  }

  void setSelectedJob(AssignedJobModel selectedJob) {
    emit(state.copyWith(selectedJob: selectedJob));
  }

  void assignJob(String guardId) async {
    router.navigatorKey.currentState!.context.loaderOverlay.show();
    final res = await dataRepo.assignJob(
        jobId: state.selectedJob?.id.toString() ?? "", guardId: guardId);

    res.fold((l) {
      router.navigatorKey.currentState!.context.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('Failed to Assign Job ${l.message}');
    }, (r) async {
      await reloadStatus();
      router.navigatorKey.currentState!.context.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('Job assigned successfully!');
    });
  }

  Future<void> getActivityLogs({required String jobId,required String guardId}) async {
    final result = await dataRepo.getActivityLogs(
      jobId: state.selectedJob?.id.toString() ?? '',
      guardId: guardId,
    );

    result.fold((l) {

    }, (r) {
      if (r != null && r.activityLogs!.isNotEmpty) {
        emit(
          state.copyWith(activityLogsModel: r),
        );
      }
    });
  }

  Future<Address?> getAddressFromPosition(String positionString) async {
    List position  = positionString.split(',');
    print('position - ${positionString}');
    if (position.first != null && position[1] != null) {
      final coordinates = Coordinates(double.tryParse(position.first), double.tryParse(position[1]));
      final addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      return addresses.first;
    } else {
      return null;
    }
  }

}
