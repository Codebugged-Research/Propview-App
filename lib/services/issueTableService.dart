import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Issue.dart';
import 'package:propview/services/authService.dart';

class IssueTableService extends AuthService {
  static Future<String> createIssueTable(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/issue/table/create',
        method: 'POST',
        body: payload);
    var responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseMap["data"]["insertId"].toString();
    } else {
      return "0";
    }
  }

  static Future<Issue> getIssueTableById(var issueId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'api/issue/table/get/$issueId',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      Issue issue = responseMap["data"];
      return issue;
    } else {
      print("Not working!");
    }
  }

  static Future<bool> updateIssueTable(var issueId, var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/issue/table/update/$issueId',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteIssueTable(var issueId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/issue/table/delete/$issueId',
        method: 'DELETE');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
