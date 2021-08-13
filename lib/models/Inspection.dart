// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.inspection,
  });

  List<Inspection> inspection;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        inspection: json["inspection"] == null
            ? null
            : List<Inspection>.from(
                json["inspection"].map((x) => Inspection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "inspection": inspection == null
            ? null
            : List<dynamic>.from(inspection.map((x) => x.toJson())),
      };
}

class Inspection {
  Inspection({
    this.inspectionId,
    this.inspectType,
    this.propertyId,
    this.employeeId,
    this.issueIdList,
    this.createdAt,
    this.updatedAt,
  });

  int inspectionId;
  String inspectType;
  int propertyId;
  int employeeId;
  String issueIdList;
  DateTime createdAt;
  DateTime updatedAt;

  factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
        inspectionId:
            json["inspection_id"] == null ? null : json["inspection_id"],
        inspectType: json["inspect_type"] == null ? null : json["inspect_type"],
        propertyId: json["property_id"] == null ? null : json["property_id"],
        employeeId: json["employee_id"] == null ? null : json["employee_id"],
        issueIdList:
            json["issue_id_list"] == null ? null : json["issue_id_list"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "inspection_id": inspectionId == null ? 0 : inspectionId,
        "inspect_type": inspectType == null ? null : inspectType,
        "property_id": propertyId == null ? null : propertyId,
        "issue_id_list": issueIdList == null ? null : issueIdList,
        "employee_id": employeeId == null ? null : employeeId,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
