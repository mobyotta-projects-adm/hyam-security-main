import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyam_services/data/models/guard/assigned_job_model.dart';
import 'package:hyam_services/ui/presentation/guard/cubits/guard_dashboard_cubit/guard_dashboard_cubit.dart';
import 'package:hyam_services/utils/logger_utils.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../data/models/guard/user_model.dart';
import '../../../../../data/repository/app_repository.dart';
import '../../../../../locator.dart';
import '../../../../../router/app_routes.gr.dart';
import '../../../../../services/app_json_store.dart';

part 'guard_profile_state.dart';

class GuardProfileCubit extends Cubit<GuardProfileState> {
  GuardProfileCubit() : super(const GuardProfileState.init());

  final router = getItInjector<AppRouter>();
  final dataRepo = getItInjector<AppRepository>();

  final jsonStore = getItInjector<AppJsonStore>();

  Future<void> loadAssignedJob() async {
    final result =
        await dataRepo.getAssignedById(id: state.guard?.userid ?? '');
    result.fold((l) {
      getSelectedJobId();
      ScaffoldMessenger.of(router.navigatorKey.currentState!.context)
          .showSnackBar(
              SnackBar(content: Text(l.message ?? 'No Job Assigned yet')));
      emit(state.copyWith(assignedJobModel: []));
    }, (r) {
      emit(state.copyWith(assignedJobModel: r));
      getSelectedJobId();
    });
  }

  void refreshAssignedJob()async{
    router.navigatorKey.currentState!.context.loaderOverlay.show();
    final result =
        await dataRepo.getAssignedById(id: state.guard?.userid ?? '');
    router.navigatorKey.currentState!.context.loaderOverlay.hide();
    result.fold((l) {
      emit(state.copyWith(assignedJobModel: []));
      getSelectedJobId();
    }, (r) {
      emit(state.copyWith(assignedJobModel: r));
      getSelectedJobId();
    });
  }

  void authenticate() async {
    final response = await dataRepo.getUserSessionData();
    response.fold((l) {
      router.replaceNamed('/sign-in-screen');
    }, (r) async {
      if (r != null) {
        emit(state.copyWith(guard: r));
        AppLogger.i('User Information -> ${r.toJson()}');
        await loadAssignedJob();
        if (!isJobOnGoing()) {
          router.replaceNamed('/guard-profile-screen');
        } else {
          router.replaceNamed('/guard-dashboard-screen');
        }
      } else {
        router.replaceNamed('/sign-in-screen');
      }
    });
  }

  bool isJobOnGoing() {
    final currentContext = router.navigatorKey.currentState!.context;
    final dashboardCubit = currentContext.read<GuardDashboardCubit>();
    AppLogger.i('Job On Going -> ${dashboardCubit.state.isJobOnGoing}');
    return dashboardCubit.state.isJobOnGoing;
  }

  void logout() async {
    final response = await getItInjector<AppRepository>().logout();
    response.fold((l) => {}, (r) {
      router.replaceNamed('/sign-in-screen');
    });
  }

  void setSelectedJob(AssignedJobModel? selectedJob) {
    emit(state.copyWith(selectedJob: selectedJob));
    setSelectedJobId(selectedJob);
  }

  void setSelectedJobId(AssignedJobModel? assignedJobModel) async {
    if(assignedJobModel!=null){
      final myPref = await SharedPreferences.getInstance();
      AppLogger.i('Selected Job Id -> ${assignedJobModel.id}');
      myPref.setString('SelectedJobId', assignedJobModel.id.toString());
      await jsonStore.setOnGoingJob(assignedJobModel);
    }
  }

  void getSelectedJobId() async {
    final myPref = await SharedPreferences.getInstance();
    dynamic value = myPref.getString('SelectedJobId');
    AppLogger.i('Loaded Selected Job Id -> $value');
    if(value!=null){
      loadSelectedJob(value);
    }
  }

  void loadSelectedJob(String id) async{
    final assignedJobs = [...?state.assignedJobModel];
    if(assignedJobs!=null && assignedJobs.isNotEmpty){
      final selected = assignedJobs.firstWhere((element) => element.id==id);
      AppLogger.i('Loaded Selected Job ${selected}');
      if(selected!=null){
        setSelectedJob(selected);
      }else{
        final onGoingJob = await jsonStore.getOnGoingJob();
        setSelectedJob(onGoingJob);
      }
    }else{
      final onGoingJob = await jsonStore.getOnGoingJob();
      AppLogger.i('on going job ${onGoingJob?.toJson()}');
      setSelectedJob(onGoingJob);
    }
  }

}
