import 'package:flutter/material.dart';
import 'package:flutter_login/data/models/auth.dart';
import 'package:flutter_login/data/models/print.dart';
import 'package:flutter_login/data/models/product.dart';
import 'package:flutter_login/data/models/table.dart';
import 'package:flutter_login/data/models/table_detail.dart';
import 'package:flutter_login/ui/common/api.dart';
import 'package:flutter_login/ui/lockedscreen/table/table.dart';
import 'package:flutter_login/ui/lockedscreen/table/active_table.dart';
import 'package:flutter_login/ui/lockedscreen/table/empty_table.dart';
import 'package:flutter_login/ui/lockedscreen/table/reserved_table.dart';
// import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';

import 'data/models/area.dart';
import 'data/models/category.dart';
import 'data/models/confirm_order.dart';
import 'ui/lockedscreen/home.dart';
import 'ui/signin/newaccount.dart';
import 'ui/signin/signin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final ThemeModel _model = ThemeModel();
  final AuthModel _auth = AuthModel();
  final TableModel _tbl = TableModel();
  final AreaModel _area = AreaModel();
  final CategoryModel _categories = CategoryModel();
  final AppAPI _allTable = AppAPI();
  final TableDetailModel _tblDetail = TableDetailModel();
  final ConfirmOrderModel _confirmProduct = ConfirmOrderModel();
  //final DashboardModel _dashboard = DashboardModel();
  final ProductModel _product = ProductModel();
  final PrintModel _print = PrintModel();
  @override
  void initState() {
    try {
      _auth.loadSettings();
    } catch (e) {
      print("Error Loading Settings: $e");
    }
    try {
      // _model.init();
    } catch (e) {
      print("Error Loading Theme: $e");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider<ThemeModel>.value(value: _model),
        ChangeNotifierProvider<AuthModel>.value(value: _auth),
        //ChangeNotifierProvider<DashboardModel>.value(value: _dashboard),
        ChangeNotifierProvider<TableModel>.value(value: _tbl),
        ChangeNotifierProvider<AreaModel>.value(value: _area),
        ChangeNotifierProvider<CategoryModel>.value(value: _categories),
        ChangeNotifierProvider<AppAPI>.value(value: _allTable),
        ChangeNotifierProvider<TableDetailModel>.value(value: _tblDetail),
        ChangeNotifierProvider<ProductModel>.value(value: _product),
        ChangeNotifierProvider<ConfirmOrderModel>.value(value: _confirmProduct),
        ChangeNotifierProvider<PrintModel>.value(value: _print),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: model.theme,
        // home: Consumer<AuthModel>(builder: (context, model, child) {
        //   if (model?.user != null) {
        //     return Home();
        //   }
        //   return LoginPage();
        // }),
        home: LoginPage(),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          "/login": (BuildContext context) => LoginPage(),
          // "/menu": (BuildContext context) => Home(),
          "/home": (BuildContext context) => Home(),
          //"/settings": (BuildContext context) => SettingsPage(),
          "/create": (BuildContext context) => CreateAccount(),
          "/table": (BuildContext context) => TablePage(),
          "/active-table": (BuildContext context) => ActiveTablePage(),
          "/empty-table": (BuildContext context) => EmptyTablePage(),
          "/reserved-table": (BuildContext context) => ReservedTablePage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          return null;

          // final List<String> pathElements = settings.name!.split('/') ?? [];
          //   if (pathElements.length != 0 && pathElements[0] != '') {
          //     return null;
          //   }
          //   if(pathElements[1].contains('table-detail')){
          //     var id = num.parse(pathElements[2]);
          //     return MaterialPageRoute<bool>(builder:(BuildContext context)=> TableDetailPage(id:id,));
          //   }
          //   if(pathElements[1].contains('product')){
          //     var id = num.parse(pathElements[2]);
          //     return MaterialPageRoute<bool>(builder:(BuildContext context)=> ProductDetailPage(product:id,));
          //   }
        },
      ),
    );
  }
}
