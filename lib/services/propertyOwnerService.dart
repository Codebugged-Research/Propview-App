import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:http/http.dart' as http;
import 'package:propview/models/Property.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:propview/services/authService.dart';

class PropertyOwnerService extends AuthService {
  // ignore: missing_return
  static Future<PropertyOwnerElement> getPropertyOwner(String id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/propertyOwner/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      PropertyOwnerElement propertyOwner = PropertyOwnerElement.fromJson(
          responseMap["data"]["propertyOwner"][0]);
      return propertyOwner;
    } else {
      print("DEBUG");
    }
  }

  static Future<List<PropertyOwnerElement>> searchOwner(String query) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/propertyOwner/search',
      method: 'POST',
      body: jsonEncode({"query": "%" + query + "%"}),
    );
    var responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<PropertyOwnerElement> propertyOwners = responseMap["propertyOwner"]
          .map<PropertyOwnerElement>((propertyOwnerElement) =>
              PropertyOwnerElement.fromJson(propertyOwnerElement))
          .toList();
      return propertyOwners;
    } else {
      print("DEBUG search");
      return [];
    }
  }


  static Future<List<PropertyElement>> searchProperty(String query) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/property/search',
      method: 'POST',
      body: jsonEncode({"query": "%" + query + "%"}),
    );
    var responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<PropertyElement> propertyOwners = responseMap["propertyOwner"]
          .map<PropertyElement>((propertyOwnerElement) =>
              PropertyElement.fromJson(propertyOwnerElement))
          .toList();
      return propertyOwners;
    } else {
      print("DEBUG search");
      return [];
    }
  }

  // ignore: missing_return
  static Future<PropertyOwner> getAllPropertyOwner() async {
    var cacheData = APICacheManager();
    bool doesExist = await cacheData.isAPICacheKeyExist("getAllPropertyOwner");
    if (doesExist) {
      APICacheDBModel responseBody =
          await cacheData.getCacheData("getAllPropertyOwner");
      DateTime lastCache =
          DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 7) {
        cacheData.deleteCache("getAllPropertyOwner");
        http.Response response = await AuthService.makeAuthenticatedRequest(
            AuthService.BASE_URI + 'api/propertyOwner',
            method: 'GET');
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getAllPropertyOwner",
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          PropertyOwner propertyOwner = PropertyOwner.fromJson(responseMap);
          return propertyOwner;
        } else {
          print("DEBUG");
        }
      } else {
        var responseMap = json.decode(responseBody.syncData);
        PropertyOwner propertyOwner = PropertyOwner.fromJson(responseMap);
        return propertyOwner;
      }
    } else {
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/propertyOwner',
          method: 'GET');
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getAllPropertyOwner",
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        PropertyOwner propertyOwner = PropertyOwner.fromJson(responseMap);
        return propertyOwner;
      } else {
        print("DEBUG");
      }
    }
  }
}
