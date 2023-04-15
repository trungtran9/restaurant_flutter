import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../classes/print.dart';
import '../classes/product.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class ConfirmOrderModel extends ChangeNotifier {
  List<Product> _productList = [];
  num notifyTime = 0;
  List<Print> _productListPrint = [];
  String _areaName = '';
  List<Product> _productIncludePrint = [];
  List<Product> get productListOrder {
    if (_productList != null) {
      return List.from(_productList);
    } else {
      return [];
    }
  }

  num get getNotify {
    return notifyTime;
  }

  String get getAreaName {
    return _areaName;
  }

  List<Print> get productListPrint {
    if (_productListPrint != null)
      return List.from(_productListPrint);
    else
      return [];
  }

  List<Product> get productIncludePrint {
    if (_productIncludePrint != null)
      return (_productIncludePrint);
    else
      return [];
  }

  Future fetchOrderByTable(num tableId) async {
    final response =
        await http.get(Uri.parse(apiURLV2 + '/table/productTempOfTable?id=$tableId'));
    //await Future.delayed(Duration(seconds: 2));
    Iterable list = json.decode(response.body)['results'];

    print(json.decode(response.body)['results']);
    _productList = list.map((model) => Product.fromJson(model)).toList();
    //print(_productList);

    notifyListeners();
    return _productList;
  }

  Future removeTempProduct(num tableId, num productId) async {
    //final response = await http.get(apiURLV2 + '/order/removeTempProduct');
    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/order/removeTempProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{'table_id': tableId, 'product_id': productId}),
    );
    //await Future.delayed(Duration(seconds: 2));
    _productList.removeWhere((item) => item.id == productId);
    notifyListeners();
    return true;
  }

  // complete order
  Future confirmOrder(num tableId) async {
    //final response = await http.get(apiURLV2 + '/order/removeTempProduct');
    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/order/confirmOrder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
      }),
    );
    notifyListeners();
    return true;
  }

  // Print order here
  Future fetchPrintByTable(num tableId) async {
    final response =
        await http.get(Uri.parse(apiURLV2 + '/notify/productInTable?tableID=$tableId'));
    Iterable list = json.decode(response.body)['results'];
    print(Uri.parse(apiURLV2 + '/notify/productInTable?tableID=$tableId'));
    // _productIncludePrint = json.decode(response.body)['print__product_final'];
    // //print(json.decode(response.body)['results']);
    // _areaName = json.decode(response.body)['area_name'];
    // _productListPrint = list.map((model) => Print.fromJson(model)).toList();
    // print(_productList);
    // notifyTime = json.decode(response.body)['notify_times'];
    // notifyListeners();
    // return _productListPrint;
    return [];
  }

  // remove product when print
  Future removeProductPrint(num tableId, num productId, num qty,
      {num? printCount}) async {
    num printHistory = printCount != null ? printCount : 0;

    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/notify/deleteProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
        'product_id': productId,
        'qty': qty,
        'print_count': printHistory
      }),
    );
    Print on = _productListPrint.firstWhere((item) => item.id == productId);
    on.status = 2;
    notifyListeners();
    print(printHistory);
    return true;
  }
}
