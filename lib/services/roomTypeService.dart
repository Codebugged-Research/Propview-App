import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:propview/models/RoomType.dart';

import 'authService.dart';

class RoomTypeService extends AuthService {
  // ignore: missing_return
  static Future<RoomType> getRoomTypes() async {
    var cacheData = APICacheManager();
    bool doesExist = await cacheData.isAPICacheKeyExist("getRoomTypes");
    if (doesExist) {
      APICacheDBModel responseBody = await cacheData.getCacheData("getRoomTypes");
      DateTime lastCache =
      DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 30) {
        cacheData.deleteCache("getRoomTypes");
        http.Response response = await AuthService.makeAuthenticatedRequest(
            AuthService.BASE_URI + 'api/property/room/get/',
            method: 'GET');
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getRoomTypes",
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          RoomType roomTypes = RoomType.fromJson(responseMap);
          return roomTypes;
        } else {
          print("DEBUG");
        }
      } else {
        var responseMap = json.decode(responseBody.syncData);
        RoomType roomTypes = RoomType.fromJson(responseMap);
        return roomTypes;
      }
    } else {
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/property/room/get/',
          method: 'GET');
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getRoomTypes",
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        RoomType roomTypes = RoomType.fromJson(responseMap);
        return roomTypes;
      } else {
        print("DEBUG");
      }
    }
  }


}
