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
    roomsToPropertyModel: List<RoomsToPropertyModel>.from(json["roomsToPropertyModel"].map((x) => RoomsToPropertyModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "roomsToPropertyModel": List<dynamic>.from(roomsToPropertyModel.map((x) => x.toJson())),
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
    @required this.image1,
    @required this.image2,
    @required this.image3,
  });

  int propertyRoomId;
  int propertyId;
  int roomId;
  int roomSize1;
  int roomSize2;
  int bath;
  String flooring;
  int balcony;
  int wardrobe;
  String facility;
  String image1;
  String image2;
  String image3;

  factory RoomsToPropertyModel.fromJson(Map<String, dynamic> json) => RoomsToPropertyModel(
    propertyRoomId: json["property_room_id"],
    propertyId: json["property_id"],
    roomId: json["room_id"],
    roomSize1: json["room_size1"],
    roomSize2: json["room_size2"],
    bath: json["bath"],
    flooring: json["flooring"],
    balcony: json["balcony"],
    wardrobe: json["wardrobe"],
    facility: json["facility"],
    image1: json["image1"],
    image2: json["image2"],
    image3: json["image3"],
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
    "image1": image1,
    "image2": image2,
    "image3": image3,
  };
}
