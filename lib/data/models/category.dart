import 'package:flutter/foundation.dart';
import 'package:flutter_login/data/classes/category.dart' as cat;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//import '../classes/table.dart';
import '../../constants.dart';

class CategoryModel extends ChangeNotifier {
  List<cat.Category> _categoryList = [];
  List<cat.Category> get categoryList {
    if (_categoryList != null) {
      return List.from(_categoryList);
    } else {
      return [];
    }
  }

  Future fetchCategories({int? status = 0}) async {
    var companyId = 0;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userData = _prefs.getString("user_data") ?? "";
    if (userData != "") {
      Map<String, dynamic> data = jsonDecode(userData);
      companyId = (data['companyId']);
    }
    var response = await http.get(Uri.parse(
        apiURLV2 + '/product/category_product?companyId=$companyId'));
    Iterable list = json.decode(response.body);
    print('companyId');
    print(apiURLV2 + '/product/category_product?companyId=$companyId');
    // Use the compute function to run parseTables in a separate isolate.
    // _categoryList  = list.map<Category>((json) => Category.fromJson(json)).toList();
    _categoryList = list.map((model) => cat.Category.fromJson(model)).toList();
    print(
        '=======================================================_categoryList');
    print(_categoryList);
    notifyListeners();
    return _categoryList;
  }
}
