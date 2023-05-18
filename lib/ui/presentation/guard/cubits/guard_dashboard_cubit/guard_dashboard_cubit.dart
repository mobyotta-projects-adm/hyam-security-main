import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:hyam_services/data/models/guard/assigned_job_model.dart';
import 'package:hyam_services/services/app_json_store.dart';
import 'package:hyam_services/utils/flushbar_utility.dart';
import 'package:torch_light/torch_light.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hyam_services/data/models/reports/scan_report_model.dart';
import 'package:hyam_services/ui/presentation/guard/cubits/guard_profile_cubit/guard_profile_cubit.dart';
import 'package:hyam_services/utils/logger_utils.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../data/models/scan_result_model.dart';
import '../../../../../data/repository/app_repository.dart';
import '../../../../../locator.dart';
import '../../../../../router/app_routes.gr.dart';

part 'guard_dashboard_state.dart';

class GuardDashboardCubit extends Cubit<GuardDashboardState> {
  GuardDashboardCubit()
      : super(const GuardDashboardState.init(
            scanActive: false,
            isJobOnGoing: false,
            isTorchAvailable: false,
            flashOn: false));
  final router = getItInjector<AppRouter>();
  final dataRepo = getItInjector<AppRepository>();

  void init() async {
    getOnGoingStatus();
    getTorchAvailability();
    fetchLocationData();
    loadLatestScanResult();
  }

  void getTorchAvailability() async {
    try {
      final isTorchAvailable = await TorchLight.isTorchAvailable();
      emit(state.copyWith(isTorchAvailable: isTorchAvailable));
    } on Exception catch (_) {
      emit(state.copyWith(isTorchAvailable: false));
    }
  }

  void onOffTorch() async {
    try {
      if (state.isTorchAvailable) {
        if (!state.flashOn) {
          await TorchLight.enableTorch();
          AppLogger.i('Torch Onn ');
          emit(state.copyWith(flashOn: true));
        } else {
          await TorchLight.disableTorch();
          emit(state.copyWith(flashOn: false));
          AppLogger.i('Torch Off ');
        }
      }
    } on Exception catch (_) {
      AppLogger.e('Torch Exception- ${state.flashOn ? 'On' : 'Off'} ');
    }
  }

  void fetchLocationData() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppLogger.e('Location service not enabled!');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openAppSettings();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }
    final position = await Geolocator.getCurrentPosition();
    if (position != null) {
      AppLogger.e('Current Location Position - ${position.toJson()}');
      emit(state.copyWith(currentPosition: position));
    }
  }

  void loadLatestScanResult() async {
    final latestScan = await dataRepo.getLatestReportData();
    latestScan.fold((l) {}, (r) {
      AppLogger.i('Latest Scan Report Data -> ${r?.toJson()}');
      emit(state.copyWith(latestSubmitScanReport: r));
    });
  }

  void onScanResultUpdate(Barcode result,String description) async {
    final guardProfileState = router.navigatorKey.currentState!.context
        .read<GuardProfileCubit>()
        .state;
    router.navigatorKey.currentState!.context.loaderOverlay.show();
    AppLogger.i('New Result found -> ${result.code.toString()}');
    final jsonRes = json.decode(result.code ?? '');
    if (jsonRes != null) {
      final scanData = ScanResultModel.fromJson(jsonRes);
      emit(state.copyWith(latestScanResult: result, scanResultModel: scanData));
      final sendRepoModel = ScanReportModel(
        guardId: guardProfileState.guard?.userid,
        jobId: guardProfileState.selectedJob!.id.toString(),
        chekpointNo: scanData.checkpointNo.toString(),
        jobAddress: scanData.address,
        jobName: scanData.jobName,
        uniqueCode: scanData.locationUniqueID,
        checkpointDateTime: DateTime.now().toString(),
        geotag: state.currentPosition?.toJson().toString(),
        description: description,
      );
      AppLogger.i('Submitting Response -> ${sendRepoModel.toJson()}');
      final submitRes = await dataRepo.submitScanReportData(sendRepoModel);
      AppLogger.i('Submitting Res -> ${submitRes.toString()}');
      submitRes.fold((l) {
        router.navigatorKey.currentState!.context.loaderOverlay.hide();
      }, (r) async {
        await dataRepo.setLatestReportData(sendRepoModel);
        router.navigatorKey.currentState!.context.loaderOverlay.hide();
        FlushbarUtility(router.navigatorKey.currentState!.context)
            .showFlusbar('Scan sent to admin');
        emit(state.copyWith(
          latestSubmitScanReport: sendRepoModel,
        ));
      });
    }
  }

  void startJob() async {
    final myContext = router.navigatorKey.currentState!.context;
    myContext.loaderOverlay.show();
    final guardProfileState = router.navigatorKey.currentState!.context
        .read<GuardProfileCubit>()
        .state;
    final res = await dataRepo.startJob(
        jobId: guardProfileState.selectedJob!.id.toString());
    AppLogger.i('response -> $res');
    res.fold((l) {
      myContext.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('${l.message}!');
    }, (r) {
      emit(state.copyWith(isJobOnGoing: true));
      setOnGoingStatus(true);
      myContext.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('Job Started!');
    });
  }

  void endJob() async {
    final myContext = router.navigatorKey.currentState!.context;
    myContext.loaderOverlay.show();
    final guardProfileState = router.navigatorKey.currentState!.context
        .read<GuardProfileCubit>()
        .state;
    final res = await dataRepo.endJob(
        jobId: guardProfileState.selectedJob!.id.toString());
    res.fold((l) {
      myContext.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('${l.message}!');
    }, (r) {
      emit(state.copyWith(isJobOnGoing: false));
      setOnGoingStatus(false);
      myContext.loaderOverlay.hide();
      final profileCubit = myContext.read<GuardProfileCubit>();
      List<AssignedJobModel>? assigned = profileCubit.state.assignedJobModel;
      if (assigned != null &&
          assigned.isNotEmpty &&
          profileCubit.state.selectedJob != null) {
        assigned.remove(profileCubit.state.selectedJob);
        profileCubit
            .emit(profileCubit.state.copyWith(assignedJobModel: assigned));
      }
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('Job Ended!');
      router.replaceNamed('/guard-profile-screen');
    });
  }

  void setOnGoingStatus(bool status) async {
    final myPref = await SharedPreferences.getInstance();
    myPref.setBool('JobOngoing', status);
  }

  void getOnGoingStatus() async {
    final myPref = await SharedPreferences.getInstance();
    dynamic value = myPref.get('JobOngoing');
    if (value != null) {
      emit(state.copyWith(
          isJobOnGoing: value,
      ));
    }
  }

  void changeScanActiveStatus() {
    emit(state.copyWith(scanActive: !state.scanActive));
  }

  void onSosTap() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+1 911',
    );
    final launch = await canLaunchUrl(launchUri);
    if (launch) {
      await launchUrl(launchUri);
    }
  }

  void sendIncidentReport(String title, String narrative) async {
    final myContext = router.navigatorKey.currentState!.context;
    myContext.loaderOverlay.show();
    final guardProfileState = router.navigatorKey.currentState!.context
        .read<GuardProfileCubit>()
        .state;
    final address = await getAddressFromPosition(
        state.currentPosition?.latitude, state.currentPosition?.longitude);
    final res = await dataRepo.sendIncidentReport(
      jobId: guardProfileState.selectedJob!.id.toString(),
      guardId: guardProfileState.guard!.userid.toString(),
      locationName: address?.adminArea ?? '',
      locationAddress: address?.addressLine.toString() ?? '',
      guardName:
          '${guardProfileState.guard?.firstname} ${guardProfileState.guard?.lastname}',
      incidentDescription: title,
      narrative: narrative,
    );
    res.fold((l) {
      myContext.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('${l.message}!');
    }, (r) {
      myContext.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('Incident Report Created!');
    });
  }

  void sendActivityLogReport(String description,TimeOfDay dateTime) async {
    final myContext = router.navigatorKey.currentState!.context;
    myContext.loaderOverlay.show();
    final guardProfileState = router.navigatorKey.currentState!.context
        .read<GuardProfileCubit>()
        .state;
    final res = await dataRepo.sendActivityLogReport(
      jobId: guardProfileState.selectedJob!.id.toString(),
      guardId: guardProfileState.guard!.userid.toString(),
      locationAddress: '${state.currentPosition?.latitude},${state.currentPosition?.longitude}',
      guardName:
      '${guardProfileState.guard?.firstname} ${guardProfileState.guard?.lastname}',
      activityLogDescription: description,
      dateTime: '${dateTime.hour}${dateTime.minute}',
    );
    res.fold((l) {
      myContext.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('${l.message}!');
    }, (r) {
      myContext.loaderOverlay.hide();
      FlushbarUtility(router.navigatorKey.currentState!.context)
          .showFlusbar('Activity log report created!');
    });
  }


  Future<Address?> getAddressFromPosition(double? lat, double? long) async {
    if (lat != null && long != null) {
      final coordinates = Coordinates(lat, long);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      return addresses.first;
    } else {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLogger.e('Location service not enabled!');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await Geolocator.openAppSettings();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
      final position = await Geolocator.getCurrentPosition();
      if (position != null) {
        final coordinates = Coordinates(position.latitude, position.longitude);
        final addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        return addresses.first;
      }
    }
    return null;
  }
}
