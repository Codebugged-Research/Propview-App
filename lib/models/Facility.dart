// To parse this JSON data, do
//
//     final facility = facilityFromJson(jsonString);

import 'dart:convert';

List<Facility> facilityFromJson(String str) => List<Facility>.from(json.decode(str).map((x) => Facility.fromJson(x)));

String facilityToJson(List<Facility> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Facility {
    Facility({
        this.facilityId,
        this.facilityName,
        this.facilityIcon,
        this.status,
    });

    int facilityId;
    String facilityName;
    String facilityIcon;
    int status;

    factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        facilityId: json["facility_id"] == null ? null : json["facility_id"],
        facilityName: json["facility_name"] == null ? null : json["facility_name"],
        facilityIcon: json["facility_icon"] == null ? null : json["facility_icon"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "facility_id": facilityId == null ? null : facilityId,
        "facility_name": facilityName == null ? null : facilityName,
        "facility_icon": facilityIcon == null ? null : facilityIcon,
        "status": status == null ? null : status,
    };
}
