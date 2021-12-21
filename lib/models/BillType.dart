// To parse this JSON data, do
//
//     final billType = billTypeFromJson(jsonString);

import 'dart:convert';

List<BillType> billTypeFromJson(String str) =>
    List<BillType>.from(json.decode(str).map((x) => BillType.fromJson(x)));

String billTypeToJson(List<BillType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BillType {
  BillType({
    this.billTypeId,
    this.billName,
    this.status,
  });

  int billTypeId;
  String billName;
  int status;

  factory BillType.fromJson(Map<String, dynamic> json) => BillType(
        billTypeId: json["bill_type_id"] == null ? null : json["bill_type_id"],
        billName: json["bill_name"] == null ? null : json["bill_name"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "bill_type_id": billTypeId == null ? null : billTypeId,
        "bill_name": billName == null ? null : billName,
        "status": status == null ? null : status,
      };
}
