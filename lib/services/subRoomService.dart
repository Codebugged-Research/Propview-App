import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Subroom.dart';
import 'package:propview/services/authService.dart';

class SubRoomService extends AuthService {
  static Future<bool> createSubRoom(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'subroom/create',
        method: 'POST',
        body: payload);

    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<List<SubRoom>> getAllSubRooms() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'subroom/get',
        method: 'GET');

    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<SubRoom> subRoom = responseMap["data"]
          .map<SubRoom>((subRoomMap) => SubRoom.fromJson(subRoomMap))
          .toList();
      return subRoom;
    } else
      print("Not Working");
  }

  static Future<List<SubRoom>> getSubRoomByPropertyId(String propertyId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'subroom/get/property/$propertyId',
        method: 'GET');

    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<SubRoom> subRoom = responseMap["data"]
          .map<SubRoom>((subRoomMap) => SubRoom.fromJson(subRoomMap))
          .toList();
      return subRoom;
    } else
      print("Not Working");
  }

  static Future<bool> updateSubRoom(var payload, String subRoomId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + '/subroom/update/$subRoomId',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<bool> deleteSubRoom(String subRoomId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + '/subroom/delete/$subRoomId',
        method: 'DELETE');
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }
}
