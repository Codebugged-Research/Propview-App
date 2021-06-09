import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/User.dart';

import 'authService.dart';

class UserService extends AuthService {
  // ignore: missing_return
  static Future<User> getUser() async {
    var auth = await AuthService.getSavedAuth();
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/user/${auth['id']}',
        method: 'GET');
    if (response.statusCode == 200) {
      User user = User.fromJson(json.decode(response.body));
      return user;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<User> getUserById(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/user/$id}',
        method: 'GET');
    if (response.statusCode == 200) {
      User user = User.fromJson(json.decode(response.body));
      return user;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<List<User>> getAllUser() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/users',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<User> users =
          responseMap.map<User>((usersMap) => User.fromJson(usersMap)).toList();
      return users;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<List<User>> getAllUserUnderManger(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/user/manager/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<User> users =
          responseMap.map<User>((usersMap) => User.fromJson(usersMap)).toList();
      return users;
    } else {
      print("DEBUG");
    }
  }

  static Future<bool> updateUser(var payload) async {
    var auth = await AuthService.getSavedAuth();
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/user/update/${auth['id']}',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Debug update user");
      return false;
    }
  }

  static Future<String> getDeviceToken(String id) async {
    final Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.get(
      Uri.parse("http://68.183.247.233/api/user/deviceToken/$id"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      var decodedMsg = json.decode(response.body);
      return decodedMsg["device_token"];
    } else {
      return "";
    }
  }
}
