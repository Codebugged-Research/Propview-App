import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/InspectionType.dart';
import 'package:propview/services/authService.dart';

class InspectionTypeService extends AuthService {
  static Future<List<InspectionType>> getAllInspectionType() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'inspection/type/get',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<InspectionType> inspectionType = responseMap["data"]
          .map<InspectionType>(
              (inspectionTypeMap) => InspectionType.fromJson(inspectionTypeMap))
          .toList();
      return inspectionType;
    } else {
      print("Not working!");
    }
  }
}
