import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login/data/classes/area.dart';
import 'package:flutter_login/data/models/area.dart';
import 'package:flutter_login/data/models/auth.dart';
import 'package:flutter_login/data/models/table.dart';
import 'package:flutter_login/ui/app/app_drawer.dart';
import 'package:flutter_login/ui/common/api.dart';
import 'package:flutter_login/ui/common/table_search.dart';
import 'package:flutter_login/ui/widgets/custom_widget.dart';
import 'package:flutter_login/ui/widgets/table_card.dart';
import 'package:flutter_login/utils/popUp.dart';
// import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class MoveTablePage extends StatefulWidget {
  @override
  MoveTablePage({required this.tableId, required this.tableName});
  final num tableId;
  final String tableName;
  _MoveTablePageState createState() => _MoveTablePageState();
}

class _MoveTablePageState extends State<MoveTablePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final num companyId = 0;
  @override
  void initState() {
    super.initState();
    final _tbl = Provider.of<TableModel>(context, listen: false);
    _tbl.fetchTables();
    final _area = Provider.of<AreaModel>(context, listen: false);
    _area.fetchAreas(status: 0);
    final _allTable = Provider.of<AppAPI>(context, listen: false);
    _allTable.getAllTablesByArea(0);
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    final _tbl = Provider.of<TableModel>(context);
    final _area = Provider.of<AreaModel>(context);
    //final _theme = Provider.of<ThemeModel>(context);
    Color bgWhite = new Color(0xFFFFFFFF);
    final companyId = AppAPI.getCompanyOfUser();
    final _allTable = Provider.of<AppAPI>(context);

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

    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          title: Text(
            "Chuyển bàn - " + widget.tableName.toString(),
            textScaleFactor: textScaleFactor,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[_rightTopSearchIcon(widget.tableId)],
        ),
        //drawer: AppDrawer(),
        body: new DefaultTabController(
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
                    children:
                        List<Widget>.generate(_allArea.length, (int index) {
                      //return new Text("again some random text");
                      return _tableListRender(_allArea[index].id, 1);
                    }),
                  )
                : new TabBarView(
                    children: [
                      //new Icon(Icons.directions_car,size: 50.0,),
                      //new Icon(Icons.directions_transit,size: 50.0,),
                      Container(
                          height: 100,
                          margin: const EdgeInsets.all(10.0),
                          child: new Text('Không có dữ liệu')),
                    ],
                  ),
          ),
        ));
  }

  Widget _tableListRender(num areaId, num status) {
    final _tbl = Provider.of<TableModel>(
      context,
    );
    if (_tbl.tableList == null) {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      if (areaId == 0) {
        Iterable _newTblList = _tbl.tableList.where((item) => item.status == 0);
        _newTblList = _newTblList.where((item) => item.id != widget.tableId);
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
                        final snackbar = SnackBar(
                          duration: Duration(seconds: 4),
                          content: Row(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Text("  Chuyển bàn...")
                            ],
                          ),
                        );
                        //_scaffoldKey.currentState.showSnackBar(snackbar);
                        // _scaffoldKey.currentState.showSnackBar(snackbar);
                        _tbl.moveTable(widget.tableId, i.id).then((result) {
                          if (result) {
                            //_scaffoldKey.currentState.hideCurrentSnackBar();
                            Navigator.of(context)
                                .pushReplacementNamed('/table');
                          } else {
                            //setState(() => this._status = 'rejected');
                            showAlertPopup(context, 'Thông báo', 'Lỗi');
                          }
                        });
                      },
                      areaId: areaId,
                      action: 'move-table',
                      buttonAction: () {},
                    ))
                .toList());
      } else {
        Iterable _newTblList =
            _tbl.tableList.where((item) => item.areaId == areaId);
        _newTblList = _newTblList.where((item) => item.status == 0);
        _newTblList = _newTblList.where((item) => item.id != widget.tableId);
        ;
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
                        final snackbar = SnackBar(
                          duration: Duration(seconds: 2),
                          content: Row(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Text("  Hủy món...")
                            ],
                          ),
                        );
                        //_scaffoldKey.currentState.showSnackBar(snackbar);
                        // _scaffoldKey.currentState.showSnackBar(snackbar);
                        _tbl.moveTable(widget.tableId, i.id).then((result) {
                          if (result) {
                            //_scaffoldKey.currentState.hideCurrentSnackBar();
                            //Navigator.of(context).pushReplacementNamed('/table');
                            Navigator.of(context).popAndPushNamed('/table');
                          } else {
                            //setState(() => this._status = 'rejected');
                            showAlertPopup(context, 'Thông báo', 'Lỗi');
                          }
                        });
                      },
                      areaId: areaId,
                      action: 'move-table',
                      buttonAction: () {},
                    ))
                .toList());
      }
    }
  }

  Widget _rightTopSearchIcon(num tableId) {
    return Container();
  }
}
