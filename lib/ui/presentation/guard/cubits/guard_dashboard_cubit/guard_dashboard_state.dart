part of 'guard_dashboard_cubit.dart';

class GuardDashboardState extends Equatable {
  final Position? currentPosition;
  final Barcode? latestScanResult;
  final ScanReportModel? latestSubmitScanReport;
  final bool scanActive;
  final ScanResultModel? scanResultModel;
  final bool isJobOnGoing;
  final bool isTorchAvailable;
  final bool flashOn;

  const GuardDashboardState({
    this.currentPosition,
    this.latestScanResult,
    this.latestSubmitScanReport,
    required this.scanActive,
    required this.isJobOnGoing,
    this.scanResultModel,
    required this.isTorchAvailable,
    required this.flashOn,
  });

  const GuardDashboardState.init({
    this.currentPosition,
    this.latestScanResult,
    this.latestSubmitScanReport,
    required this.scanActive,
    required this.isJobOnGoing,
    this.scanResultModel,
    required this.isTorchAvailable,
    required this.flashOn,
  });

  GuardDashboardState copyWith({
    Position? currentPosition,
    Barcode? latestScanResult,
    ScanReportModel? latestSubmitScanReport,
    bool? scanActive,
    ScanResultModel? scanResultModel,
    bool? isJobOnGoing,
    bool? isTorchAvailable,
    bool? flashOn,
  }) {
    return GuardDashboardState(
      currentPosition: currentPosition ?? this.currentPosition,
      latestScanResult: latestScanResult ?? this.latestScanResult,
      latestSubmitScanReport:
          latestSubmitScanReport ?? this.latestSubmitScanReport,
      scanActive: scanActive ?? this.scanActive,
      scanResultModel: scanResultModel ?? this.scanResultModel,
      isJobOnGoing: isJobOnGoing ?? this.isJobOnGoing,
      isTorchAvailable: isTorchAvailable ?? this.isTorchAvailable,
      flashOn: flashOn ?? this.flashOn,
    );
  }

  @override
  List<Object?> get props => [
        currentPosition,
        latestScanResult,
        latestSubmitScanReport,
        scanActive,
        scanResultModel,
        isJobOnGoing,
        isTorchAvailable,
        flashOn,
      ];
}
