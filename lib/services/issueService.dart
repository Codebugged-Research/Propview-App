import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:propview/models/Issue.dart';
import 'package:propview/services/authService.dart';

class IssueService extends AuthService {
  static Future<String> createIssue(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/issue/create',
        method: 'POST',
        body: payload);
    var responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseMap["data"]["insertId"].toString();
    } else {
      return "0";
    }
  }

  static Future<List<Issue>> getAllIssue() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/issue/get',
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
      AuthService.BASE_URI + 'api/issue/get/$issueId',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<Issue> issue = responseMap["data"]
          .map<Issue>((issueMap) => Issue.fromJson(issueMap))
          .toList();
      return issue.first;
    } else {
      print("Not working!");
    }
  }

  static Future<bool> updateIssue(var issueId, var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/issue/update/$issueId',
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
        AuthService.BASE_URI + 'api/issue/delete/$issueId',
        method: 'DELETE');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
