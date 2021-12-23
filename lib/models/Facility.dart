// To parse this JSON data, do
//
//     final facility = facilityFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Facility> facilityFromJson(String str) => List<Facility>.from(json.decode(str).map((x) => Facility.fromJson(x)));

String facilityToJson(List<Facility> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Facility {
    Facility({
        @required this.facilityId,
        @required this.facilityName,
        @required this.facilityIcon,
        @required this.status,
        @required this.roomId,
        @required this.furnishing,
    });

    int facilityId;
    String facilityName;
    String facilityIcon;
    int status;
    String roomId;
    String furnishing;

    factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        facilityId: json["facility_id"],
        facilityName: json["facility_name"],
        facilityIcon: json["facility_icon"],
        status: json["status"],
        roomId: json["room_id"],
        furnishing: json["furnishing"],
    );

    Map<String, dynamic> toJson() => {
        "facility_id": facilityId,
        "facility_name": facilityName,
        "facility_icon": facilityIcon,
        "status": status,
        "room_id": roomId,
        "furnishing": furnishing,
    };
}
