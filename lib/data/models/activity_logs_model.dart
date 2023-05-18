class ActivityLogsModel {
  String? status;
  List<ActivityLogs>? activityLogs;

  ActivityLogsModel({this.status, this.activityLogs});

  ActivityLogsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      activityLogs = <ActivityLogs>[];
      json['response'].forEach((v) {
        activityLogs!.add(ActivityLogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (activityLogs != null) {
      data['response'] = activityLogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivityLogs {
  String? actlogId;
  String? guardId;
  String? jobId;
  String? guardName;
  String? actlogDate;
  String? actlogLocation;
  String? actlogTime;
  String? actlogDescription;

  ActivityLogs(
      {this.actlogId,
        this.guardId,
        this.jobId,
        this.guardName,
        this.actlogDate,
        this.actlogLocation,
        this.actlogTime,
        this.actlogDescription});

  ActivityLogs.fromJson(Map<String, dynamic> json) {
    actlogId = json['actlog_id'];
    guardId = json['guard_id'];
    jobId = json['job_id'];
    guardName = json['guard_name'];
    actlogDate = json['actlog_date'];
    actlogLocation = json['actlog_location'];
    actlogTime = json['actlog_time'];
    actlogDescription = json['actlog_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actlog_id'] = actlogId;
    data['guard_id'] = guardId;
    data['job_id'] = jobId;
    data['guard_name'] = guardName;
    data['actlog_date'] = actlogDate;
    data['actlog_location'] = actlogLocation;
    data['actlog_time'] = actlogTime;
    data['actlog_description'] = actlogDescription;
    return data;
  }
}
