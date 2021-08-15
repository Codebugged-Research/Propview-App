import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:propview/models/State.dart';
import 'package:propview/services/authService.dart';

class StateService extends AuthService {
  // ignore: missing_return

  static Future<List<CStates>> getStates() async {
    var cacheData = APICacheManager();
    bool doesExist = await cacheData.isAPICacheKeyExist("getStates");
    if (doesExist) {
      APICacheDBModel responseBody = await cacheData.getCacheData("getStates");
      DateTime lastCache =
      DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 30) {
        cacheData.deleteCache("getStates");
        http.Response response = await AuthService.makeAuthenticatedRequest(
            AuthService.BASE_URI + 'api/state/all/',
            method: 'GET');
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getStates",
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          List<CStates> cstate = responseMap
              .map<CStates>((stateMap) => CStates.fromJson(stateMap))
              .toList();
          return cstate;
        } else {
          print("DEBUG");
        }
      } else {
        var responseMap = json.decode(responseBody.syncData);
        List<CStates> cstate = responseMap
            .map<CStates>((stateMap) => CStates.fromJson(stateMap))
            .toList();
        return cstate;
      }
    } else {
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/state/all/',
          method: 'GET');
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getStates",
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        List<CStates> cstate = responseMap
            .map<CStates>((stateMap) => CStates.fromJson(stateMap))
            .toList();
        return cstate;
      } else {
        print("DEBUG");
      }
    }
  }

  // ignore: missing_return
  static Future<String> getStateById(var id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/state/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      CStates cstate = CStates.fromJson(responseMap);
      return cstate.sname.toString();
    } else {
      print('Not Working!');
    }
  }
}
