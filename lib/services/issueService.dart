import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Issue.dart';
import 'package:propview/services/authService.dart';

class IssueService extends AuthService {
  static Future<bool> createIssue(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'issue/create',
        method: 'POST',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Issue>> getAllIssue() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'issue/get',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<Issue> issue = responseMap["data"]
          .map<Issue>((issueMap) => Issue.fromJson(issueMap))
          .toList();
      return issue;
    } else {
      print("Not working!");
    }
  }

  static Future<Issue> getIssueById(var issueId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'issue/get/$issueId',
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

  static Future<bool> updateIssue(var issueId, var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'issue/update/$issueId',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteIssue(var issueId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'issue/delete/$issueId',
        method: 'DELETE');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
