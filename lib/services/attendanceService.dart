import 'dart:convert';

import 'package:propview/models/Attendance.dart';
import 'package:propview/services/authService.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
class AttendanceService extends AuthService {
  static Future createLog(payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/create',
      method: 'POST',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future getAllWithoutDate() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/attendance/',
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

  static Future getAllByMangerIdWithDate(id,date) async {
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
