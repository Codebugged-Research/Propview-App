// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

import 'package:propview/models/Property.dart';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  Task({
    this.count,
    this.data,
  });

  int count;
  Data data;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    count: json["count"] == null ? null : json["count"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "count": count == null ? null : count,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.task,
  });

  List<TaskElement> task;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    task: json["task"] == null ? null : List<TaskElement>.from(json["task"].map((x) => TaskElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "task": task == null ? null : List<dynamic>.from(task.map((x) => x.toJson())),
  };
}
class TaskElement {
  TaskElement({
    this.taskId,
    this.category,
    this.taskName,
    this.taskDesc,
    this.startDateTime,
    this.assignedTo,
    this.propertyRef,
    this.endDateTime,
    this.taskStatus,
    this.createdAt,
    this.updatedAt,
    this.property,
    this.propertyOwnerRef,
    this.tblUsers,
  });

  int taskId;
  String category;
  String taskName;
  String taskDesc;
  DateTime startDateTime;
  String assignedTo;
  String propertyRef;
  DateTime endDateTime;
  String taskStatus;
  DateTime createdAt;
  DateTime updatedAt;
  String propertyOwnerRef;
  Tableproperty property;
  TblUsers tblUsers;

  factory TaskElement.fromJson(Map<String, dynamic> json) => TaskElement(
    taskId: json["task_id"] == null ? null : json["task_id"],
    category: json["category"] == null ? null : json["category"],
    taskName: json["task_name"] == null ? null : json["task_name"],
    taskDesc: json["task_desc"] == null ? null : json["task_desc"],
    startDateTime: json["start_dateTime"] == null ? null : DateTime.parse(json["start_dateTime"]),
    assignedTo: json["assigned_to"] == null ? null : json["assigned_to"],
    propertyRef: json["property_ref"] == null ? null : json["property_ref"],
    endDateTime: json["end_dateTime"] == null ? null : DateTime.parse(json["end_dateTime"]),
    taskStatus: json["task_status"] == null ? null : json["task_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    propertyOwnerRef: json["property_owner_ref"] == null ? null : json["property_owner_ref"],
    property: json["tableproperty"] == null ? null : Tableproperty.fromJson(json ["tableproperty"]),
    tblUsers: json["tbl_users"] == null ? null : TblUsers.fromJson(json["tbl_users"]),
  );

  Map<String, dynamic> toJson() => {
    "task_id": taskId == null ? null : taskId,
    "category": category == null ? null : category,
    "task_name": taskName == null ? null : taskName,
    "task_desc": taskDesc == null ? null : taskDesc,
    "start_dateTime": startDateTime == null ? null : startDateTime.toIso8601String(),
    "assigned_to": assignedTo == null ? null : assignedTo,
    "property_ref": propertyRef == null ? null : propertyRef,
    "end_dateTime": endDateTime == null ? null : endDateTime.toIso8601String(),
    "task_status": taskStatus == null ? null : taskStatus,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "property_owner_ref": propertyOwnerRef == null ? null : propertyOwnerRef,
    // "property_owner": propertyOwner == null ? null : propertyOwner.toJson(),
    "tableproperty": property == null ? null : property.toJson(),
    "tbl_users": tblUsers == null ? null : tblUsers.toJson(),
  };
}


class TblUsers {
  TblUsers({
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
    this.addedOn,
  });

  int userId;
  String parentId;
  String name;
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
  String addedOn;

  factory TblUsers.fromJson(Map<String, dynamic> json) => TblUsers(
    userId: json["user_id"] == null ? null : json["user_id"],
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    name: json["name"] == null ? null : json["name"],
    designation: json["designation"] == null ? "NA" : json["designation"],
    officialEmail: json["official_email"] == null ? null : json["official_email"],
    personalEmail: json["personal_email"] == null ? null : json["personal_email"],
    officialNumber: json["official_number"] == null ? null : json["official_number"],
    personalNumber: json["personal_number"] == null ? null : json["personal_number"],
    password: json["password"] == null ? null : json["password"],
    localAddress: json["local_address"] == null ? null : json["local_address"],
    permanentAddress: json["permanent_address"] == null ? null : json["permanent_address"],
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
    status: json["status"] == null ? null : json["status"],
    addedOn: json["added_on"] == null ? null : json["added_on"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId == null ? null : userId,
    "parent_id": parentId == null ? null : parentId,
    "name": name == null ? null : name,
    "designation": designation == null ? null : designation,
    "official_email": officialEmail == null ? null : officialEmail,
    "personal_email": personalEmail == null ? null : personalEmail,
    "official_number": officialNumber == null ? null : officialNumber,
    "personal_number": personalNumber == null ? null : personalNumber,
    "password": password == null ? null : password,
    "local_address": localAddress == null ? null : localAddress,
    "permanent_address": permanentAddress == null ? null : permanentAddress,
    "state": state == null ? null : state,
    "city": city == null ? null : city,
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
