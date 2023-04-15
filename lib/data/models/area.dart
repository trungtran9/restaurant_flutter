import 'package:flutter/foundation.dart';
import 'package:flutter_login/data/classes/area.dart';
// import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//import '../classes/table.dart';
import '../../constants.dart';

class AreaModel extends ChangeNotifier {
  List<Area> _areaList = [];
  List<Area>  get areaList{
      if(_areaList != null){
        return List.from(_areaList);
      }
      else{
        return [];
      }
  }
  
  // A function that converts a response body into a List<Photo>.
  
  Future fetchAreas({int? status = 0}) async {
    var companyId = 0;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
      var userData = _prefs.getString("user_data") ?? "";
			if(userData != ""){
				Map<String, dynamic> data = jsonDecode(userData);
				companyId = (data['companyId']);
			}
     var response = await http.get(Uri.parse(apiURLV2 + '/table/area?company_id=$companyId'));
     if(status != 0)
      response = await http.get(Uri.parse(apiURLV2 + '/table/area?company_id=$companyId&status=$status'));
     //await Future.delayed(Duration(seconds: 2));
      Iterable list = json.decode(response.body);
      // Use the compute function to run parseTables in a separate isolate.
     // _areaList  = list.map<Area>((json) => Area.fromJson(json)).toList();
      _areaList = list.map((model) => Area.fromJson(model)).toList();
     
      notifyListeners();
      return _areaList;
  }
}