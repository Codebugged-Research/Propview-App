// To parse this JSON data, do
//
//     final inspectionType = inspectionTypeFromJson(jsonString);

import 'dart:convert';

List<InspectionType> inspectionTypeFromJson(String str) =>
    List<InspectionType>.from(
        json.decode(str).map((x) => InspectionType.fromJson(x)));

String inspectionTypeToJson(List<InspectionType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InspectionType {
  InspectionType({
    this.inspectionTypeId,
    this.inspectionType,
    this.createdAt,
    this.updatedAt,
  });

  int inspectionTypeId;
  String inspectionType;
  String createdAt;
  String updatedAt;

  factory InspectionType.fromJson(Map<String, dynamic> json) => InspectionType(
        inspectionTypeId: json["inspectionType_id"] == null
            ? null
            : json["inspectionType_id"],
        inspectionType:
            json["inspectionType"] == null ? null : json["inspectionType"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "inspectionType_id": inspectionTypeId == null ? null : inspectionTypeId,
        "inspectionType": inspectionType == null ? null : inspectionType,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
      };
}
