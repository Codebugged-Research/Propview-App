import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/TenantFamily.dart';
import 'package:propview/services/authService.dart';

class TenantFamilyService extends AuthService {
  static Future<bool> createTenantFamily(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/tenant/family/create',
        method: 'POST',
        body: payload);

    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<List<TenantFamily>> getTenantFamily(var tenantId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/tenant/family/get/$tenantId',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<TenantFamily> tenantFamily = responseMap
          .map<TenantFamily>(
              (tenantFamilyMap) => TenantFamily.fromJson(tenantFamilyMap))
          .toList();
      return tenantFamily;
    } else {
      print("Not Working!");
    }
  }

  static Future<bool> updateTenantFamily(var payload, var familyId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/tenant/family/update/$familyId',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }
}
