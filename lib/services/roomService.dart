import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Room.dart';
import 'package:propview/services/authService.dart';

class RoomService extends AuthService {
  static Future<List<Room>> getRoomByPropertyId(String propertyId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/rooms/property/$propertyId',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      if (responseMap.length == 0) {
        return [];
      } else {
        List<Room> room =
            responseMap.map<Room>((roomMap) => Room.fromJson(roomMap)).toList();
        return room;
      }
    } else {
      print("Not working!");
    }
  }
}
