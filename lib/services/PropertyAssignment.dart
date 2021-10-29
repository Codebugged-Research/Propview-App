import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:propview/models/Property.dart';
import 'package:propview/models/PropertyAsignmnet.dart';
import 'package:propview/services/authService.dart';

class PropertyAssignment {

  static Future getAllTempPropertiesByUserId(id) async {
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/property/assignment/user/$id',
          method: 'GET');
      if (response.statusCode == 200) {
        var responseMap = json.decode(response.body);
        Property property = Property.fromJson(responseMap);
        return property;
      } else {
        return 0;
      }
  }  
  static Future<bool>  updateTempAssignment(payload, id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/property/assignment/update/$id',
      method: 'PUT',
      body: jsonEncode(payload),
    );
      print(id);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }}

  static Future<bool> createTempAssignment(payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/property/assignment/create/',
      method: 'POST',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future getTempAssignRowByUserId(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/property/assignment/row/$id/',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      if (responseMap["propertyAssignment"].length > 0) {
        PropertyAssignmentModel model = PropertyAssignmentModel.fromJson(
            responseMap["propertyAssignment"][0]);
        return model;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  //from tbl_suser_to_property
  static Future getTempUserIDFromProperty(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/property/assignment/user/assigned/',
        method: 'POST',
        body: jsonEncode({
          "id_4": "$id",
          "id_1": "%,$id",
          "id_2": "%,$id,%",
          "id_3": "$id,%"
        }));
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      if (responseMap["data"]["propertyAssignment"].length > 0) {
        return responseMap["data"]["propertyAssignment"][0]["user_id"];
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  //from tbl_user_to_property
  static Future getTempUserIDFromProperty0(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/property/assignment/user/assigned0/',
        method: 'POST',
        body: jsonEncode({
          "id_4": "$id",
          "id_1": "%,$id",
          "id_2": "%,$id,%",
          "id_3": "$id,%"
        }));
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      if (responseMap["data"]["propertyAssignment"].length > 0) {
        return responseMap["data"]["propertyAssignment"][0]["user_id"];
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }
}
