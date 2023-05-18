class ScanResultModel {
  int? checkpointNo;
  String? jobName;
  String? address;
  String? locationUniqueID;

  ScanResultModel(
      {this.checkpointNo, this.jobName, this.address, this.locationUniqueID});

  ScanResultModel.fromJson(Map<String, dynamic> json) {
    checkpointNo = json['checkpointNo'];
    jobName = json['jobName'];
    address = json['Address'];
    locationUniqueID = json['locationUniqueID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['checkpointNo'] = checkpointNo;
    data['jobName'] = jobName;
    data['Address'] = address;
    data['locationUniqueID'] = locationUniqueID;
    return data;
  }
}
