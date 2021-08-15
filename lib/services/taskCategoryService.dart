import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:http/http.dart' as http;
import 'package:propview/models/TaskCategory.dart';

import 'authService.dart';

class TaskCategoryService extends AuthService {
  // ignore: missing_return
  static Future<TaskCategory> getTaskCategory(String taskId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/taskCategory/$taskId',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      TaskCategory taskCategory = TaskCategory.fromJson(responseMap);
      return taskCategory;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<List<TaskCategory>> getTaskCategories() async {
    var cacheData = APICacheManager();
    bool doesExist = await cacheData.isAPICacheKeyExist("getTaskCategories");
    if (doesExist) {
      APICacheDBModel responseBody =
          await cacheData.getCacheData("getTaskCategories");
      DateTime lastCache =
          DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 7) {
        cacheData.deleteCache("getTaskCategories");
        http.Response response = await AuthService.makeAuthenticatedRequest(
            AuthService.BASE_URI + 'api/taskCategories',
            method: 'GET');
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getTaskCategories",
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          List<TaskCategory> taskCategories = responseMap
              .map<TaskCategory>((usersMap) => TaskCategory.fromJson(usersMap))
              .toList();
          return taskCategories;
        } else {
          print("DEBUG");
        }
      } else {
        var responseMap = json.decode(responseBody.syncData);
        List<TaskCategory> taskCategories = responseMap
            .map<TaskCategory>((usersMap) => TaskCategory.fromJson(usersMap))
            .toList();
        return taskCategories;
      }
    } else {
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/taskCategories',
          method: 'GET');
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getTaskCategories",
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        List<TaskCategory> taskCategories = responseMap
            .map<TaskCategory>((usersMap) => TaskCategory.fromJson(usersMap))
            .toList();
        return taskCategories;
      } else {
        print("DEBUG");
      }
    }
  }
}
