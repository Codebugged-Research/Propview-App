import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static Future<String> genTokenID() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String id = await messaging.getToken();
    pref.setString("deviceToken", id);
    print(id);
    //TODO: update user device token upon login
    // UserService.updateUser(jsonEncode({"deviceToken": id}));
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
        "data": {"name": "sambit"}
      },
    );
    http.Response response = await http.post(
        Uri.parse("http://68.183.247.233/api/notification/one"),
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
        Uri.parse("http://68.183.247.233/api/notification/one"),
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
