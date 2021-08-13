import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/services/authService.dart';

class BillPropertyService extends AuthService {
  // ignore: missing_return
  static Future<List<BillToProperty>> getBillsByPropertyId(
      String propertyId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/bill/property/$propertyId',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<BillToProperty> billProperties = responseMap
          .map<BillToProperty>(
              (billPropertyMap) => BillToProperty.fromJson(billPropertyMap))
          .toList();
      return billProperties;
    } else {
      print("Not working!");
    }
  }

  static Future<bool> updateBillProperty(String billId, var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/bill/property/update/$billId',
        method: 'PUT',
        body: payload);
      print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
