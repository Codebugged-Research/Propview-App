// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.userId,
    this.parentId,
    this.name,
    this.designation,
    this.officialEmail,
    this.personalEmail,
    this.officialNumber,
    this.personalNumber,
    this.password,
    this.localAddress,
    this.permanentAddress,
    this.state,
    this.city,
    this.department,
    this.cid,
    this.sid,
    this.ccid,
    this.refName1,
    this.refEmail1,
    this.refMobile1,
    this.refAddress1,
    this.refName2,
    this.refEmail2,
    this.refMobile2,
    this.refAddress2,
    this.userType,
    this.status,
    this.bikeReading,
    this.addedOn,
    this.deviceToken,
  });

  int userId;
  String parentId;
  String name;
  String department;
  String designation;
  String officialEmail;
  String personalEmail;
  int officialNumber;
  int personalNumber;
  String password;
  String localAddress;
  String permanentAddress;
  String state;
  String city;
  int cid;
  int sid;
  int ccid;
  String refName1;
  String refEmail1;
  String refMobile1;
  String refAddress1;
  String refName2;
  String refEmail2;
  String refMobile2;
  String refAddress2;
  String userType;
  int status;
  int bikeReading;
  String addedOn;
  bool present;
  String deviceToken;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"] == null ? null : json["user_id"],
        deviceToken: json["device_token"] == null ? null : json["device_token"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        name: json["name"] == null ? null : json["name"],
        department: json["department"] == null ? null : json["department"],
        designation: json["designation"] == null ? null : json["designation"],
        officialEmail:
            json["official_email"] == null ? null : json["official_email"],
        personalEmail:
            json["personal_email"] == null ? null : json["personal_email"],
        officialNumber:
            json["official_number"] == null ? null : json["official_number"],
        personalNumber:
            json["personal_number"] == null ? null : json["personal_number"],
        password: json["password"] == null ? null : json["password"],
        localAddress:
            json["local_address"] == null ? null : json["local_address"],
        permanentAddress: json["permanent_address"] == null
            ? null
            : json["permanent_address"],
        state: json["state"] == null ? null : json["state"],
        city: json["city"] == null ? null : json["city"],
        cid: json["cid"] == null ? null : json["cid"],
        sid: json["sid"] == null ? null : json["sid"],
        ccid: json["ccid"] == null ? null : json["ccid"],
        refName1: json["ref_name1"] == null ? null : json["ref_name1"],
        refEmail1: json["ref_email1"] == null ? null : json["ref_email1"],
        refMobile1: json["ref_mobile1"] == null ? null : json["ref_mobile1"],
        refAddress1: json["ref_address1"] == null ? null : json["ref_address1"],
        refName2: json["ref_name2"] == null ? null : json["ref_name2"],
        refEmail2: json["ref_email2"] == null ? null : json["ref_email2"],
        refMobile2: json["ref_mobile2"] == null ? null : json["ref_mobile2"],
        refAddress2: json["ref_address2"] == null ? null : json["ref_address2"],
        userType: json["user_type"] == null ? null : json["user_type"],
        bikeReading: json["bike_reading"] == null ? null : json["bike_reading"],
        status: json["status"] == null ? null : json["status"],
        addedOn: json["added_on"] == null ? null : json["added_on"],
      );


  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "device_token": deviceToken == null ? null : deviceToken,
        "parent_id": parentId == null ? null : parentId,
        "name": name == null ? null : name,
        "designation": designation == null ? null : designation,
        "official_email": officialEmail == null ? null : officialEmail,
        "department": department == null ? null : department,
        "personal_email": personalEmail == null ? null : personalEmail,
        "official_number": officialNumber == null ? null : officialNumber,
        "personal_number": personalNumber == null ? null : personalNumber,
        "password": password == null ? null : password,
        "local_address": localAddress == null ? null : localAddress,
        "permanent_address": permanentAddress == null ? null : permanentAddress,
        "state": state == null ? null : state,
        "city": city == null ? null : city,
        "bike_reading": bikeReading == null ? null : bikeReading,
        "cid": cid == null ? null : cid,
        "sid": sid == null ? null : sid,
        "ccid": ccid == null ? null : ccid,
        "ref_name1": refName1 == null ? null : refName1,
        "ref_email1": refEmail1 == null ? null : refEmail1,
        "ref_mobile1": refMobile1 == null ? null : refMobile1,
        "ref_address1": refAddress1 == null ? null : refAddress1,
        "ref_name2": refName2 == null ? null : refName2,
        "ref_email2": refEmail2 == null ? null : refEmail2,
        "ref_mobile2": refMobile2 == null ? null : refMobile2,
        "ref_address2": refAddress2 == null ? null : refAddress2,
        "user_type": userType == null ? null : userType,
        "status": status == null ? null : status,
        "added_on": addedOn == null ? null : addedOn,
      };
}
