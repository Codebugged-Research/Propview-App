import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Task.dart';

import 'authService.dart';

class TaskService extends AuthService {
  // ignore: missing_return
  static Future<TaskElement> getTask(String task_id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/task/$task_id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      TaskElement task = TaskElement.fromJson(responseMap);
      return task;
    } else {
      print("DEBUG");
    }
  }

  static Future<bool> createTask(payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/task/create',
        body: payload,
        method: 'POST');
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }

  // ignore: missing_return
  static Future<Task> getAllTask() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/tasks',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Task taskList = Task.fromJson(responseMap);
      return taskList;
    } else {
      print("DEBUG");
    }
  }
}
