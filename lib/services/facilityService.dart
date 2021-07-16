import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Facility.dart';
import 'package:propview/services/authService.dart';

class FacilityService extends AuthService {
  static Future<List<Facility>> getFacilities() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/property/facility/get',
      method: 'GET',
    );
    if(response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<Facility> facility =
            responseMap.map<Facility>((facilityMap) => Facility.fromJson(facilityMap)).toList();
        return facility;
    } else {
      print('Error: ' + response.statusCode.toString() + ' Body: ' + response.body);
    }
  }
}