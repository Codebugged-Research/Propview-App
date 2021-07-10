// To parse this JSON data, do
//
//     final issue = issueFromJson(jsonString);

import 'dart:convert';

List<Issue> issueFromJson(String str) => List<Issue>.from(json.decode(str).map((x) => Issue.fromJson(x)));

String issueToJson(List<Issue> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Issue {
    Issue({
        this.issueId,
        this.issueName,
        this.status,
        this.remarks,
        this.photo,
        this.createdAt,
        this.updatedAt,
    });

    int issueId;
    String issueName;
    String status;
    String remarks;
    String photo;
    DateTime createdAt;
    DateTime updatedAt;

    factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        issueId: json["issue_id"] == null ? null : json["issue_id"],
        issueName: json["issue_name"] == null ? null : json["issue_name"],
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        photo: json["photo"] == null ? null : json["photo"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "issue_id": issueId == null ? null : issueId,
        "issue_name": issueName == null ? null : issueName,
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "photo": photo == null ? null : photo,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}
