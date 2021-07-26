// To parse this JSON data, do
//
//     final tenantFamily = tenantFamilyFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<TenantFamily> tenantFamilyFromJson(String str) => List<TenantFamily>.from(json.decode(str).map((x) => TenantFamily.fromJson(x)));

String tenantFamilyToJson(List<TenantFamily> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TenantFamily {
  TenantFamily({
    @required this.familyId,
    @required this.tenantId,
    @required this.name,
    @required this.sex,
    @required this.age,
    @required this.mobile,
    @required this.email,
    @required this.relationship,
  });

  int familyId;
  int tenantId;
  String name;
  String sex;
  String age;
  String mobile;
  String email;
  String relationship;

  factory TenantFamily.fromJson(Map<String, dynamic> json) => TenantFamily(
    familyId: json["family_id"] == null ? null : json["family_id"],
    tenantId: json["tenant_id"] == null ? null : json["tenant_id"],
    name: json["name"] == null ? null : json["name"],
    sex: json["sex"] == null ? null : json["sex"],
    age: json["age"] == null ? null : json["age"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    email: json["email"] == null ? null : json["email"],
    relationship: json["relationship"] == null ? null : json["relationship"],
  );

  Map<String, dynamic> toJson() => {
    "family_id": familyId == null ? null : familyId,
    "tenant_id": tenantId == null ? null : tenantId,
    "name": name == null ? null : name,
    "sex": sex == null ? null : sex,
    "age": age == null ? null : age,
    "mobile": mobile == null ? null : mobile,
    "email": email == null ? null : email,
    "relationship": relationship == null ? null : relationship,
  };
}
