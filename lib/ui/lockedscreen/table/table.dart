import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../data/classes/area.dart';
import '../../../data/classes/dashboard.dart';
import 'package:flutter_login/data/classes/table.dart' as tb;
import '../../../data/models/api.dart';
import '../../../data/models/area.dart';
import '../../../data/models/auth.dart';
import '../../../data/models/dashboard.dart';
import '../../../data/models/table.dart';
import '../../app/app_drawer.dart';
import '../../common/api.dart';
import '../../common/table_search.dart';
import 'table_view.dart';
import '../../widgets/custom_widget.dart';
import '../../widgets/dashboard_title.dart';
import '../../widgets/table_card.dart';
// import 'package:flutter_whatsnew/flutter_whatsnew.dart';
//import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../ui/layout/loading.dart';
import 'package:http/http.dart' as http;

class TablePage extends StatefulWidget {
  @override
  TablePage({Key? key, this.tableStatus = 0});
  final num tableStatus;
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  ScrollController _scrollController = ScrollController();
  List<Dashboard> _dashboard = <Dashboard>[];
  num companyId = 0;
  bool isLoading = true;
  num categories = 0;
  num pageId = 1;
  List<dynamic> dataList = [];
  List<dynamic> _dataList = [];
  @override
  Future<void> fetchData(companyId, categories, pageId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userData = _prefs.getString("user_data") ?? "";
    if (userData != "") {
      Map<String, dynamic> data = jsonDecode(userData);
      companyId = (data['companyId']);
    }
    if (categories != 0) {
      final response = await http.get(Uri.parse(apiURLV2 +
          '/table/tablesByArea?company_id=$companyId&page=$pageId&area_id=$categories'));
      Iterable list = json.decode(response.body)['data'];
      _dataList = list.map((model) => tb.Table.fromJson(model)).toList();
    } else {
      final response = await http.get(
          Uri.parse(apiURLV2 + '/table/?company_id=$companyId&page=$pageId'));
      Iterable list = json.decode(response.body);
      _dataList = list.map((model) => tb.Table.fromJson(model)).toList();
    }
    setState(() {
      print('data');
      dataList = _dataList;
    });
  }

  void initState() {
    super.initState();
    listenForTables();
    fetchData(companyId, categories, pageId);
    final _tbl = Provider.of<TableModel>(context, listen: false);
    _tbl.fetchTables();
    final _area = Provider.of<AreaModel>(context, listen: false);
    _area.fetchAreas();
    final _allTable = Provider.of<AppAPI>(context, listen: false);
    _allTable.getAllTablesByArea(0);
    _scrollController.addListener(_scrollListener);
  }

  void listenForTables() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var userData = _prefs.getString("user_data") ?? "";
      if (userData != "") {
        Map<String, dynamic> data = jsonDecode(userData);
        companyId = (data['companyId']);
      }
      DashboardAPI.getTables(companyId).then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          _dashboard = list.map((model) => Dashboard.fromJson(model)).toList();
        });
      });
    } catch (e) {
      print('e');
    }
  }

  void _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      List<tb.Table> _dataScroll = [];
      print('scroll bottom');
      // print(categories);
      pageId = pageId + 1;
      print('pageId $pageId');
      if (categories != 0) {
        final response = await http.get(Uri.parse(apiURLV2 +
            '/table/tablesByArea?company_id=$companyId&page=$pageId&area_id=$categories'));
        Iterable list = json.decode(response.body)['data'];
        _dataScroll = list.map((model) => tb.Table.fromJson(model)).toList();
      } else {
        final response = await http.get(
            Uri.parse(apiURLV2 + '/table/?company_id=$companyId&page=$pageId'));
        Iterable list = json.decode(response.body);
        _dataScroll = list.map((model) => tb.Table.fromJson(model)).toList();
      }
      setState(() {
        print('_dataScroll');
        dataList.addAll(_dataScroll);
      });
    }
  }

  void _handleTabTap(areaId) async {
    // _tbl.fetchTables1(areaId);
    // final _tbl = Provider.of<TableModel>(context, listen: false);
    // _tbl.fetchTables();
    categories = areaId;
    pageId = 1;
    if (categories != 0) {
      final response = await http.get(Uri.parse(apiURLV2 +
          '/table/tablesByArea?company_id=$companyId&page=$pageId&area_id=$categories'));
      Iterable list = json.decode(response.body)['data'];
      _dataList = list.map((model) => tb.Table.fromJson(model)).toList();
    } else {
      final response = await http.get(
          Uri.parse(apiURLV2 + '/table/?company_id=$companyId&page=$pageId'));
      Iterable list = json.decode(response.body);
      _dataList = list.map((model) => tb.Table.fromJson(model)).toList();
    }
    setState(() {
      print('data1data1data1data1');
      print('categ $categories');
      print('dataList $dataList');
      print('companyId $companyId');
      dataList = _dataList;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    final _tbl = Provider.of<TableModel>(context, listen: true);
    final _area = Provider.of<AreaModel>(context);
    //final _theme = Provider.of<ThemeModel>(context);
    Color bgWhite = new Color(0xFFFFFFFF);
    final companyId = AppAPI.getCompanyOfUser();
    final _allTable = Provider.of<AppAPI>(context, listen: true);
    var _allArea = _area.areaList;
    _allArea.insert(0, new Area(id: 0, name: 'Tất cả'));

    timeago.setLocaleMessages('vi', timeago.ViMessages());
    var appBar = AppBar();
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    isLoading
        ? Future.delayed(Duration(seconds: 5), () {
            // Data loading complete
            setState(() {
              isLoading = false;
            });
            print('loading true');
            // Proceed with displaying the loaded data or performing other tasks
          })
        : '';

    return Scaffold(
        appBar: new AppBar(
            centerTitle: true,
            title: Text(
              "Danh sách phòng bàn",
              textScaleFactor: textScaleFactor,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              //_rightTopSearchIcon(id)
              IconButton(
                onPressed: () {
                  // method to show the search bar
                  showSearch(
                    context: context,
                    // delegate to customize the search bar
                    delegate: CustomSearchDelegate(),
                    //query: id.toString()
                  );
                },
                icon: const Icon(Icons.search),
              )
            ]),
        drawer: AppDrawer(),
        body: isLoading
            ? MyLoading()
            : new DefaultTabController(
                length: _allArea.length,
                child: new Scaffold(
                  appBar: new AppBar(
                    //actions: <Widget>[],
                    automaticallyImplyLeading: false,
                    title: new TabBar(
                      // tabs: [
                      //   new Tab(icon: new Icon(Icons.directions_car)),
                      //   new Tab(icon: new Icon(Icons.directions_transit)),
                      //   new Tab(icon: new Icon(Icons.directions_bike)),
                      // ],
                      onTap: (index) {
                        // Should not used it as it only called when tab options are clicked,
                        // not when user swapped
                        print('index');
                        print(_allArea[index].id);
                        _handleTabTap(_allArea[index].id);
                      },
                      isScrollable: true,
                      tabs: List<Widget>.generate(_allArea.length, (int index) {
                        return new Tab(
                          //icon: Icon(Icons.directions_car),
                          text: _allArea[index].name.toString(),
                        );
                      }),
                      indicatorColor: Colors.white,
                    ),
                  ),
                  body: _area.areaList.length != 0
                      ? new TabBarView(
                          children: List<Widget>.generate(_allArea.length,
                              (int index) {
                            //return new Text("again some random text");
                            return _tableListRender(_allArea[index].id);
                          }),
                        )
                      : new TabBarView(
                          children: [
                            //new Icon(Icons.directions_car,size: 50.0,),
                            //new Icon(Icons.directions_transit,size: 50.0,),
                            Container(
                                height: 100,
                                margin: const EdgeInsets.all(10.0),
                                child:
                                    Center(child: CircularProgressIndicator())),
                          ],
                        ),
                ),
              ));
  }

  Widget _tableListRender(num areaId) {
    if (dataList == null) {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      if (areaId == 0) {
        return GridView.count(
            controller: _scrollController,
            primary: false,
            shrinkWrap: true,
            childAspectRatio: 1,
            padding: const EdgeInsets.all(5.0),
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            crossAxisCount: 2,
            children: dataList
                .map<Widget>((i) => TableCard(
                      model: i,
                      onTap: () {
                        //Navigator.of(context).pushNamed('/table-detail/${i.id}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TableViewPage(
                              tableId: i.id,
                            ),
                          ),
                        );
                      },
                      areaId: areaId,
                    ))
                .toList());
      } else {
        // Iterable _newTblList = _tbl.tableList.where((i) => i.areaId);
        Iterable _newTblList = dataList.where((item) => item.areaId == areaId);
        return GridView.count(
            controller: _scrollController,
            primary: false,
            shrinkWrap: true,
            childAspectRatio: 1,
            padding: const EdgeInsets.all(5.0),
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            crossAxisCount: 2,
            children: _newTblList
                .map<Widget>((i) => TableCard(
                      model: i,
                      onTap: () {
                        //Navigator.of(context).pushNamed('/table-detail/${i.id}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TableViewPage(tableId: i.id),
                          ),
                        );
                      },
                      areaId: areaId,
                    ))
                .toList());
      }
    }
  }

  Widget _rightTopSearchIcon() {
    return Container();
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  // Demo list to show querying
  final id;
  CustomSearchDelegate({this.id});
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, id.toString());
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    // _scrollController.addListener(_scrollListener);
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      // controller: _scrollController,
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            //Go to the next screen with Navigator.push
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _tbl = Provider.of<TableModel>(context, listen: true);
    // print('_tbl.tableList');
    // print(_tbl.tableList);

    List<tb.Table> matchQuery = [];
    for (var p in _tbl.tableList) {
      if (p.tableName!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(p);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.tableName!),
          onTap: () {
            //Go to the next screen with Navigator.push
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TableViewPage(
                  tableId: result.id,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
