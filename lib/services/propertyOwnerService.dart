import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/models/Task.dart';

import 'authService.dart';

class PropertyOwnerService extends AuthService {
  // ignore: missing_return
  static Future<PropertyOwnerElement> getPropertyOwner(String id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/propertyOwner/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      PropertyOwnerElement  propertyOwner = PropertyOwnerElement.fromJson(responseMap);
      return propertyOwner;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<PropertyOwner> getAllPropertyOwner() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/propertyOwner',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      PropertyOwner propertyOwner = PropertyOwner.fromJson(responseMap);
      return propertyOwner;
    } else {
      print("DEBUG");
    }
  }
}