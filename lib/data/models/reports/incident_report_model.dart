class IncidentReportModel {
  String? status;
  List<Response>? response;

  IncidentReportModel({this.status, this.response});

  IncidentReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? id;
  String? guardId;
  String? jobId;
  String? locationName;
  String? locationAddress;
  String? guardName;
  String? incidentDateTime;
  String? incidentDescription;
  String? narrative;

  Response(
      {this.id,
        this.guardId,
        this.jobId,
        this.locationName,
        this.locationAddress,
        this.guardName,
        this.incidentDateTime,
        this.incidentDescription,
        this.narrative});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guardId = json['guard_id'];
    jobId = json['job_id'];
    locationName = json['location_name'];
    locationAddress = json['location_address'];
    guardName = json['guard_name'];
    incidentDateTime = json['incident_date_time'];
    incidentDescription = json['incident_description'];
    narrative = json['narrative'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['guard_id'] = this.guardId;
    data['job_id'] = this.jobId;
    data['location_name'] = this.locationName;
    data['location_address'] = this.locationAddress;
    data['guard_name'] = this.guardName;
    data['incident_date_time'] = this.incidentDateTime;
    data['incident_description'] = this.incidentDescription;
    data['narrative'] = this.narrative;
    return data;
  }
}
