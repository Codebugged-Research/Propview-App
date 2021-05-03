
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'baseService.dart';

class AuthService extends BaseService {
  static const BASE_URI = "http://68.183.247.233/";
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

  static Future<bool> authenticate(String displayName, String email,
      String password, String photoUrl) async {
    var payload = json
        .encode({'name': displayName, 'email': email, 'password': password, 'photoUrl': photoUrl});
    print('$payload');
    http.Response response = await BaseService.makeUnauthenticatedRequest(
        BaseService.BASE_URI + 'api/signin',
        body: payload);

    Map<String, dynamic> responseMap = json.decode(response.body);

    String token = responseMap['token'];
    String id = responseMap['User']['user_id'].toString();
    bool success = token != null;
    if (success) _saveToken(token, email, id);
    return success;
  }

  static _saveToken(String token, String email, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        authNamespace,
        json.encode({
          "token": token,
          "email": email,
          "id": id,
        }));
  }

  static clearAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _authDetails = null;
  }
}