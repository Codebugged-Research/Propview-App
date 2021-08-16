import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/RegularInspectionRow.dart';
import 'package:propview/services/authService.dart';

class RegularInspectionRowService extends AuthService {
  static Future<String> createRegularInspection(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/regular/row/create',
        method: 'POST',
        body: payload);
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      return responseMap['insertId'].toString();
    } else
      print("Not working!");
  }

  // ignore: missing_return
  static Future<RegularInspectionRow> getRegularInspectionRowById(
      var id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/regular/row/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<RegularInspectionRow> regularInspection = responseMap
          .map<RegularInspectionRow>((regularInspectionMap) =>
              RegularInspectionRow.fromJson(regularInspectionMap))
          .toList();
      return regularInspection.first;
    } else {
      print('Not Working!');
    }
  }
}
