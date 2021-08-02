import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:propview/models/City.dart';
import 'package:propview/services/authService.dart';

class CityService extends AuthService {
  // ignore: missing_return
  // static Future<List<City>> getCities() async {
  //   http.Response response = await AuthService.makeAuthenticatedRequest(
  //       AuthService.BASE_URI + 'api/city/all/',
  //       method: 'GET');
  //   if (response.statusCode == 200) {
  //     var responseMap = json.decode(response.body);
  //     List<City> city =
  //         responseMap.map<City>((cityMap) => City.fromJson(cityMap)).toList();
  //     return city;
  //   } else {
  //     print('Not Working!');
  //   }
  // }

  static Future<List<City>> getCities() async {
    var cacheData = APICacheManager();
    bool doesExist = await cacheData.isAPICacheKeyExist("getCities");
    if (doesExist) {
      APICacheDBModel responseBody = await cacheData.getCacheData("getCities");
      DateTime lastCache =
      DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 30) {
        cacheData.deleteCache("getCities");
        http.Response response = await AuthService.makeAuthenticatedRequest(
            AuthService.BASE_URI + 'api/city/all/',
            method: 'GET');
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getCities",
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          List<City> city =
          responseMap.map<City>((cityMap) => City.fromJson(cityMap)).toList();
          return city;
        } else {
          print("DEBUG");
        }
      } else {
        var responseMap = json.decode(responseBody.syncData);
        List<City> city =
        responseMap.map<City>((cityMap) => City.fromJson(cityMap)).toList();
        return city;
      }
    } else {
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/city/all/',
          method: 'GET');
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getCities",
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        List<City> city =
        responseMap.map<City>((cityMap) => City.fromJson(cityMap)).toList();
        return city;
      } else {
        print("DEBUG");
      }
    }
  }

  // ignore: missing_return
  static Future<String> getCityById(var id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/city/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      City city = City.fromJson(responseMap);
      return city.ccname.toString();
    } else {
      print('Not Working!');
    }
  }
}
