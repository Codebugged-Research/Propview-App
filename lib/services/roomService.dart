import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Room.dart';
import 'package:propview/services/authService.dart';

class RoomService extends AuthService {
  static Future<List<RoomsToPropertyModel>> getRoomByPropertyId(String propertyId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/rooms/property/$propertyId',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      if (responseMap.length == 0) {
        return [];
      } else {
        List<RoomsToPropertyModel> room =
            responseMap.map<RoomsToPropertyModel>((roomMap) => RoomsToPropertyModel.fromJson(roomMap)).toList();
        return room;
      }
    } else {
      print("Not working!");
    }
  }

  // ignore: missing_return
  static Future createRoomByPropertyId(payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/rooms/create',
        method: 'POST',
        body: payload);
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print("Not working!");
      print(response.body);
      return false;
    }
  }
}
