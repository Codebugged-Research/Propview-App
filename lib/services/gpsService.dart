import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:propview/models/User.dart';
import 'package:propview/services/authService.dart';
import 'package:propview/services/userService.dart';

import 'package:latlong2/latlong.dart';
dateFormatter() {
    var date = DateTime.now();
    return '${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${DateTime.now().year}';
  }
class GPSService extends AuthService {
  static Future<List<LatLng>> getLocation(userId,date) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/gps/$userId/$date',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      return responseMap
          .map<LatLng>((e) => LatLng(double.parse(e['lat'].toString()), double.parse(e['lon'].toString())))
          .toList();
    } else {
      print('Body: ' + response.body);
      return [];
    }
  }

  static Future<bool> createGPS(lat, lon) async {
    var auth = await AuthService.getSavedAuth();
    User user = await UserService.getUserById(auth['id']);
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/gps/',
      method: 'POST',
      body: json.encode({
        "user_id": user.userId,
        "lat": lat,
        "lon": lon,
        "created_at": dateFormatter(),
      }),
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      print(responseMap);
      return true;
    } else {
      print('Body: ' + response.body);
      return false;
    }
  }
}
