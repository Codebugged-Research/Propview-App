// To parse this JSON data, do
//
//     final tenant = tenantFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Tenant> tenantFromJson(String str) => List<Tenant>.from(json.decode(str).map((x) => Tenant.fromJson(x)));

String tenantToJson(List<Tenant> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tenant {
  Tenant({
    @required this.tenantId,
    @required this.name,
    @required this.password,
    @required this.pemail,
    @required this.semail,
    @required this.pmobile,
    @required this.smobile,
    @required this.hphone,
    @required this.ophone,
    @required this.isfamily,
    @required this.paddress,
    @required this.city,
    @required this.state,
    @required this.pan,
    @required this.aadhar,
    @required this.citizenship,
    @required this.company,
    @required this.caddress,
    @required this.designation,
    @required this.totalmembers,
    @required this.plandlord,
    @required this.plandlordNumber,
    @required this.spouseName,
    @required this.spouseEmail,
    @required this.spouseMobile,
    @required this.status,
    @required this.billing,
  });

  int tenantId;
  String name;
  String password;
  String pemail;
  String semail;
  String pmobile;
  String smobile;
  String hphone;
  String ophone;
  int isfamily;
  String paddress;
  int city;
  int state;
  String pan;
  String aadhar;
  String citizenship;
  String company;
  String caddress;
  String designation;
  int totalmembers;
  String plandlord;
  String plandlordNumber;
  String spouseName;
  String spouseEmail;
  String spouseMobile;
  int status;
  int billing;

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
    tenantId: json["tenant_id"] == null ? null : json["tenant_id"],
    name: json["name"] == null ? null : json["name"],
    password: json["password"] == null ? null : json["password"],
    pemail: json["pemail"] == null ? null : json["pemail"],
    semail: json["semail"] == null ? null : json["semail"],
    pmobile: json["pmobile"] == null ? null : json["pmobile"],
    smobile: json["smobile"] == null ? null : json["smobile"],
    hphone: json["hphone"] == null ? null : json["hphone"],
    ophone: json["ophone"] == null ? null : json["ophone"],
    isfamily: json["isfamily"] == null ? null : json["isfamily"],
    paddress: json["paddress"] == null ? null : json["paddress"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    pan: json["pan"] == null ? null : json["pan"],
    aadhar: json["aadhar"] == null ? null : json["aadhar"],
    citizenship: json["citizenship"] == null ? null : json["citizenship"],
    company: json["company"] == null ? null : json["company"],
    caddress: json["caddress"] == null ? null : json["caddress"],
    designation: json["designation"] == null ? null : json["designation"],
    totalmembers: json["totalmembers"] == null ? null : json["totalmembers"],
    plandlord: json["plandlord"] == null ? null : json["plandlord"],
    plandlordNumber: json["plandlord_number"] == null ? null : json["plandlord_number"],
    spouseName: json["spouse_name"] == null ? null : json["spouse_name"],
    spouseEmail: json["spouse_email"] == null ? null : json["spouse_email"],
    spouseMobile: json["spouse_mobile"] == null ? null : json["spouse_mobile"],
    status: json["status"] == null ? null : json["status"],
    billing: json["billing"] == null ? null : json["billing"],
  );

  Map<String, dynamic> toJson() => {
    "tenant_id": tenantId == null ? null : tenantId,
    "name": name == null ? null : name,
    "password": password == null ? null : password,
    "pemail": pemail == null ? null : pemail,
    "semail": semail == null ? null : semail,
    "pmobile": pmobile == null ? null : pmobile,
    "smobile": smobile == null ? null : smobile,
    "hphone": hphone == null ? null : hphone,
    "ophone": ophone == null ? null : ophone,
    "isfamily": isfamily == null ? null : isfamily,
    "paddress": paddress == null ? null : paddress,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "pan": pan == null ? null : pan,
    "aadhar": aadhar == null ? null : aadhar,
    "citizenship": citizenship == null ? null : citizenship,
    "company": company == null ? null : company,
    "caddress": caddress == null ? null : caddress,
    "designation": designation == null ? null : designation,
    "totalmembers": totalmembers == null ? null : totalmembers,
    "plandlord": plandlord == null ? null : plandlord,
    "plandlord_number": plandlordNumber == null ? null : plandlordNumber,
    "spouse_name": spouseName == null ? null : spouseName,
    "spouse_email": spouseEmail == null ? null : spouseEmail,
    "spouse_mobile": spouseMobile == null ? null : spouseMobile,
    "status": status == null ? null : status,
    "billing": billing == null ? null : billing,
  };
}
