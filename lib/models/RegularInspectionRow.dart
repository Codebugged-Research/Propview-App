// To parse this JSON data, do
//
//     final regularInspectionRow = regularInspectionRowFromJson(jsonString);

import 'dart:convert';

List<RegularInspectionRow> regularInspectionRowFromJson(String str) =>
    List<RegularInspectionRow>.from(
        json.decode(str).map((x) => RegularInspectionRow.fromJson(x)));

String regularInspectionRowToJson(List<RegularInspectionRow> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegularInspectionRow {
  RegularInspectionRow({
    this.id,
    this.termiteCheck,
    this.seepageCheck,
    this.generalCleanliness,
    this.otherIssue,
    this.photo,
    this.issub,
    this.roomsubroomId,
    this.roomsubroomName,
    this.createdAt,
  });

  int id;
  String termiteCheck;
  String seepageCheck;
  String generalCleanliness;
  String otherIssue;
  List<String> photo;
  int issub;
  int roomsubroomId;
  String roomsubroomName;
  DateTime createdAt;

  factory RegularInspectionRow.fromJson(Map<String, dynamic> json) =>
      RegularInspectionRow(
        id: json["id"] == null ? null : json["id"],
        termiteCheck:
            json["termite_check"] == null ? null : json["termite_check"],
        seepageCheck:
            json["seepage_check"] == null ? null : json["seepage_check"],
        generalCleanliness: json["general_cleanliness"] == null
            ? null
            : json["general_cleanliness"],
        otherIssue: json["other_issue"] == null ? null : json["other_issue"],
        photo: json["photo"] == "" ? [] : json["photo"].split(","),
        issub: json["issub"] == null ? null : json["issub"],
        roomsubroomId:
            json["roomsubroom_id"] == null ? null : json["roomsubroom_id"],
        roomsubroomName:
            json["roomsubroom_name"] == null ? null : json["roomsubroom_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "termite_check": termiteCheck == null ? null : termiteCheck,
        "seepage_check": seepageCheck == null ? null : seepageCheck,
        "general_cleanliness":
            generalCleanliness == null ? null : generalCleanliness,
        "other_issue": otherIssue == null ? null : otherIssue,
        "photo": photo == null ? null : photo,
        "issub": issub == null ? null : issub,
        "roomsubroom_id": roomsubroomId == null ? null : roomsubroomId,
        "roomsubroom_name": roomsubroomName == null ? null : roomsubroomName,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
      };
}
