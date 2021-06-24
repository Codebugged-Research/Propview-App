import 'dart:convert';

import 'package:propview/models/Attendance.dart';
import 'package:propview/services/authService.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
class AttendanceService extends AuthService {
  static Future getLogById(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/$id',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      Attendance attendance = Attendance.fromJson(responseMap);
      return attendance.data.attendance[0];
    } else {
      return false;
    }
  }

  static Future createLog(payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/create',
      method: 'POST',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body)["data"]["attendance"]["insertId"];
    } else {
      return false;
    }
  }

  static Future updateLog(payload, id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/update/$id',
      method: 'PUT',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
  static Future getAllWithoutDate(offset,limit) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/',
      method: 'POST',
      body: jsonEncode({"offset": offset,"limit":limit})
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Attendance attendance = Attendance.fromJson(responseMap);
      return attendance;
    } else {
      return false;
    }
  }

  static Future getAllWithDate(date) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/date/$date',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Attendance attendance = Attendance.fromJson(responseMap);
      return attendance;
    } else {
      return false;
    }
  }

  static Future getAllByMangerIdWithoutDate(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/manager/$id',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Attendance attendance = Attendance.fromJson(responseMap);
      return attendance;
    } else {
      return false;
    }
  }

  static Future getAllUserIdWithoutDate(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/user/$id',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Attendance attendance = Attendance.fromJson(responseMap);
      return attendance;
    } else {
      return false;
    }
  }

  static Future getAllByMangerIdWithDate(id, date) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/manager/$id/$date',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Attendance attendance = Attendance.fromJson(responseMap);
      return attendance;
    } else {
      return false;
    }
  }
}
