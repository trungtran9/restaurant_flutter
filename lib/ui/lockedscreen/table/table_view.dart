import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/table.dart';
import '../../../data/models/table_detail.dart';
import '../../common/api.dart';
import '../../../data/classes/product.dart';
import '../print/print.dart';
import 'merge_table.dart';
import 'move_table.dart';
import 'table_detail.dart';
import 'table.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'dart:convert';

import '../../../data/classes/dashboard.dart';
import '../../../data/models/area.dart';
import '../../../data/models/dashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class TableViewPage extends StatefulWidget {
  const TableViewPage(
      {super.key, required this.tableId, this.tableName, this.areaName});
  final num tableId;
  final String? tableName;
  final String? areaName;
  @override
  _TableViewPageState createState() => _TableViewPageState();
}

class _TableViewPageState extends State<TableViewPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Dashboard> _dashboard = <Dashboard>[];
  num companyId = 0;
  @override
  String? selectedValue;
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  void initState() {
    // TODO: implement initState
    final tblDetail = Provider.of<TableDetailModel>(context, listen: false);
    tblDetail.fetchProductsByTable(widget.tableId);

    super.initState();
    listenForTables();
    final tbl = Provider.of<TableModel>(context, listen: false);
    tbl.fetchTables();
    final area = Provider.of<AreaModel>(context, listen: false);
    area.fetchAreas();
    final allTable = Provider.of<AppAPI>(context, listen: false);
    allTable.getAllTablesByArea(0);
  }

  void listenForTables() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = prefs.getString("user_data") ?? "";
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
    //print(widget.tableId);
    //final _product = Provider.of<ProductModel>(context);
    print(companyId);
    var width = MediaQuery.of(context).size.width;
    final tblDetail = Provider.of<TableDetailModel>(context);

    return Scaffold(
        key: _scaffoldKey,
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushNamed('/table');
              }),
          centerTitle: true,
          title: Text(
            tblDetail.getTableName.toString(),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            //_rightTopSearchIcon(id)

            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: const Icon(
                    Icons.list,
                    size: 46,
                    color: Colors.white,
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    customHeights: [
                      ...List<double>.filled(MenuItems.firstItems.length, 48),
                      8,
                    ],
                    padding: const EdgeInsets.only(left: 16, right: 16),
                  ),

                  items: [
                    ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                        value: item,
                        child: MenuItems.buildItem(item),
                      ),
                    ),
                    const DropdownMenuItem<Divider>(
                        enabled: false, child: Divider()),
                  ],
                  onChanged: (value) {
                    MenuItems.onChanged(context, value as MenuItem,
                        widget.tableId, tblDetail.productList);
                    // MenuItems.onChanged(context, value as MenuItem,
                    //     widget.tableId, _tblDetail.productList);
                    MenuItems.onChanged(context, value, widget.tableId,
                        tblDetail.getTableName.toString());
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.redAccent,
                    ),
                    elevation: 8,
                    offset: const Offset(0, 8),
                  ),
                  // itemHeight: 48,
                  // itemPadding: const EdgeInsets.only(left: 16, right: 16),
                  // dropdownWidth: 160,
                  // dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                  // dropdownDecoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(4),
                  //   color: Colors.blue,
                  // ),
                  // dropdownElevation: 8,
                  // offset: const Offset(0, 8),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (content) => TableDetailPage(
                  id: widget.tableId,
                ),
              ),
            );
          },
          //tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        // floatingActionButton: _tblDetail.tableStatus == 1
        //     ? SpeedDial(
        //         // both default to 16
        //         //marginRight: width/2 -16,
        //         //marginBottom: 30,
        //         animatedIcon: AnimatedIcons.menu_close,
        //         animatedIconTheme: IconThemeData(size: 22.0),
        //         // this is ignored if animatedIcon is non null
        //         // child: Icon(Icons.add),
        //         // If true user is forced to close dial manually
        //         // by tapping main button and overlay is not rendered.
        //         closeManually: false,
        //         curve: Curves.bounceIn,
        //         overlayColor: Colors.black,
        //         overlayOpacity: 0.5,
        //         onOpen: () => print('OPENING DIAL'),
        //         onClose: () => print('DIAL CLOSED'),
        //         tooltip: 'Speed Dial',
        //         heroTag: 'speed-dial-hero-tag',
        //         backgroundColor: Colors.white,
        //         foregroundColor: Colors.black,
        //         elevation: 8.0,
        //         shape: CircleBorder(),
        //         children: [
        //           SpeedDialChild(
        //               child: Icon(Icons.repeat_one),
        //               backgroundColor: Colors.red,
        //               label: 'Gộp bàn',
        //               labelStyle: TextStyle(fontSize: 18.0),
        //               onTap: () => Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (context) => MergeTablePage(
        //                         tableId: widget.tableId,
        //                         tableName: _tblDetail.getTableName.toString(),
        //                       ),
        //                     ),
        //                   )),
        //           SpeedDialChild(
        //             child: Icon(Icons.swap_horiz),
        //             backgroundColor: Colors.blue,
        //             label: 'Chuyển bàn',
        //             labelStyle: TextStyle(fontSize: 18.0),
        //             onTap: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => MoveTablePage(
        //                     tableId: widget.tableId,
        //                     tableName: _tblDetail.getTableName.toString(),
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //           // SpeedDialChild(
        //           //   child: Icon(Icons.keyboard_voice),
        //           //   backgroundColor: Colors.green,
        //           //   label: 'Third',
        //           //   labelStyle: TextStyle(fontSize: 18.0),
        //           //   onTap: () => print('THIRD CHILD'),
        //           // ),
        //         ],
        //       )
        //     : Container(
        //         height: 0,
        //       ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: (tblDetail.productList != null &&
                tblDetail.productList.isNotEmpty)
            ? BottomAppBar(
                color: Colors.lightBlueAccent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: const EdgeInsets.all(12),
                      child: InkResponse(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (content) => TableDetailPage(
                                id: widget.tableId,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                print('aaaaa');
                                showPreAlert(context, widget.tableId,
                                    tblDetail.productList);
                                // this.onChanged(context, value as MenuItem,
                                //     widget.tableId, _tblDetail.productList);
                              },
                              child: const Text('Xem tạm tính'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: const EdgeInsets.all(12),
                      child: InkResponse(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => PrintPage(
                                      tableId: widget.tableId,
                                      tableName:
                                          tblDetail.getTableName.toString(),
                                      areaName:
                                          tblDetail.getAreaName.toString(),
                                      companyId: companyId)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                primary: Colors.white,
                              ),
                              onPressed: () {
                                print('thanh toán');
                                // this.onChanged(context, value as MenuI
                              },
                              child: const Text('Thanh toán'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: const EdgeInsets.all(12),
                      child: InkResponse(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 140, 255),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                print('thông báo');
                                // this.onChanged(context, value as MenuI
                              },
                              child: const Text('Thông báo'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10),
                    //   margin: EdgeInsets.all(12),
                    //   child: new InkResponse(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (content) => TableDetailPage(
                    //             id: widget.tableId,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     child: new Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: <Widget>[
                    //         new Icon(
                    //           Icons.library_add,
                    //           color: Color(0xFFFFFFFF),
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.only(left: 5),
                    //           child: new Text(
                    //             'Thêm món',
                    //             style: TextStyle(color: Color(0xFFFFFFFF)),
                    //           ),
                    //         ),
                    //         // TextButton(
                    //         //   style: TextButton.styleFrom(
                    //         //     primary: Colors.blue,
                    //         //   ),
                    //         //   onPressed: () {
                    //         //     print('aaaaa');
                    //         //   },
                    //         //   child: Text('Xem tạm tính'),
                    //         // ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10),
                    //   margin: EdgeInsets.all(12),
                    //   child: new InkResponse(
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (content) => PrintPage(
                    //                   tableId: widget.tableId,
                    //                   tableName:
                    //                       _tblDetail.getTableName.toString(),
                    //                   areaName:
                    //                       _tblDetail.getAreaName.toString(),
                    //                   companyId: companyId)));
                    //     },
                    //     child: new Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: <Widget>[
                    //         new Icon(
                    //           Icons.print,
                    //           color: Color(0xFFFFFFFF),
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.only(left: 5),
                    //           child: new Text(
                    //             'Báo bếp',
                    //             style: TextStyle(color: Color(0xFFFFFFFF)),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10),
                    //   margin: EdgeInsets.all(12),
                    //   child: new InkResponse(
                    //     onTap: () {

                    //     },
                    //     child: new Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: <Widget>[
                    //          new Icon(Icons.replay, color: Color(0xFFFFFFFF),),
                    //          new Text('Gộp bàn', style: TextStyle(color: Color(0xFFFFFFFF)),),

                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10),
                    //   margin: EdgeInsets.all(12),
                    //   child: new InkResponse(
                    //     onTap: () {

                    //     },
                    //     child: new Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: <Widget>[
                    //          new Icon(Icons.replay, color: Color(0xFFFFFFFF),),
                    //          new Text('Báo bếp', style: TextStyle(color: Color(0xFFFFFFFF)),),

                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              )
            : BottomAppBar(
                color: Colors.lightBlueAccent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: const EdgeInsets.all(12),
                      child: InkResponse(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (content) => TableDetailPage(
                                id: widget.tableId,
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.library_add,
                              color: Color(0xFFFFFFFF),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                'Gọi món',
                                style: TextStyle(color: Color(0xFFFFFFFF)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    tblDetail.tableStatus == 0
                        ? Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            margin: const EdgeInsets.all(12),
                            child: InkResponse(
                              onTap: () {
                                tblDetail
                                    .bookTable(widget.tableId)
                                    .then((result) {
                                  if (result) {
                                    const snackBar = SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Row(
                                        children: <Widget>[
                                          CircularProgressIndicator(),
                                          Text("  Đặt bàn...")
                                        ],
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.of(context)
                                        .pushReplacementNamed('/table');
                                  } else {
                                    // showAlertPopup(context, 'Thông báo',
                                    //     'Lỗi, vui lòng thử lại sau');
                                    Fluttertoast.showToast(
                                        msg: "Lỗi, vui lòng thử lại sau",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.library_add,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Đặt bàn',
                                      style:
                                          TextStyle(color: Color(0xFFFFFFFF)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : tblDetail.tableStatus == 2
                            ? Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                margin: const EdgeInsets.all(12),
                                child: InkResponse(
                                  onTap: () {
                                    tblDetail
                                        .removeBookTable(widget.tableId)
                                        .then((result) {
                                      if (result) {
                                        const snackbar = SnackBar(
                                          duration: Duration(seconds: 2),
                                          content: Row(
                                            children: <Widget>[
                                              CircularProgressIndicator(),
                                              Text("  Xóa đặt bàn...")
                                            ],
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackbar);
                                        Navigator.of(context)
                                            .pushReplacementNamed('/table');
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Lỗi, vui lòng thử lại sau",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    });
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.library_add,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'Hủy đặt bàn',
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                height: 0,
                              ),
                  ],
                ),
              ),
        body: _renderBody(tblDetail.tableStatus));
  }

  Widget _renderBody(num status) {
    final tblDetail = Provider.of<TableDetailModel>(context);
    if (status == 0 || status == 2) {
      return SingleChildScrollView(
        child: Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: status == 0
                      ? const Text('Bàn trống')
                      : const Text('Bàn đặt'),
                ),
                const ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // FlatButton(
                    //   child: Text('Gọi món'),
                    //   onPressed: () { Navigator.of(context).pushNamed('/table-detail/${widget.tableId}'); },
                    // ),
                    // status == 0 ?
                    // FlatButton(
                    //   child: Text('Đặt bàn'),
                    //   onPressed: () {  },
                    // ):
                    // FlatButton(
                    //   child: Text('Hủy đặt bàn'),
                    //   onPressed: () {  },
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // active table
      if (tblDetail.productList != null) {
        return SingleChildScrollView(
            child: Column(
                verticalDirection: VerticalDirection.down,
                children: tblDetail.productList.map((i) {
                  return GestureDetector(
                      onTap: () {
                        //showAlertDialog(context, widget.tableId, i.id);
                        showDataAlert(tblDetail, context, widget.tableId, i,
                            i.qty, i.price);
                        // print('_tblDetail.productList');
                        // print(_tblDetail.productList);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        //margin: EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          border: Border(
                            //top: BorderSide(width: 16.0, color: Colors.lightBlue.shade50),
                            bottom:
                                BorderSide(width: 1.0, color: Colors.black12),
                          ),
                          //borderRadius: BorderRadius.circular(7),
                        ),
                        child: ListTile(
                          title: Text(AppAPI.capitalize(
                              i.productName.toString().toLowerCase())),
                          trailing: Text(
                            " X " + i.qty.toString(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.red),
                          ),
                          subtitle: Row(
                            //alignment: Alignment.center,
                            children: <Widget>[
                              // Text(
                              //   " Số lượng: " + i.qty.toString(),
                              //   style:
                              //       TextStyle(fontSize: 14, color: Colors.red),
                              // ),
                              Text(
                                showPriceText(i.price),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ));
                }).toList()));
      }
      return const SingleChildScrollView(
        child: Center(
          child: Card(
            //color: Colors.blue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('Đang hoạt động'),
                  //subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                ),
                // ButtonBar(
                //   alignment: MainAxisAlignment.start,
                //   children: <Widget>[
                //     FlatButton(
                //       child: Text('Thêm món'),
                //       onPressed: () { Navigator.of(context).pushNamed('/table-detail/${widget.tableId}'); },
                //     ),
                //     FlatButton(
                //       child: Text('Chuyển bàn'),
                //       onPressed: () { Navigator.of(context).pushNamed('/table-detail/${widget.tableId}'); },
                //     ),
                //     FlatButton(
                //       child: Text('Gộp bàn'),
                //       onPressed: () { Navigator.of(context).pushNamed('/table-detail/${widget.tableId}'); },
                //     ),
                //     FlatButton(
                //       child: Text('Báo bếp'),
                //       onPressed: () {
                //         //Navigator.of(context).pushNamed('/table-detail/${widget.tableId}');
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => PrintPage(tableId: widget.tableId,),
                //           ),
                //         );
                //       },
                //     ),

                //   ],
                // ),
              ],
            ),
          ),
        ),
      );
    }
  }

  showDataAlert(tblDetail, BuildContext context, num tableId, Product product,
      num qty, num price) {
    TextEditingController controller = TextEditingController();
    TextEditingController noteController = TextEditingController();
    double width = MediaQuery.of(context).size.width;
    controller.text = qty.toString();
    noteController.text = product.note.toString();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(40),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: Text(
              product.productName.toString(),
              style: const TextStyle(
                fontSize: 24.0,
              ),
              textAlign: TextAlign.center,
            ),
            content: Container(
              //height: 300,
              width: width * 86,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Giá: " + showPriceText(price),
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Container(
                      // margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 2, // 60%
                            child: GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Color.fromARGB(255, 233, 71, 39)),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 2,
                                      bottom: 4,
                                      right: 2,
                                      top:
                                          0), //apply padding to some sides only
                                  child: Text(
                                    "-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              onTap: () {
                                int currentValue =
                                    int.tryParse(controller.text) ?? 0;
                                controller.text = (currentValue > 0)
                                    ? "${currentValue - 1}"
                                    : "0";

                                controller.text = controller.text != '0'
                                    ? controller.text
                                    : "1";
                              },
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: 160,
                              child: TextField(
                                controller: controller,
                                maxLength: 4,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: "0",
                                  border: InputBorder.none,
                                  counterText: "",
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2, // 20%
                            child: GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Color.fromARGB(255, 37, 20, 196)),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 2,
                                      bottom: 4,
                                      right: 2,
                                      top:
                                          0), //apply padding to some sides only
                                  child: Text("+",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              onTap: () {
                                int currentValue =
                                    int.tryParse(controller.text) ?? 0;
                                controller.text = "${currentValue + 1}";
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Ghi chú'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //       RegExp(r'^(?!.*\*[*#]|\d*#$)[*\d]*#?$')),
                        // ],
                        controller: noteController,

                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Ghi chú ở đây',
                            labelText: 'Ghi chú'),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 4, // 20%
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              // fixedSize: Size(250, 50),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Xóa món",
                              ),
                            ),
                            onPressed: () {
                              //print('signup');
                              showAlertDialog(context, tableId, product.id);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 4, // 60%
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              // fixedSize: Size(250, 50),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Cập nhật",
                              ),
                            ),
                            onPressed: () {
                              tblDetail
                                  .updateTable(
                                      tableId,
                                      product.id,
                                      num.parse(controller.text.toString()),
                                      price,
                                      (noteController.text.toString()))
                                  .then((result) {
                                Navigator.pop(context);
                                if (result) {
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Lỗi, vui lòng thử lại sau",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                //_scaffoldKey.currentState.hideCurrentSnackBar();
                                // Navigator.of(context).pushReplacementNamed('/home');

                                // showAlertPopup(context, 'Thông báo',
                                //     'Cập nhật thành công');
                                Fluttertoast.showToast(
                                    msg: "Cập nhật thành công",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                // Navigator.of(context).pushReplacementNamed(
                                //     '/table-detail/' + tableId.toString());
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showAlertDialog(BuildContext context, num tableId, num productId) {
    final removeProduct = Provider.of<TableDetailModel>(context, listen: false);
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Hủy"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
        //launchMissile();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        const snackbar = SnackBar(
          duration: Duration(seconds: 2),
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("  Xóa món...")
            ],
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        removeProduct.removeProduct(tableId, productId).then((result) {
          if (result) {
            //_scaffoldKey.currentState.hideCurrentSnackBar();
            // showAlertPopup(context, 'Thông báo', 'Xóa món thành công');
            Fluttertoast.showToast(
                msg: "Xóa món thành công",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context).pop();
          } else {
            //showAlertPopup(context, 'Thông báo', 'Lỗi');
            Fluttertoast.showToast(
                msg: "Lỗi xóa món",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.of(context).pop();
          }
        });
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Xác nhận"),
      content: const Text("Bạn có chắc chắn muốn xóa ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

// tam tinh
showPreAlert(BuildContext context, tableId, products) {
  List text = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final total = products.fold(0, (sum, item) => sum + (item.price) * item.qty);
  print(total);
  var formatter = NumberFormat('#,###');

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Text('Tạm tính'),
                Text(
                  //'Tổng cộng: ' + ('${formatter.format(total.toInt())}'.replaceAll(',', '.').toString()),
                  'Tổng cộng: ${showPriceText(total)}',
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            content: products.length > 0
                ? Container(
                    height: 300.0, // Change as per your requirement
                    width: 300.0, // Change as per your requirement
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 6,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Text(((index) + 1).toString()),
                          ),
                          title: Text(products[index].productName.toString()),
                          //subtitle: Text("Giá: " + '${formatter.format(products[index].price.toInt())}'.replaceAll(',', '.').toString()),
                          subtitle: Text(
                              "Giá: " + showPriceText(products[index].price)),
                          trailing: Text(
                              "Số lượng: " + products[index].qty.toString()),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: List.generate(text.length, (index) {
                      return Text(
                        text[index].toString(),
                        style: const TextStyle(fontSize: 22),
                      );
                    }),
                  ));
      });
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  //static const List<MenuItem> firstItems = [home, payment, cancel];
  static const List<MenuItem> firstItems = [add, move, cancel];
  static const List<MenuItem> secondItems = [logout];

  // static const home = MenuItem(text: 'Tạm tính', icon: Icons.table_view);
  static const payment = MenuItem(text: 'Thanh toán', icon: Icons.payment);
  static const cancel = MenuItem(text: 'Hủy đơn', icon: Icons.cancel);
  static const add = MenuItem(text: 'Gộp bàn', icon: Icons.repeat_one);
  static const move = MenuItem(text: 'Chuyển bàn', icon: Icons.swap_horiz);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(
      BuildContext context, MenuItem item, num tableId, tableName) async {
    switch (item) {
      case MenuItems.add:
        //Do something
        print('home $context');
        print('tableId $tableId');
        print('item $item');
        //showPreAlert(context, tableId, products);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MergeTablePage(
                tableId: tableId,
                tableName: tableName,
              ),
            ));
        //print('products $products');
        break;
      case MenuItems.move:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoveTablePage(
              tableId: tableId,
              tableName: tableName,
            ),
          ),
        );
        break;
      case MenuItems.cancel:
        final response = await http.get(Uri.parse(
            apiURLV2 + '/table/cancel_order?id=' + tableId.toString()));
        //print(Uri.parse(apiURLV2 + '/table/cancel_order?id=' + tableId.toString()));
        bool list = json.decode(response.body)['status'];
        if (list) {
          Fluttertoast.showToast(
              msg: json.decode(response.body)['message'].toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TablePage(),
            ),
          );
        } else {
          Fluttertoast.showToast(
              msg: json.decode(response.body)['message'].toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        break;
      case MenuItems.payment:
        final response =
            await http.get(Uri.parse('$apiURLV2/table/checkout?id=$tableId'));
        print(Uri.parse(apiURLV2 + '/table/checkout?id=' + tableId.toString()));
        bool list = json.decode(response.body)['status'];
        if (list) {
          Fluttertoast.showToast(
              msg: json.decode(response.body)['message'].toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TablePage(),
            ),
          );
        } else {
          Fluttertoast.showToast(
              msg: json.decode(response.body)['message'].toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        break;
    }
  }
}
