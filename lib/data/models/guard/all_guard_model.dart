class AllGuardResponseModel {
  String? status;
  List<Guard>? guards;

  AllGuardResponseModel({this.status, this.guards});

  AllGuardResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      guards = <Guard>[];
      json['response'].forEach((v) {
        guards!.add(Guard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (guards != null) {
      data['response'] = guards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Guard {
  String? userid;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? password;
  String? address;

  Guard(
      {this.userid,
        this.firstname,
        this.lastname,
        this.email,
        this.phone,
        this.password,
        this.address});

  Guard.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['address'] = address;
    return data;
  }
}
