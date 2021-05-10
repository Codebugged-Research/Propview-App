import 'package:http/http.dart' as http;

class BaseService {
  static const BASE_URI = "http://68.183.247.233/";

  static final Map<String, String> headers = {
    "Content-Type": "application/json"
  };

  // ignore: missing_return
  static Future<http.Response> makeUnauthenticatedRequest(String url,
      {String method = 'POST',
        body,
        mergeDefaultHeader = true,
        Map<String, String> extraHeaders}) async {
    try {
      extraHeaders ??= {};
      var sentHeaders =
      mergeDefaultHeader ? {...headers, ...extraHeaders} : extraHeaders;

      switch (method) {
        case 'POST':
          body ??= {};
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);
          break;

        case 'GET':
          return http.get(Uri.parse(url), headers: headers);
          break;

        case 'PUT':
          return http.put(Uri.parse(url), headers: sentHeaders, body: body);
          break;

        case 'DELETE':
          return http.delete(Uri.parse(url), headers: sentHeaders);

        default:
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);
      }
    } catch (err) {
      print(err);
    }
  }
}