import 'package:flutter/foundation.dart';
import '../classes/product.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//import '../classes/Product.dart';
import '../../constants.dart';

class TableDetailModel extends ChangeNotifier {
  List<Product> _productList = [];
  List _productOrdertemp = [];
  num _totals = 0;
  num _status = 0;
  String _tableName = '';
  String _areaName = '';
  List<Product> get productList {
    if (_productList.length > 0) {
      return List.from(_productList);
    } else {
      return [];
    }
  }

  dynamic get productOrderList {
    if (_productOrdertemp.length > 0) {
      return List.from(_productOrdertemp);
    } else {
      return [];
    }
  }

  num get tableStatus {
    return _status;
  }

  String get tableNameStatus {
    if (_status == 1)
      return 'Đang dùng';
    else if (_status == 2) return 'Bàn đặt';
    return 'Bàn trống';
  }

  String get getTableName {
    return _tableName;
  }

  String get getAreaName {
    return _areaName;
  }

  num get totalCart {
    return _totals;
  }

  Future fetchProductsByTable(num tableId) async {
    
    final response =
        await http.get(Uri.parse(apiURLV2 + '/table/tableByID?id=$tableId'));
    //await Future.delayed(Duration(seconds: 2));
    Iterable list = json.decode(response.body)['results'];
    // Use the compute function to run parseProducts in a separate isolate.
    // _ProductList  = list.map<tb.Product>((json) => tb.Product.fromJson(json)).toList();
    //print(json.decode(response.body)['results']);
    _status = json.decode(response.body)['table_status'];
    _tableName = json.decode(response.body)['table_name'];
    _areaName = json.decode(response.body)['area_name'];
    _productList = list.map((model) => Product.fromJson(model)).toList();

    notifyListeners();
    return _productList;
  }

  Future removeProduct(num tableId, num productId) async {
    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/order/removeMenu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
        'product_id': productId,
      }),
    );
   
    _productList.removeWhere((item) => item.id == productId);
    notifyListeners();
    return true;
  }

  Future getOrderTempByTableId(num tableId) async {
    final response = await http.get(Uri.parse(
        apiURLV2 + '/product/allTempProductsBytableId?tableId=$tableId'));
    //await Future.delayed(Duration(seconds: 2));
    
    _productOrdertemp = json.decode(response.body);
    notifyListeners();
    return _productOrdertemp;
  }

  // Remove temp order
  Future removeTempOrder(num tableId) async {
    //await Future.delayed(Duration(seconds: 2));
    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/order/removeAllTempProducts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
      }),
    );
   
    _productOrdertemp = [];
    notifyListeners();
    return true;
  }

  Future updateTable(
      num tableId, num productId, int qty, num price, String note) async {
    _productOrdertemp.add(productId);

    var companyId = 1;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userData = _prefs.getString("user_data") ?? "";
    if (userData != "") {
      Map<String, dynamic> data = jsonDecode(userData);
      companyId = (data['companyId']);
    }

    //await Future.delayed(Duration(seconds: 3));
    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/order/updateMenuV2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
        'product_id': productId,
        'qty': qty,
        'price': price,
        'note': note,
        'company_id': companyId
      }),
    );

    
    _productList[
        _productList.indexWhere((element) => element.id == productId)].qty = qty;
    _productList[
        _productList.indexWhere((element) => element.id == productId)].note = note;
    //_totals += qty;
    notifyListeners();
    return true;
  }

  Future addItem(num tableId, num productId, num qty, num price) async {
    _productOrdertemp.add(productId);

    var companyId = 1;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userData = _prefs.getString("user_data") ?? "";
    if (userData != "") {
      Map<String, dynamic> data = jsonDecode(userData);
      companyId = (data['companyId']);
    }
    var note = '';
     print("tableId:"  + tableId.toString());
    print("productId" + productId.toString());
    print("qty" + qty.toString());
    print("price" + price.toString());
    print("companyId" + companyId.toString());
    
    print(apiURLV2 + '/order/orderTempMenu');
    try {
      http.Response response = await http.post(
        Uri.parse(apiURLV2 + '/order/orderTempMenu'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'table_id': tableId,
          'product_id': productId,
          'qty': qty,
          'price': price,
          'note': note,
          'company_id': companyId
        }),
      );
      
    } catch (e) {
      print(e);
    }
    //await Future.delayed(Duration(seconds: 3));
    
    //print(json.decode(response.body));

   
    _totals += qty;
   
    notifyListeners();
    return true;
  }

  // count cart item
  Future getTotalCart(num tableId) async {
    final response = await http
        .get(Uri.parse(apiURLV2 + '/table/productTempOfTable?id=$tableId'));
    //await Future.delayed(Duration(seconds: 2));
    _totals = json.decode(response.body)['totals'];
    notifyListeners();
  }

  // Book table
  Future bookTable(num tableId) async {
    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/table/bookTable'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
      }),
    );
    //_productOrdertemp = [];
    notifyListeners();
    return true;
  }

  Future removeBookTable(num tableId) async {
    http.Response response = await http.post(
      Uri.parse(apiURLV2 + '/table/removeBookTable'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
      }),
    );
    //_productOrdertemp = [];
    notifyListeners();
    return true;
  }
}
