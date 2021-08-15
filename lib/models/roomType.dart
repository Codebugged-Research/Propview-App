// To parse this JSON data, do
//
//     final roomType = roomTypeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RoomType roomTypeFromJson(String str) => RoomType.fromJson(json.decode(str));

String roomTypeToJson(RoomType data) => json.encode(data.toJson());

class RoomType {
  RoomType({
    @required this.count,
    @required this.data,
  });

  int count;
  Data data;

  factory RoomType.fromJson(Map<String, dynamic> json) => RoomType(
        count: json["count"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    @required this.propertyRoom,
  });

  List<PropertyRoom> propertyRoom;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        propertyRoom: List<PropertyRoom>.from(
            json["propertyRoom"].map((x) => PropertyRoom.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "propertyRoom": List<dynamic>.from(propertyRoom.map((x) => x.toJson())),
      };
}

class PropertyRoom {
  PropertyRoom({
    @required this.roomId,
    @required this.issub,
    @required this.roomName,
    @required this.status,
  });

  int roomId;
  int issub;
  String roomName;
  int status;

  factory PropertyRoom.fromJson(Map<String, dynamic> json) => PropertyRoom(
        roomId: json["room_id"],
        issub: json["issub"],
        roomName: json["room_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "issub": issub,
        "room_name": roomName,
        "status": status,
      };
}
