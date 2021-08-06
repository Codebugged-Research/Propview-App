import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/BillType.dart';
import 'package:propview/services/authService.dart';

class BillTypeService extends AuthService {
  // ignore: missing_return
  static Future<List<BillType>> getAllBillTypes() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/bill/types/',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<BillType> billTypes = responseMap
          .map<BillType>((billTypeMap) => BillType.fromJson(billTypeMap))
          .toList();
      return billTypes;
    } else {
      print("Not working!");
    }
  }

  // ignore: missing_return
  static Future<BillType> getBillTypeById(String id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/bill/types/$id',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      BillType billType = BillType.fromJson(responseMap);
      return billType;
    } else {
      print("Not working!");
    }
  }
}
