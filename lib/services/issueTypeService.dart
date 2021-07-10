import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/IssueType.dart';
import 'package:propview/services/authService.dart';

class IssueTypeService extends AuthService {
  static Future<bool> createIssueTable(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'issue/table/create',
        method: 'POST',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<IssueType>> getIssueTypeByPropertyId(
      String propertyId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
      AuthService.BASE_URI + 'issue/type/$propertyId',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<IssueType> issueType = responseMap["data"]
          .map<IssueType>((issueTypeMap) => IssueType.fromJson(issueTypeMap))
          .toList();
      return issueType;
    } else {
      print("Not Working!");
    }
  }

  static Future<bool> updateIssueType(var issueTypeId, var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + '/issue/table/update/$issueTypeId',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteIssueType(var issueTypeId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + '/issue/table/delete/$issueTypeId',
        method: 'DELETE');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
