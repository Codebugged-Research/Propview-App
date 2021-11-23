import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Subroom.dart';
import 'package:propview/services/authService.dart';

class SubRoomService extends AuthService {
  static Future<bool> createSubRoom(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/subroom/create',
        method: 'POST',
        body: payload);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<List<SubRoomElement>> getAllSubRooms() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/subroom/get',
        method: 'GET');

    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      if (responseMap.length == 0) {
        return [];
      } else {
        List<SubRoomElement> subRoom = responseMap
            .map<SubRoomElement>(
                (subRoomMap) => SubRoomElement.fromJson(subRoomMap))
            .toList();
        return subRoom;
      }
    } else{      
      print("Not working!");
      return [];
    }
  }

  static Future<List<SubRoomElement>> getSubRoomByPropertyId(
      String propertyId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/subroom/get/property/$propertyId',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      if (responseMap.length == 0) {
        return [];
      } else {
        List<SubRoomElement> subRoom = responseMap
            .map<SubRoomElement>(
                (subRoomMap) => SubRoomElement.fromJson(subRoomMap))
            .toList();
        return subRoom;
      }
    } else
      print("Not Working");
  }

  static Future<bool> updateSubRoom(var payload, String subRoomId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/subroom/update/$subRoomId',
        method: 'PUT',
        body: payload);
    print(response.body);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<bool> deleteSubRoom(String subRoomId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/subroom/delete/$subRoomId',
        method: 'DELETE');
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }
}
