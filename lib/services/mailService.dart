import 'package:propview/services/authService.dart';
import 'package:http/http.dart' as http;

class MailService extends AuthService {
  static Future<bool> sendMail(var payload) async {
    print(payload);
    http.Response response = await AuthService.makeAuthenticatedRequest(
        AuthService.BASE_URI + 'api/mail/send/',
        method: 'POST',
        body: payload);
    if (response.statusCode == 200) {
      print("success");
      return true;
    } else {
      print("failure");
      return false;
    }
  }
}
