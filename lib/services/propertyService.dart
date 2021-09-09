import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
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
      PropertyElement property =
          PropertyElement.fromJson(responseMap["data"]["property"][0]);
      return property;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<Property> getAllProperties() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/properties',
        // AuthService.BASE_URI + 'api/property/owner/14',
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
  static Future<Property> getAllPropertiesByLimit(offset, limit) async {
    var cacheData = APICacheManager();
    bool doesExist = await cacheData
        .isAPICacheKeyExist("getAllProperties" + offset.toString());
    if (doesExist) {
      APICacheDBModel responseBody =
          await cacheData.getCacheData("getAllProperties" + offset.toString());
      DateTime lastCache =
          DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 1) {
        print("reset");
        cacheData.deleteCache("getAllProperties" + offset.toString());
        http.Response response = await AuthService.makeAuthenticatedRequest(
            AuthService.BASE_URI + 'api/properties/limit',
            method: 'POST',
            body: jsonEncode({"offset": offset, "limit": limit}));
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getAllProperties" + offset.toString(),
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          Property property = Property.fromJson(responseMap);
          return property;
        } else {
          print("DEBUG");
        }
      } else {
        print("reuse");
        var responseMap = json.decode(responseBody.syncData);
        Property property = Property.fromJson(responseMap);
        return property;
      }
    } else {
      print("new");
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/properties/limit',
          method: 'POST',
          body: jsonEncode({"offset": offset, "limit": limit}));
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getAllProperties" + offset.toString(),
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        Property property = Property.fromJson(responseMap);
        return property;
      } else {
        print("DEBUG");
      }
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

  // ignore: missing_return
  static Future<Property> getAllPropertiesByUserId(id) async {
    var cacheData = APICacheManager();
    bool doesExist = await cacheData
        .isAPICacheKeyExist("getAllPropertiesByUserId" + id.toString());
    if (doesExist) {
      APICacheDBModel responseBody = await cacheData
          .getCacheData("getAllPropertiesByUserId" + id.toString());
      DateTime lastCache =
          DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 1) {
        cacheData.deleteCache("getAllPropertiesByUserId" + id.toString());
        http.Response response = await AuthService.makeAuthenticatedRequest(
            AuthService.BASE_URI + 'api/properties/user/$id',
            method: 'GET');
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getAllPropertiesByUserId" + id.toString(),
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          Property property = Property.fromJson(responseMap);
          return property;
        } else {
          print("DEBUG");
        }
      } else {
        print("reuse");
        var responseMap = json.decode(responseBody.syncData);
        Property property = Property.fromJson(responseMap);
        return property;
      }
    } else {
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/properties/user/$id',
          method: 'GET');
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getAllPropertiesByUserId" + id.toString(),
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        Property property = Property.fromJson(responseMap);
        return property;
      } else {
        print("DEBUG");
      }
    }
  }

  // ignore: missing_return
  static Future<String> getSocietyName(id) async {
    var cacheData = APICacheManager();
    bool doesExist =
        await cacheData.isAPICacheKeyExist("getSocietyName" + id.toString());
    if (doesExist) {
      APICacheDBModel responseBody =
          await cacheData.getCacheData("getSocietyName" + id.toString());
      DateTime lastCache =
          DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 1) {
        cacheData.deleteCache("getSocietyName" + id.toString());
        http.Response response = await AuthService.makeAuthenticatedRequest(
            AuthService.BASE_URI + 'api/property/society/$id',
            method: 'GET');
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getSocietyName" + id.toString(),
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          return responseMap[0]["socname"];
        } else {
          print("DEBUG");
        }
      } else {
        var responseMap = json.decode(responseBody.syncData);
        return responseMap[0]["socname"];
      }
    } else {
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/property/society/$id',
          method: 'GET');
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getSocietyName" + id.toString(),
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        return responseMap[0]["socname"];
      } else {
        print("DEBUG");
      }
    }
  }

  static Future<String> getCountryName(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/property/country/$id',
        method: 'GET');
    var responseMap = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseMap[0]["cname"];
    } else {
      return "error";
    }
  }

  static Future<bool> updateProperty(var payload, var propertyId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/property/update/$propertyId',
        method: 'PUT',
        body: payload);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
