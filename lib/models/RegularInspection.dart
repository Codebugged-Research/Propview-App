// To parse this JSON data, do
//
//     final regularInspection = regularInspectionFromJson(jsonString);

import 'dart:convert';

List<RegularInspection> regularInspectionFromJson(String str) =>
    List<RegularInspection>.from(
        json.decode(str).map((x) => RegularInspection.fromJson(x)));

String regularInspectionToJson(List<RegularInspection> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegularInspection {
  RegularInspection({
    this.id,
    this.rowList,
    this.propertyId,
    this.employeeId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String rowList;
  int propertyId;
  int employeeId;
  DateTime createdAt;
  DateTime updatedAt;

  factory RegularInspection.fromJson(Map<String, dynamic> json) =>
      RegularInspection(
        id: json["id"] == null ? null : json["id"],
        rowList: json["row_list"] == null ? null : json["row_list"],
        propertyId: json["property_id"] == null ? null : json["property_id"],
        employeeId: json["employee_id"] == null ? null : json["employee_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "row_list": rowList == null ? null : rowList,
        "property_id": propertyId == null ? null : propertyId,
        "employee_id": employeeId == null ? null : employeeId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
