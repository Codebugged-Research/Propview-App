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

  static Future<bool> updateTask(id, payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/task/update/$id',
        body: payload,
        method: 'PUT');
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

  // ignore: missing_return
  static Future<Task> getAllTaskByUserId(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/task/user/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Task taskList = Task.fromJson(responseMap);
      return taskList;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<Task> getAllPendingTaskByUserId(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/task/pending/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Task taskList = Task.fromJson(responseMap);
      return taskList;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<Task> getAllTaskByManagerId(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/task/manager/',
        method: 'POST',
        body: jsonEncode(
            {"id1": "$id", "id2": "%,$id", "id31": "%,$id,%", "id4": "$id,%"}));
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Task taskList = Task.fromJson(responseMap);
      return taskList;
    } else {
      print("DEBUG");
    }
  }
}
