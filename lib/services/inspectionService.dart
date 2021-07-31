import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/Inspection.dart';
import 'package:propview/services/authService.dart';

class InspectionService extends AuthService {
  static Future<bool> createInspection(var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/create',
        method: 'POST',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> getAllInspection() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/get',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<Inspection> inspection = responseMap["data"]["inspection"]
          .map<Inspection>(
              (inspectionMap) => Inspection.fromJson(inspectionMap))
          .toList();
      return inspection;
    } else {
      print("Failed!");
    }
  }

  static Future<void> getInspectionById(String inspectionId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/get/$inspectionId',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<Inspection> inspection = responseMap["data"]["inspection"]
          .map<Inspection>(
              (inspectionMap) => Inspection.fromJson(inspectionMap))
          .toList();
      return inspection;
    } else {
      print("Failed!");
    }
  }

  static Future<void> getInspectionByPropertyId(String propertyId) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/get/property/$propertyId',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<Inspection> inspection = responseMap["data"]["inspection"]
          .map<Inspection>(
              (inspectionMap) => Inspection.fromJson(inspectionMap))
          .toList();
      return inspection;
    } else {
      print("Failed!");
    }
  }

  static Future<bool> updateInspection(String inspectionId, var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/update/$inspectionId',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteInspection(String inspectionId, var payload) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/inspection/delete/$inspectionId',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
