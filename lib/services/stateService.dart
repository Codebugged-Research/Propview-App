import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:propview/models/State.dart';
import 'package:propview/services/authService.dart';

class StateService extends AuthService {
  // ignore: missing_return
  static Future<List<CStates>> getStates() async {
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/state/all/',
        method: 'GET');
    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      List<CStates> cstate = responseMap
          .map<CStates>((stateMap) => CStates.fromJson(stateMap))
          .toList();
      return cstate;
    } else {
      print('Not Working!');
    }
  }
}
