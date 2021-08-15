// To parse this JSON data, do
//
//     final billToProperty = billToPropertyFromJson(jsonString);

import 'dart:convert';

List<BillToProperty> billToPropertyFromJson(String str) =>
    List<BillToProperty>.from(
        json.decode(str).map((x) => BillToProperty.fromJson(x)));

String billToPropertyToJson(List<BillToProperty> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BillToProperty {
  BillToProperty({
    this.id,
    this.propertyId,
    this.billTypeId,
    this.authorityName,
    this.billId,
    this.amount,
    this.lastUpdate,
    this.addedBy,
    this.dateAdded,
  });

  int id;
  int propertyId;
  int billTypeId;
  String authorityName;
  String billId;
  double amount;
  DateTime lastUpdate;
  int addedBy;
  DateTime dateAdded;

  factory BillToProperty.fromJson(Map<String, dynamic> json) => BillToProperty(
        id: json["id"] == null ? null : json["id"],
        propertyId: json["property_id"] == null ? null : json["property_id"],
        billTypeId: json["bill_type_id"] == null ? null : json["bill_type_id"],
        authorityName:
            json["authority_name"] == null ? null : json["authority_name"],
        billId: json["bill_id"] == null ? null : json["bill_id"],
        amount: json["amount"] == null
            ? null
            : double.parse(json["amount"].toString()),
        lastUpdate: json["last_update"] == null
            ? null
            : DateTime.parse(json["last_update"]),
        addedBy: json["added_by"] == null ? null : json["added_by"],
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "property_id": propertyId == null ? null : propertyId,
        "bill_type_id": billTypeId == null ? null : billTypeId,
        "authority_name": authorityName == null ? null : authorityName,
        "bill_id": billId == null ? null : billId,
        "amount": amount == null ? null : amount,
        "last_update": lastUpdate == null ? null : lastUpdate.toIso8601String(),
        "added_by": addedBy == null ? null : addedBy,
        "date_added": dateAdded == null ? null : dateAdded.toIso8601String(),
      };
}
