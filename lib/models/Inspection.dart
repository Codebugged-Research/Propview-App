// To parse this JSON data, do
//
//     final inspection = inspectionFromJson(jsonString);

import 'dart:convert';

List<Inspection> inspectionFromJson(String str) => List<Inspection>.from(json.decode(str).map((x) => Inspection.fromJson(x)));

String inspectionToJson(List<Inspection> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
        inspectionId: json["inspection_id"] == null ? null : json["inspection_id"],
        inspectType: json["inspect_type"] == null ? null : json["inspect_type"],
        propertyId: json["property_id"] == null ? null : json["property_id"],
        employeeId: json["employee_id"] == null ? null : json["employee_id"],
        issueIdList: json["issue_id_list"] == null ? null : json["issue_id_list"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "inspection_id": inspectionId == null ? null : inspectionId,
        "inspect_type": inspectType == null ? null : inspectType,
        "property_id": propertyId == null ? null : propertyId,
        "employee_id": employeeId == null ? null : employeeId,
        "issue_id_list": issueIdList == null ? null : issueIdList,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}
