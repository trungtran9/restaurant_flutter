import 'dart:convert';
import 'package:flutter_login/data/classes/dashboard.dart';
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class DashboardAPI {
  static Future getTables(num companyId) async {
    final String url = apiURLV2 + '/dashboard?company_id=$companyId';
    var data = await http.get(Uri.parse(url));
    print(url);
    //Response response = await get(url);
    print(data);
    return data;
    // String url = 'https://jsonplaceholder.typicode.com/users';
    // Response response = await get(url);
    // int statusCode = response.statusCode;
    // Map<String, String> headers = response.headers;
    // String contentType = headers['content-type'];
    // return response;
    // final client = new http.Client();
    // final streamedRest = await client.send(
    //     http.Request('get', Uri.parse(url))
    // );

    // return streamedRest.stream
    //     .transform(utf8.decoder)
    //     .transform(json.decoder)
    //     .expand((data) => (data as List))
    //     .map((data) => Dashboard.fromJson(data));
  }
}
