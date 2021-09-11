// To parse this JSON data, do
//
//     final subRoom = subRoomFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SubRoom subRoomFromJson(String str) => SubRoom.fromJson(json.decode(str));

String subRoomToJson(SubRoom data) => json.encode(data.toJson());

class SubRoom {
  SubRoom({
    @required this.success,
    @required this.data,
  });

  bool success;
  Data data;

  factory SubRoom.fromJson(Map<String, dynamic> json) => SubRoom(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    @required this.subRoom,
  });

  List<SubRoomElement> subRoom;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        subRoom: List<SubRoomElement>.from(
            json["subRoom"].map((x) => SubRoomElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subRoom": List<dynamic>.from(subRoom.map((x) => x.toJson())),
      };
}

class SubRoomElement {
  SubRoomElement({
    @required this.propertySubRoomId,
    @required this.propertyId,
    @required this.roomId,
    @required this.subRoomId,
    @required this.roomSize1,
    @required this.roomSize2,
    @required this.facility,
    @required this.image1,
    @required this.image2,
    @required this.image3,
  });

  int propertySubRoomId;
  int propertyId;
  int roomId;
  int subRoomId;
  double roomSize1;
  double roomSize2;
  String facility;
  String image1;
  String image2;
  String image3;

  factory SubRoomElement.fromJson(Map<String, dynamic> json) => SubRoomElement(
        propertySubRoomId: json["property_sub_room_id"],
        propertyId: json["property_id"],
        roomId: json["room_id"],
        subRoomId: json["sub_room_id"],
        roomSize1: double.parse(json["room_size1"].toString()),
        roomSize2: double.parse(json["room_size2"].toString()),
        facility: json["facility"],
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
      );

  Map<String, dynamic> toJson() => {
        "property_id": propertyId,
        "room_id": roomId,
        "sub_room_id": subRoomId,
        "room_size1": roomSize1,
        "room_size2": roomSize2,
        "facility": facility,
        "image1": image1,
        "image2": image2,
        "image3": image3,
      };
}
