import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:propview/models/User.dart';

import 'authService.dart';

class UserService extends AuthService {
  // ignore: missing_return
  static Future<User> getUser() async {
    var auth = await AuthService.getSavedAuth();
    var cacheData = APICacheManager();
    bool doesExist = await cacheData.isAPICacheKeyExist("getUser");
    if (doesExist) {
      APICacheDBModel responseBody = await cacheData.getCacheData("getUser");
      DateTime lastCache =
          DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 30) {
        cacheData.deleteCache("getUser");
        http.Response response = await AuthService.makeAuthenticatedRequest(
            AuthService.BASE_URI + 'api/user/${auth['id']}',
            method: 'GET');
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getUser",
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          User user = User.fromJson(responseMap);
          return user;
        } else {
          print("DEBUG");
        }
      } else {
        var responseMap = json.decode(responseBody.syncData);
        User user = User.fromJson(responseMap);
        return user;
      }
    } else {
      http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/user/${auth['id']}',
          method: 'GET');
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getUser",
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        User user = User.fromJson(responseMap);
        return user;
      } else {
        print("DEBUG");
      }
    }
  }

  // ignore: missing_return
  static Future<User> getUserById(id) async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/user/$id}',
        method: 'GET');
    if (response.statusCode == 200) {
      User user = User.fromJson(json.decode(response.body));
      return user;
    } else {
      print("DEBUG");
    }
  }

  // ignore: missing_return
  static Future<List<User>> getAllUser() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/users',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<User> users =
          responseMap.map<User>((usersMap) => User.fromJson(usersMap)).toList();
      return users;
    } else {
      print("DEBUG");
    }
    // var cacheData = APICacheManager();
    // bool doesExist = await cacheData.isAPICacheKeyExist("getAllUser");
    // if (doesExist) {
    //   APICacheDBModel responseBody = await cacheData.getCacheData("getAllUser");
    //   DateTime lastCache =
    //       DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
    //   if (DateTime.now().difference(lastCache).inSeconds > 1) {
    //     cacheData.deleteCache("getAllUser");
    //     http.Response response = await AuthService.makeAuthenticatedRequest(
    //         AuthService.BASE_URI + 'api/users',
    //         method: 'GET');
    //     if (response.statusCode == 200) {
    //       cacheData.addCacheData(
    //         APICacheDBModel(
    //           key: "getAllUser",
    //           syncData: response.body,
    //           syncTime: DateTime.now().millisecondsSinceEpoch,
    //         ),
    //       );
    //       var responseMap = json.decode(response.body);
    //       List<User> users = responseMap
    //           .map<User>((usersMap) => User.fromJson(usersMap))
    //           .toList();
    //       return users;
    //     } else {
    //       print("DEBUG");
    //     }
    //   } else {
    //     var responseMap = json.decode(responseBody.syncData);
    //     List<User> users = responseMap
    //         .map<User>((usersMap) => User.fromJson(usersMap))
    //         .toList();
    //     return users;
    //   }
    // } else {
    //   http.Response response = await AuthService.makeAuthenticatedRequest(
    //       AuthService.BASE_URI + 'api/users',
    //       method: 'GET');
    //   if (response.statusCode == 200) {
    //     cacheData.addCacheData(
    //       APICacheDBModel(
    //         key: "getAllUser",
    //         syncData: response.body,
    //         syncTime: DateTime.now().millisecondsSinceEpoch,
    //       ),
    //     );
    //     var responseMap = json.decode(response.body);
    //     List<User> users = responseMap
    //         .map<User>((usersMap) => User.fromJson(usersMap))
    //         .toList();
    //     return users;
    //   } else {
    //     print("DEBUG");
    //   }
    // }
  }

  // ignore: missing_return
  static Future<List<User>> getAllUserUnderManger(id) async {
    var cacheData = APICacheManager();
    bool doesExist = await cacheData
        .isAPICacheKeyExist("getAllUserUnderManger" + id.toString());
    if (doesExist) {
      APICacheDBModel responseBody =
          await cacheData.getCacheData("getAllUserUnderManger" + id.toString());
      DateTime lastCache =
          DateTime.fromMillisecondsSinceEpoch(responseBody.syncTime);
      if (DateTime.now().difference(lastCache).inDays > 7) {
        cacheData.deleteCache("getAllUserUnderManger" + id.toString());
        http.Response response = await AuthService.makeAuthenticatedRequest(
          AuthService.BASE_URI + 'api/user/manager/',
          method: 'POST',
          body: jsonEncode(
            {
              "id1": "$id",
              "id2": "%,$id",
              "id3": "%,$id,%",
              "id4": "$id,%",
            },
          ),
        );
        if (response.statusCode == 200) {
          cacheData.addCacheData(
            APICacheDBModel(
              key: "getAllUserUnderManger" + id.toString(),
              syncData: response.body,
              syncTime: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          var responseMap = json.decode(response.body);
          List<User> users = responseMap
              .map<User>((usersMap) => User.fromJson(usersMap))
              .toList();
          return users;
        } else {
          print("DEBUG");
        }
      } else {
        var responseMap = json.decode(responseBody.syncData);
        List<User> users = responseMap
            .map<User>((usersMap) => User.fromJson(usersMap))
            .toList();
        return users;
      }
    } else {
      http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/user/manager/',
        method: 'POST',
        body: jsonEncode(
          {
            "id1": "$id",
            "id2": "%,$id",
            "id3": "%,$id,%",
            "id4": "$id,%",
          },
        ),
      );
      if (response.statusCode == 200) {
        cacheData.addCacheData(
          APICacheDBModel(
            key: "getAllUserUnderManger" + id.toString(),
            syncData: response.body,
            syncTime: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        var responseMap = json.decode(response.body);
        List<User> users = responseMap
            .map<User>((usersMap) => User.fromJson(usersMap))
            .toList();
        return users;
      } else {
        print("DEBUG");
      }
    }
  }

  static Future<bool> updateUser(var payload) async {
    var auth = await AuthService.getSavedAuth();
    print(auth["id"]);
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/user/update/${auth['id']}',
        method: 'PUT',
        body: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Debug update user");
      return false;
    }
  }

  static Future<String> getDeviceToken(String id) async {
    final Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.get(
      Uri.parse("https://api.propdial.co.in/api/user/deviceToken/$id"),
      headers: headers,
    );
    if (response.statusCode == 200 && response.body != null) {
      var decodedMsg = json.decode(response.body);
      return decodedMsg["device_token"];
    } else {
      return "";
    }
  }
}
