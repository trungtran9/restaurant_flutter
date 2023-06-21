import 'package:flutter/foundation.dart';
import '../classes/product.dart';
import 'api.dart';
import '../../ui/common/api.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//import '../classes/Product.dart';
import '../../constants.dart';

class ProductModel extends ChangeNotifier {
  List<Product> _productList = [];
  List<Product> get productList {
    if (_productList != null) {
      return List.from(_productList);
    } else {
      return [];
    }
  }

  late Product _productOb;
  Product get productObject => _productOb;

  // A function that converts a response body into a List<Product>.
  Future fetchProducts() async {
    var companyId = 1;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userData = _prefs.getString("user_data") ?? "";
    if (userData != "") {
      final data = jsonDecode(userData);
      companyId = (data['companyId']);
    }
    final response =
        await http.get(Uri.parse(apiURLV2 + '/product/allProducts?companyId=$companyId'));
    //await Future.delayed(Duration(seconds: 2));
    print(Uri.parse(apiURLV2 + '/product/allProducts?companyId=$companyId'));
    Iterable list = json.decode(response.body['data']);
    // Use the compute function to run parseProducts in a separate isolate.
    // _ProductList  = list.map<tb.Product>((json) => tb.Product.fromJson(json)).toList();
    _productList = list.map((model) => Product.fromJson(model)).toList();
    //print(_ProductList);
    notifyListeners();
    return _productList;
  }
  // Future fetchProductsByCategory(categoryId) async {
  //   var companyId = 1;
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   var userData = _prefs.getString("user_data") ?? "";
  //   if (userData != "") {
  //     final data = jsonDecode(userData);
  //     companyId = (data['companyId']);
  //   }
  //   final response =
  //       await http.get(Uri.parse(apiURLV2 + '/product/all_product_by_category?companyId=$companyId&catId=$categoryId'));
  //   //await Future.delayed(Duration(seconds: 2));
  //   Iterable list = json.decode(response.body);
  //   // Use the compute function to run parseProducts in a separate isolate.
  //   // _ProductList  = list.map<tb.Product>((json) => tb.Product.fromJson(json)).toList();
  //   _productList = list.map((model) => Product.fromJson(model)).toList();
  //   //print(_ProductList);
  //   //notifyListeners();
  //   return _productList;
  // }

  Future getProduct(num id) async {
    final response =
        await http.get(Uri.parse(apiURLV2 + '/product/productDetail?productId=$id'));
    // await Future.delayed(Duration(seconds: 12));
    final productMap = jsonDecode(response.body);
    _productOb = Product.fromJson(productMap);
    // print(productMap);
    notifyListeners();
    return _productOb;
  }

  // order product here
  Future<bool> orderProduct(
      num tableId, num productId, num qty, num price, String note) async {
    var companyId = 1;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userData = _prefs.getString("user_data") ?? "";
    if (userData != "") {
      final data = jsonDecode(userData);
      companyId = (data['companyId']);
    }
    note = note != null ? note : '';
    //await Future.delayed(Duration(seconds: 3));
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
    //print(json.decode(response.body));
    notifyListeners();
    return true;
  }
}
