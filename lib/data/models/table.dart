import 'package:flutter/foundation.dart';
import 'package:flutter_login/data/classes/product.dart';
import 'package:flutter_login/data/classes/table.dart' as tb;
import 'package:local_auth/local_auth.dart';
// import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//import '../classes/table.dart';
import '../../constants.dart';

class TableModel extends ChangeNotifier {
  List<tb.Table> _tableList = [];
  List<tb.Table> get tableList {
    if (_tableList != null) {
      return List.from(_tableList);
    } else {
      return [];
    }
  }

  // A function that converts a response body into a List<Photo>.

  Future fetchTables() async {
    var companyId = 0;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userData = _prefs.getString("user_data") ?? "";
    if (userData != "") {
      Map<String, dynamic> data = jsonDecode(userData);
      companyId = (data['companyId']);
    }
    final response =
        await http.get(Uri.parse(apiURLV2 + '/table/?company_id=$companyId'));

    Iterable list = json.decode(response.body);
    // Use the compute function to run parseTables in a separate isolate.
    // _tableList  = list.map<tb.Table>((json) => tb.Table.fromJson(json)).toList();
    _tableList = list.map((model) => tb.Table.fromJson(model)).toList();
    notifyListeners();
    return _tableList;
  }

  Future moveTable(num fromTableId, num toTableId) async {
    //final response = await http.get(apiURLV2 + '/order/removeTempProduct');
    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/table/moveTable'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'from_table_id': fromTableId,
        'to_table_id': toTableId,
      }),
    );
    notifyListeners();
    return true;
  }
}
