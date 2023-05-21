import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login/data/classes/area.dart';
import 'package:flutter_login/data/classes/dashboard.dart';
import 'package:flutter_login/data/models/api.dart';
import 'package:flutter_login/data/models/area.dart';
import 'package:flutter_login/data/models/auth.dart';
import 'package:flutter_login/data/models/dashboard.dart';
import 'package:flutter_login/data/models/table.dart';
import 'package:flutter_login/ui/app/app_drawer.dart';
import 'package:flutter_login/ui/common/api.dart';
import 'package:flutter_login/ui/common/table_search.dart';
import 'package:flutter_login/ui/lockedscreen/table/table_view.dart';
import 'package:flutter_login/ui/widgets/custom_widget.dart';
import 'package:flutter_login/ui/widgets/dashboard_title.dart';
import 'package:flutter_login/ui/widgets/table_card.dart';
// import 'package:flutter_whatsnew/flutter_whatsnew.dart';
//import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../ui/layout/loading.dart';

class TablePage extends StatefulWidget {
  @override
  TablePage({Key? key, this.tableStatus = 0});
  final num tableStatus;
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  List<Dashboard> _dashboard = <Dashboard>[];
  num companyId = 0;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    listenForTables();
    final _tbl = Provider.of<TableModel>(context, listen: false);
    _tbl.fetchTables();
    final _area = Provider.of<AreaModel>(context, listen: false);
    _area.fetchAreas();
    final _allTable = Provider.of<AppAPI>(context, listen: false);
    _allTable.getAllTablesByArea(0);
    //print(widget.tableStatus);
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

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    final _tbl = Provider.of<TableModel>(context, listen: true);
    final _area = Provider.of<AreaModel>(context);
    //print(_area.areaList);
    //final _theme = Provider.of<ThemeModel>(context);
    Color bgWhite = new Color(0xFFFFFFFF);
    final companyId = AppAPI.getCompanyOfUser();
    final _allTable = Provider.of<AppAPI>(context, listen: true);
    var _allArea = _area.areaList;
    _allArea.insert(0, new Area(id: 0, name: 'Tất cả'));

    // if(_theme.type.toString() == 'ThemeType.dark')
    //   bgWhite = new Color(0xFF8f9499);
    // else if(_theme.type.toString() == 'ThemeType.black')
    //   bgWhite = new Color(0xFF6e6868);
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
          actions: <Widget>[_rightTopSearchIcon()],
        ),
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
    final _tbl = Provider.of<TableModel>(context, listen: true);
    if (_tbl.tableList == null) {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      if (areaId == 0)
        return GridView.count(
            primary: false,
            shrinkWrap: true,
            childAspectRatio: 1,
            padding: const EdgeInsets.all(5.0),
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            crossAxisCount: 2,
            children: _tbl.tableList
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
      else {
        // Iterable _newTblList = _tbl.tableList.where((i) => i.areaId);
        Iterable _newTblList =
            _tbl.tableList.where((item) => item.areaId == areaId);
        //print(_newTblList);
        return GridView.count(
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
