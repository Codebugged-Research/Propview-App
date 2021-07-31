import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/City.dart';
import 'package:propview/services/authService.dart';

class CityService extends AuthService {
  // ignore: missing_return
  static Future<List<City>> getCities() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/city/all/',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<City> city =
          responseMap.map<City>((cityMap) => City.fromJson(cityMap)).toList();
      return city;
    } else {
      print('Not Working!');
    }
  }
}
