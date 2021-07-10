// To parse this JSON data, do
//
//     final issueType = issueTypeFromJson(jsonString);

import 'dart:convert';

List<IssueType> issueTypeFromJson(String str) => List<IssueType>.from(json.decode(str).map((x) => IssueType.fromJson(x)));

String issueTypeToJson(List<IssueType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IssueType {
    IssueType({
        this.id,
        this.roomId,
        this.roomName,
        this.subroomId,
        this.subroomName,
        this.issueRowId,
        this.propertyId,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    int roomId;
    String roomName;
    int subroomId;
    String subroomName;
    String issueRowId;
    int propertyId;
    DateTime createdAt;
    DateTime updatedAt;

    factory IssueType.fromJson(Map<String, dynamic> json) => IssueType(
        id: json["id"] == null ? null : json["id"],
        roomId: json["room_id"] == null ? null : json["room_id"],
        roomName: json["room_name"] == null ? null : json["room_name"],
        subroomId: json["subroom_id"] == null ? null : json["subroom_id"],
        subroomName: json["subroom_name"] == null ? null : json["subroom_name"],
        issueRowId: json["issue_row_id"] == null ? null : json["issue_row_id"],
        propertyId: json["property_id"] == null ? null : json["property_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "room_id": roomId == null ? null : roomId,
        "room_name": roomName == null ? null : roomName,
        "subroom_id": subroomId == null ? null : subroomId,
        "subroom_name": subroomName == null ? null : subroomName,
        "issue_row_id": issueRowId == null ? null : issueRowId,
        "property_id": propertyId == null ? null : propertyId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}
