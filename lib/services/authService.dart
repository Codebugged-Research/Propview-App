import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'baseService.dart';

class AuthService extends BaseService {
  static const BASE_URI = "https://api.propdial.co.in/";
  static Map<String, dynamic> _authDetails;
  static const String authNamespace = "auth";

  // ignore: missing_return
  static Future<http.Response> makeAuthenticatedRequest(String url,
      {String method = 'POST',
      body,
      mergeDefaultHeader = true,
      Map<String, String> extraHeaders}) async {
    try {
      Map<String, dynamic> auth = await getSavedAuth();
      extraHeaders ??= {};
      var sentHeaders = mergeDefaultHeader
          ? {
              ...BaseService.headers,
              ...extraHeaders,
              "Authorization": "Bearer ${auth['token']}"
            }
          : extraHeaders;

      switch (method) {
        case 'POST':
          body ??= {};
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);
          break;

        case 'GET':
          return http.get(Uri.parse(url), headers: sentHeaders);
          break;

        case 'PUT':
          return http.put(Uri.parse(url), headers: sentHeaders, body: body);
          break;

        case 'DELETE':
          return http.delete(Uri.parse(url), headers: sentHeaders);
        default:
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);
      }
    } catch (err) {
      print(err);
    }
  }

  static Future<Map<String, dynamic>> getSavedAuth() async {
    if (AuthService._authDetails != null) {
      return _authDetails;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> auth = prefs.getString(authNamespace) != null
        ? json.decode(prefs.getString(authNamespace))
        : null;

    AuthService._authDetails = auth;
    return auth;
  }

  static Future<bool> authenticate(String email, String password) async {
    var payload = json.encode({
      'email': email,
      'password': password,
    });
    http.Response response = await BaseService.makeUnauthenticatedRequest(
        BaseService.BASE_URI + 'api/signin',
        body: payload);
    Map<String, dynamic> responseMap = json.decode(response.body);
    if (response.statusCode == 200 && responseMap['user']['status'] == 1) {
      String token = responseMap['token'];
      String id = responseMap['user']['user_id'].toString();
      String role = responseMap['user']['user_type'].toString();
      await _saveToken(token, email, id, role);
      return true;
    } else {
      return false;
    }
  }

  static _saveToken(String token, String email, String id, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(authNamespace,
        json.encode({"token": token, "email": email, "id": id, "role": role}));
  }

  static clearAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _authDetails = null;
  }
}
