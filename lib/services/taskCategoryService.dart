import 'dart:convert';

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
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/taskCategories',
        method: 'GET');
    if (response.statusCode == 200) {
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
