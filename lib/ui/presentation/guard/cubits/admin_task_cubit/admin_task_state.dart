part of 'admin_task_cubit.dart';

class AdminTaskState extends Equatable {
  final List<AssignedJobModel>? incomingJobs;
  final String? latestMessage;
  final AssignedJobModel? selectedJob;
  final List<ScanReportModel>? scanReports;
  final List<Guard>? allGuardList;
  final IncidentReportModel? incidentReportModel;
  final ActivityLogsModel? activityLogsModel;

  const AdminTaskState(
      {this.incomingJobs,
      this.latestMessage,
      this.selectedJob,
      this.scanReports,
      this.allGuardList,
      this.incidentReportModel,
        this.activityLogsModel,
      });

  const AdminTaskState.init(
      {this.incomingJobs,
      this.latestMessage,
      this.selectedJob,
      this.scanReports,
      this.allGuardList,
      this.incidentReportModel,this.activityLogsModel});

  AdminTaskState copyWith({
    List<AssignedJobModel>? incomingJobs,
    String? latestMessage,
    AssignedJobModel? selectedJob,
    List<Guard>? allGuardList,
    List<ScanReportModel>? scanReports,
    IncidentReportModel? incidentReportModel,
    ActivityLogsModel? activityLogsModel,
  }) {
    return AdminTaskState(
        incomingJobs: incomingJobs ?? this.incomingJobs,
        latestMessage: latestMessage ?? this.latestMessage,
        selectedJob: selectedJob ?? this.selectedJob,
        allGuardList: allGuardList ?? this.allGuardList,
        scanReports: scanReports ?? this.scanReports,
        incidentReportModel: incidentReportModel ?? this.incidentReportModel,
        activityLogsModel: activityLogsModel ?? this.activityLogsModel,
    );
  }

  @override
  List<Object?> get props => [
        incomingJobs,
        latestMessage,
        selectedJob,
        allGuardList,
        scanReports,
        incidentReportModel,
        activityLogsModel,
      ];
}
