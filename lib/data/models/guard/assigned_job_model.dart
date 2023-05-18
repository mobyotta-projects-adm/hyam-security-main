class AssignedJobResponseModel {
  String? status;
  List<AssignedJobModel>? response;

  AssignedJobResponseModel({this.status, this.response});

  AssignedJobResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <AssignedJobModel>[];
      json['response'].forEach((v) {
        response!.add(AssignedJobModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssignedJobModel {
  String? id;
  String? jobName;
  String? jobAddress;
  String? jobTotalCheckpoints;
  String? jobStartDate;
  String? jobInstructions;
  String? jobType;
  String? jobAssignedStatus;
  String? jobOngoingStatus;
  String? jobAssignedTo;
  String? jobUniqueCode;

  AssignedJobModel(
      {this.id,
      this.jobName,
      this.jobAddress,
      this.jobTotalCheckpoints,
      this.jobStartDate,
      this.jobInstructions,
      this.jobType,
      this.jobAssignedStatus,
      this.jobOngoingStatus,
      this.jobAssignedTo,
      this.jobUniqueCode});

  AssignedJobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobName = json['job_name'];
    jobAddress = json['job_address'];
    jobTotalCheckpoints = json['job_total_checkpoints'];
    jobStartDate = json['job_start_date'];
    jobInstructions = json['job_instructions'];
    jobType = json['job_type'];
    jobAssignedStatus = json['job_assigned_status'];
    jobOngoingStatus = json['job_ongoing_status'];
    jobAssignedTo = json['job_assigned_to'];
    jobUniqueCode = json['job_unique_code'];
  }

  AssignedJobModel copyWith({
    String? id,
    String? jobName,
    String? jobAddress,
    String? jobTotalCheckpoints,
    String? jobStartDate,
    String? jobInstructions,
    String? jobType,
    String? jobAssignedStatus,
    String? jobOngoingStatus,
    String? jobAssignedTo,
    String? jobUniqueCode,
  }) {
    return AssignedJobModel(
      id: id ?? this.id,
      jobName: jobName ?? this.jobName,
      jobAddress: jobAddress ?? this.jobAddress,
      jobTotalCheckpoints: jobTotalCheckpoints ?? this.jobTotalCheckpoints,
      jobStartDate: jobStartDate ?? this.jobStartDate,
      jobInstructions: jobInstructions ?? this.jobInstructions,
      jobType: jobType ?? this.jobType,
      jobAssignedStatus: jobAssignedStatus ?? this.jobAssignedStatus,
      jobOngoingStatus: jobOngoingStatus ?? this.jobOngoingStatus,
      jobAssignedTo: jobAssignedTo ?? this.jobAssignedTo,
      jobUniqueCode: jobUniqueCode ?? this.jobUniqueCode,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_name'] = jobName;
    data['job_address'] = jobAddress;
    data['job_total_checkpoints'] = jobTotalCheckpoints;
    data['job_start_date'] = jobStartDate;
    data['job_instructions'] = jobInstructions;
    data['job_type'] = jobType;
    data['job_assigned_status'] = jobAssignedStatus;
    data['job_ongoing_status'] = jobOngoingStatus;
    data['job_assigned_to'] = jobAssignedTo;
    data['job_unique_code'] = jobUniqueCode;
    return data;
  }
}
