import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/services/authService.dart';

class RegularInspectionService extends AuthService {

  static Future<bool> createRegularInspection(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/regular/create/',
        method: 'POST',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else
      return false;
  }

  // ignore: missing_return
  static Future<List<RegularInspection>> getRegularInspectionById(
      var id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/regular/get/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<RegularInspection> regularInspection = responseMap
          .map<RegularInspection>((regularInspectionMap) =>
              RegularInspection.fromJson(regularInspectionMap))
          .toList();
      return regularInspection;
    } else {
      print('Not Working!');
    }
  }

  // ignore: missing_return
  static Future<List<RegularInspection>> getRegularInspectionByPropertyId(
      var id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/regular/property/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<RegularInspection> regularInspection = responseMap
          .map<RegularInspection>((regularInspectionMap) =>
              RegularInspection.fromJson(regularInspectionMap))
          .toList();
      return regularInspection;
    } else {
      print('Not Working!');
    }
  }
}
