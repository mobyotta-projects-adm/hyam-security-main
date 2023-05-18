class ScanReportResponseModel {
  String? status;
  List<ScanReportModel>? response;

  ScanReportResponseModel({this.status, this.response});

  ScanReportResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <ScanReportModel>[];
      json['response'].forEach((v) {
        response!.add(ScanReportModel.fromJson(v));
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

class ScanReportModel {
  String? id;
  String? guardId;
  String? jobId;
  String? chekpointNo;
  String? jobName;
  String? jobAddress;
  String? uniqueCode;
  String? geotag;
  String? checkpointDateTime;
  String? description;

  ScanReportModel(
      {this.id,
        this.guardId,
        this.jobId,
        this.chekpointNo,
        this.jobName,
        this.jobAddress,
        this.uniqueCode,
        this.geotag,
        this.checkpointDateTime,
        this.description,
      });

  ScanReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guardId = json['guard_id'];
    jobId = json['job_id'];
    chekpointNo = json['chekpoint_no'];
    jobName = json['job_name'];
    jobAddress = json['job_address'];
    uniqueCode = json['unique_code'];
    geotag = json['geotag'];
    checkpointDateTime = json['checkpoint_date_time'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['guard_id'] = guardId;
    data['job_id'] = jobId;
    data['chekpoint_no'] = chekpointNo;
    data['job_name'] = jobName;
    data['job_address'] = jobAddress;
    data['unique_code'] = uniqueCode;
    data['geotag'] = geotag;
    data['checkpoint_date_time'] = checkpointDateTime;
    data['description'] = description;
    return data;
  }
}
