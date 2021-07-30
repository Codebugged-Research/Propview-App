// To parse this JSON data, do
//
//     final issueTable = issueTableFromJson(jsonString);

import 'dart:convert';

IssueTable issueTableFromJson(String str) => IssueTable.fromJson(json.decode(str));

String issueTableToJson(IssueTable data) => json.encode(data.toJson());

class IssueTable {
  IssueTable({
    this.success,
    this.data,
  });

  String success;
  List<IssueTableData> data;

  factory IssueTable.fromJson(Map<String, dynamic> json) => IssueTable(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : List<IssueTableData>.from(json["data"].map((x) => IssueTableData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class IssueTableData {
  IssueTableData({
    this.id,
    this.roomsubroomId,
    this.roomsubroomName,
    this.issub,
    this.issueRowId,
    this.propertyId,
  });

  int id;
  int roomsubroomId;
  String roomsubroomName;
  int issub;
  String issueRowId;
  int propertyId;

  factory IssueTableData.fromJson(Map<String, dynamic> json) => IssueTableData(
    id: json["id"] == null ? null : json["id"],
    roomsubroomId: json["roomsubroom_id"] == null ? null : json["roomsubroom_id"],
    roomsubroomName: json["roomsubroom_name"] == null ? null : json["roomsubroom_name"],
    issub: json["issub"] == null ? null : json["issub"],
    issueRowId: json["issue_row_id"] == null ? null : json["issue_row_id"],
    propertyId: json["property_id"] == null ? null : json["property_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "roomsubroom_id": roomsubroomId == null ? null : roomsubroomId,
    "roomsubroom_name": roomsubroomName == null ? null : roomsubroomName,
    "issub": issub == null ? null : issub,
    "issue_row_id": issueRowId == null ? null : issueRowId,
    "property_id": propertyId == null ? null : propertyId,
  };
}
