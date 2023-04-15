import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_login/data/classes/print.dart';
import 'package:flutter_login/data/classes/product.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class PrintModel extends ChangeNotifier {
  List<Product> _productList = [];

  List<Print> _productListPrint = [];

  List<Product> get productListOrder {
    if (_productList != null) {
      return List.from(_productList);
    } else {
      return [];
    }
  }

  List<Print> get productListPrint {
    if (_productListPrint != null) {
      return List.from(_productListPrint);
    } else {
      return [];
    }
  }

  // complete order
  Future printOrder(num tableId, num history) async {
    //final response = await http.get(apiURLV2 + '/order/removeTempProduct');
    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/notify/notifyKitchen'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{'table_id': tableId, 'history': history}),
    );
    notifyListeners();
    return true;
  }
}
