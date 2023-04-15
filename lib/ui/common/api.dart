import 'package:flutter/foundation.dart';
import 'package:flutter_login/data/classes/table.dart' as tb;
import 'package:local_auth/local_auth.dart';
// import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../../constants.dart';


class AppAPI extends ChangeNotifier {
  //static int companyId;
  List<tb.Table> _tableList = [];
  List<tb.Table>  get tableList{
      if(_tableList != null){
        return List.from(_tableList);
      }
      else{
        return [];
      }
  }
  static String capitalize(String text) {
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }
  static Future getCompanyOfUser() async{
    var companyId = 0;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userData = _prefs.getString("user_data") ?? "";
			if(userData != ""){
				final data = jsonDecode(userData);
				companyId = (data['companyId']);
			}
		return companyId;
  }
  
  static dynamic saveDataShare(String key, dynamic value) async{
    SharedPreferences.getInstance().then((prefs) {
     List<String> checkData = prefs.getStringList(key)?? [];
      checkData.add(value);
      prefs.setStringList(key, checkData);
      return checkData;
    });
  }
  
  static dynamic getDataShare(String key) async{
    SharedPreferences.getInstance().then((prefs) {
    //  List returnData = prefs.getStringList(key);
    //   return returnData;
      print(prefs.getStringList(key));
      return prefs.getStringList(key)?? [];
    });
  }

  
  
  Future getAllTablesByArea(num areaId) async {
  var companyId = 0;
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var userData = _prefs.getString("user_data") ?? "";
			if(userData != ""){
				final data = jsonDecode(userData);
				companyId = (data['companyId']);
			}
  var response = await http.get(Uri.parse(apiURLV2 + '/table/?company_id=$companyId'));
    if(areaId != 0)
      response = await http.get(Uri.parse(apiURLV2 + '/table/?company_id=$companyId&area_id=$areaId'));
    Iterable list = json.decode(response.body);
    _tableList = list.map((model) => tb.Table.fromJson(model)).toList();
    await Future.delayed(Duration(seconds: 1));
    print(_tableList);
    notifyListeners();
    return _tableList;
  }
}