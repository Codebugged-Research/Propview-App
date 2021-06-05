import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Property.dart';

import 'authService.dart';

class PropertyService extends AuthService {
  // ignore: missing_return
  static Future<PropertyElement> getPropertyById(String id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/property/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      PropertyElement  property = PropertyElement.fromJson(responseMap["data"]["property"][0]);
      return property;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<Property> getAllProperties() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        // AuthService.BASE_URI + 'api/properties',
    AuthService.BASE_URI + 'api/property/owner/14',
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
      print(responseMap);
      print(property.toJson());
      return property;
    } else {
      print("DEBUG");
    }
  }

  static Future<String> getSocietyName(id)async{
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/property/society/$id',
        method: 'GET');
    var responseMap = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseMap[0]["socname"];
    }else{
      return "error";
    }
  }
}