import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static Future<String> genTokenID() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String id = await messaging.getToken();
    print(id);
    pref.setString("deviceToken", id);
    return id;
  }

  static Future<bool> sendPushToOne(
      String title, String message, deviceToken) async {
    final Map<String, String> headers = {"Content-Type": "application/json"};
    var body = jsonEncode(
      {
        "title": title,
        "message": message,
        "deviceToken": deviceToken,
      },
    );
    http.Response response = await http.post(
        Uri.parse("https://api.propdial.co.in/api/notification/one"),
        headers: headers,
        body: body);
    // print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> sendPushToOneWithTime(String title, String message,
      deviceToken, String startTime, String endTime) async {
    final Map<String, String> headers = {"Content-Type": "application/json"};
    var body = jsonEncode(
      {
        "title": title,
        "message": message,
        "deviceToken": deviceToken,
        "data": {"startTime": startTime, "endTime": endTime}
      },
    );
    http.Response response = await http.post(
        Uri.parse("https://api.propdial.co.in/api/notification/one"),
        headers: headers,
        body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> sendPushToSelf(String title, String message) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var deviceToken = pref.getString("deviceToken");
    final Map<String, String> headers = {"Content-Type": "application/json"};
    var body = jsonEncode(
      {
        "title": title,
        "message": message,
        "deviceToken": deviceToken,
        "data": {
          "startTime": DateTime.now().toString(),
          "endTime": DateTime.now().add(Duration(seconds: 10)).toString()
        }
      },
    );
    http.Response response = await http.post(
        Uri.parse("https://api.propdial.co.in/notification/one"),
        headers: headers,
        body: body);
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }
}
