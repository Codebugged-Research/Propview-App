// To parse this JSON data, do
//
//     final propertyAssignmentModel = propertyAssignmentModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<PropertyAssignmentModel> propertyAssignmentModelFromJson(String str) => List<PropertyAssignmentModel>.from(json.decode(str).map((x) => PropertyAssignmentModel.fromJson(x)));

String propertyAssignmentModelToJson(List<PropertyAssignmentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PropertyAssignmentModel {
    PropertyAssignmentModel({
        @required this.userToPropertyId,
        @required this.userId,
        @required this.propertyId,
    });

    int userToPropertyId;
    int userId;
    String propertyId;

    factory PropertyAssignmentModel.fromJson(Map<String, dynamic> json) => PropertyAssignmentModel(
        userToPropertyId: json["user_to_property_id"],
        userId: json["user_id"],
        propertyId: json["property_id"],
    );

    Map<String, dynamic> toJson() => {
        "user_to_property_id": userToPropertyId,
        "user_id": userId,
        "property_id": propertyId,
    };
}
