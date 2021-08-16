// To parse this JSON data, do
//
//     final issue = issueFromJson(jsonString);

import 'dart:convert';

List<Issue> issueFromJson(String str) =>
    List<Issue>.from(json.decode(str).map((x) => Issue.fromJson(x)));

String issueToJson(List<Issue> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Issue {
  Issue({
    this.issueId,
    this.issueName,
    this.status,
    this.remarks,
    this.photo,
  });

  int issueId;
  String issueName;
  String status;
  String remarks;
  List<String> photo;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        issueId: json["issue_id"] == null ? null : json["issue_id"],
        issueName: json["issue_name"] == null ? null : json["issue_name"],
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        photo: json["photo"] == null ? null : json["photo"].split(","),
      );

  Map<String, dynamic> toJson() => {
        "issue_id": issueId == null ? null : issueId,
        "issue_name": issueName == null ? null : issueName,
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "photo": photo == null ? null : photo,
      };
}
