import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Property.dart';
import 'package:propview/models/PropertyOwner.dart';

import 'authService.dart';

class PropertyService extends AuthService {
  // ignore: missing_return
  static Future<PropertyElement> getPropertyById(String id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/property/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      PropertyElement  property = PropertyElement.fromJson(responseMap);
      return property;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<Property> getAllProperties() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/properties',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Property property = Property.fromJson(responseMap);
      return property;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<Property> getAllPropertiesByOwnerId(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/property/owner/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Property property = Property.fromJson(responseMap);
      return property;
    } else {
      print("DEBUG");
    }
  }
}