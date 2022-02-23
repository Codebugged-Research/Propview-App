// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  Room({
    @required this.success,
    @required this.data,
  });

  bool success;
  Data data;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
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
    @required this.roomsToPropertyModel,
  });

  List<RoomsToPropertyModel> roomsToPropertyModel;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        roomsToPropertyModel: List<RoomsToPropertyModel>.from(
            json["roomsToPropertyModel"]
                .map((x) => RoomsToPropertyModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "roomsToPropertyModel":
            List<dynamic>.from(roomsToPropertyModel.map((x) => x.toJson())),
      };
}

class RoomsToPropertyModel {
  RoomsToPropertyModel({
    @required this.propertyRoomId,
    @required this.propertyId,
    @required this.roomId,
    @required this.roomSize1,
    @required this.roomSize2,
    @required this.bath,
    @required this.flooring,
    @required this.balcony,
    @required this.wardrobe,
    @required this.facility,
  });

  int propertyRoomId;
  int propertyId;
  int roomId;
  double roomSize1;
  double roomSize2;
  int bath;
  String flooring;
  int balcony;
  int wardrobe;
  String facility;

  factory RoomsToPropertyModel.fromJson(Map<String, dynamic> json) =>
      RoomsToPropertyModel(
        propertyRoomId: json["property_room_id"],
        propertyId: json["property_id"],
        roomId: json["room_id"],
        roomSize1: double.parse(json["room_size1"].toString()),
        roomSize2: double.parse(json["room_size2"].toString()),
        bath: json["bath"],
        flooring: json["flooring"],
        balcony: json["balcony"],
        wardrobe: json["wardrobe"],
        facility:  json["facility"],
      );

  Map<String, dynamic> toJson() => {
        "property_room_id": propertyRoomId,
        "property_id": propertyId,
        "room_id": roomId,
        "room_size1": roomSize1,
        "room_size2": roomSize2,
        "bath": bath,
        "flooring": flooring,
        "balcony": balcony,
        "wardrobe": wardrobe,
        "facility": facility,
      };
}
