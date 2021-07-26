import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Tenant.dart';
import 'package:propview/services/authService.dart';

class TenantService extends AuthService {
  static Future<bool> createTenant(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        'api/tenant/create',
        method: 'POST',
        body: payload);

    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<Tenant> getTenant(var tenantId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        'api/tenant/$tenantId',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Tenant tenant = Tenant.fromJson(responseMap);
      return tenant;
    } else {
      print("Not Working!");
    }
  }

  static Future<bool> updateTenant(var payload, var tenantId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        'api/tenant/update/$tenantId',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }
}
