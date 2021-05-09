// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

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
    this.startDate,
    this.startTime,
    this.assignedTo,
    this.propertyRef,
    this.endDate,
    this.endTime,
    this.taskStatus,
    this.createdAt,
    this.updatedAt,
    this.propertyOwner,
    this.tblUsers,
  });

  int taskId;
  String category;
  String taskName;
  String taskDesc;
  String startDate;
  String startTime;
  String assignedTo;
  String propertyRef;
  String endDate;
  String endTime;
  String taskStatus;
  String createdAt;
  String updatedAt;
  PropertyOwner propertyOwner;
  TblUsers tblUsers;

  factory TaskElement.fromJson(Map<String, dynamic> json) => TaskElement(
    taskId: json["task_id"] == null ? null : json["task_id"],
    category: json["category"] == null ? null : json["category"],
    taskName: json["task_name"] == null ? null : json["task_name"],
    taskDesc: json["task_desc"] == null ? null : json["task_desc"],
    startDate: json["start_date"] == null ? null : json["start_date"],
    startTime: json["start_time"] == null ? null : json["start_time"],
    assignedTo: json["assigned_to"] == null ? null : json["assigned_to"],
    propertyRef: json["property_ref"] == null ? null : json["property_ref"],
    endDate: json["end_date"] == null ? null : json["end_date"],
    endTime: json["end_time"] == null ? null : json["end_time"],
    taskStatus: json["task_status"] == null ? null : json["task_status"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
    propertyOwner: json["property_owner"] == null ? null : PropertyOwner.fromJson(json["property_owner"]),
    tblUsers: json["tbl_users"] == null ? null : TblUsers.fromJson(json["tbl_users"]),
  );

  Map<String, dynamic> toJson() => {
    "task_id": taskId == null ? null : taskId,
    "category": category == null ? null : category,
    "task_name": taskName == null ? null : taskName,
    "task_desc": taskDesc == null ? null : taskDesc,
    "start_date": startDate == null ? null : startDate,
    "start_time": startTime == null ? null : startTime,
    "assigned_to": assignedTo == null ? null : assignedTo,
    "property_ref": propertyRef == null ? null : propertyRef,
    "end_date": endDate == null ? null : endDate,
    "end_time": endTime == null ? null : endTime,
    "task_status": taskStatus == null ? null : taskStatus,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
    "property_owner": propertyOwner == null ? null : propertyOwner.toJson(),
    "tbl_users": tblUsers == null ? null : tblUsers.toJson(),
  };
}

class PropertyOwner {
  PropertyOwner({
    this.ownerId,
    this.salutation,
    this.ownerName,
    this.ownerNumber,
    this.whatsappNumber,
    this.ownerEmail,
    this.ownerAddress,
    this.ownerPassword,
    this.ownerName1,
    this.ownerEmail1,
    this.ownerNumber1,
    this.country,
    this.accountName,
    this.bankName,
    this.accountNumber,
    this.bankIfsc,
    this.accountType,
    this.panNumber,
    this.panNumber1,
    this.aadhaar,
    this.aadhaar1,
    this.instruction,
    this.refName,
    this.refEmail,
    this.refNumber,
    this.refRelation,
    this.refAddress,
    this.poaName,
    this.poaNumber,
    this.poaEmail,
    this.poaRelation,
    this.poaAddress,
    this.forRef,
    this.addedon,
    this.status,
    this.sendmail,
    this.newsletter,
  });

  int ownerId;
  String salutation;
  String ownerName;
  String ownerNumber;
  String whatsappNumber;
  String ownerEmail;
  String ownerAddress;
  String ownerPassword;
  String ownerName1;
  String ownerEmail1;
  String ownerNumber1;
  String country;
  String accountName;
  String bankName;
  String accountNumber;
  String bankIfsc;
  String accountType;
  String panNumber;
  String panNumber1;
  String aadhaar;
  String aadhaar1;
  String instruction;
  String refName;
  String refEmail;
  String refNumber;
  String refRelation;
  String refAddress;
  String poaName;
  String poaNumber;
  String poaEmail;
  String poaRelation;
  String poaAddress;
  String forRef;
  String addedon;
  int status;
  int sendmail;
  int newsletter;

  factory PropertyOwner.fromJson(Map<String, dynamic> json) => PropertyOwner(
    ownerId: json["owner_id"] == null ? null : json["owner_id"],
    salutation: json["salutation"] == null ? null : json["salutation"],
    ownerName: json["owner_name"] == null ? null : json["owner_name"],
    ownerNumber: json["owner_number"] == null ? null : json["owner_number"],
    whatsappNumber: json["whatsapp_number"] == null ? null : json["whatsapp_number"],
    ownerEmail: json["owner_email"] == null ? null : json["owner_email"],
    ownerAddress: json["owner_address"] == null ? null : json["owner_address"],
    ownerPassword: json["owner_password"] == null ? null : json["owner_password"],
    ownerName1: json["owner_name1"] == null ? null : json["owner_name1"],
    ownerEmail1: json["owner_email1"] == null ? null : json["owner_email1"],
    ownerNumber1: json["owner_number1"] == null ? null : json["owner_number1"],
    country: json["country"] == null ? null : json["country"],
    accountName: json["account_name"] == null ? null : json["account_name"],
    bankName: json["bank_name"] == null ? null : json["bank_name"],
    accountNumber: json["account_number"] == null ? null : json["account_number"],
    bankIfsc: json["bank_ifsc"] == null ? null : json["bank_ifsc"],
    accountType: json["account_type"] == null ? null : json["account_type"],
    panNumber: json["pan_number"] == null ? null : json["pan_number"],
    panNumber1: json["pan_number1"] == null ? null : json["pan_number1"],
    aadhaar: json["aadhaar"] == null ? null : json["aadhaar"],
    aadhaar1: json["aadhaar1"] == null ? null : json["aadhaar1"],
    instruction: json["instruction"] == null ? null : json["instruction"],
    refName: json["ref_name"] == null ? null : json["ref_name"],
    refEmail: json["ref_email"] == null ? null : json["ref_email"],
    refNumber: json["ref_number"] == null ? null : json["ref_number"],
    refRelation: json["ref_relation"] == null ? null : json["ref_relation"],
    refAddress: json["ref_address"] == null ? null : json["ref_address"],
    poaName: json["poa_name"] == null ? null : json["poa_name"],
    poaNumber: json["poa_number"] == null ? null : json["poa_number"],
    poaEmail: json["poa_email"] == null ? null : json["poa_email"],
    poaRelation: json["poa_relation"] == null ? null : json["poa_relation"],
    poaAddress: json["poa_address"] == null ? null : json["poa_address"],
    forRef: json["for_ref"] == null ? null : json["for_ref"],
    addedon: json["addedon"] == null ? null : json["addedon"],
    status: json["status"] == null ? null : json["status"],
    sendmail: json["sendmail"] == null ? null : json["sendmail"],
    newsletter: json["newsletter"] == null ? null : json["newsletter"],
  );

  Map<String, dynamic> toJson() => {
    "owner_id": ownerId == null ? null : ownerId,
    "salutation": salutation == null ? null : salutation,
    "owner_name": ownerName == null ? null : ownerName,
    "owner_number": ownerNumber == null ? null : ownerNumber,
    "whatsapp_number": whatsappNumber == null ? null : whatsappNumber,
    "owner_email": ownerEmail == null ? null : ownerEmail,
    "owner_address": ownerAddress == null ? null : ownerAddress,
    "owner_password": ownerPassword == null ? null : ownerPassword,
    "owner_name1": ownerName1 == null ? null : ownerName1,
    "owner_email1": ownerEmail1 == null ? null : ownerEmail1,
    "owner_number1": ownerNumber1 == null ? null : ownerNumber1,
    "country": country == null ? null : country,
    "account_name": accountName == null ? null : accountName,
    "bank_name": bankName == null ? null : bankName,
    "account_number": accountNumber == null ? null : accountNumber,
    "bank_ifsc": bankIfsc == null ? null : bankIfsc,
    "account_type": accountType == null ? null : accountType,
    "pan_number": panNumber == null ? null : panNumber,
    "pan_number1": panNumber1 == null ? null : panNumber1,
    "aadhaar": aadhaar == null ? null : aadhaar,
    "aadhaar1": aadhaar1 == null ? null : aadhaar1,
    "instruction": instruction == null ? null : instruction,
    "ref_name": refName == null ? null : refName,
    "ref_email": refEmail == null ? null : refEmail,
    "ref_number": refNumber == null ? null : refNumber,
    "ref_relation": refRelation == null ? null : refRelation,
    "ref_address": refAddress == null ? null : refAddress,
    "poa_name": poaName == null ? null : poaName,
    "poa_number": poaNumber == null ? null : poaNumber,
    "poa_email": poaEmail == null ? null : poaEmail,
    "poa_relation": poaRelation == null ? null : poaRelation,
    "poa_address": poaAddress == null ? null : poaAddress,
    "for_ref": forRef == null ? null : forRef,
    "addedon": addedon == null ? null : addedon,
    "status": status == null ? null : status,
    "sendmail": sendmail == null ? null : sendmail,
    "newsletter": newsletter == null ? null : newsletter,
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
