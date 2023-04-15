import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../data/classes/dashboard.dart';
import '../widgets/dashboard_title.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../data/models/auth.dart';
import '../../data/models/dashboard.dart';
import '../app/app_drawer.dart';
import '../../data/models/api.dart';
import '../../data/classes/user_v2.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Dashboard> _dashboard = <Dashboard>[];
  //List user_data = [];
  num companyId = 0;
  List<UserV2> users = [];
  @override
  void initState() {
    super.initState();
    listenForTables();
    //_getUsers();
  }

  void listenForTables() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var userData = _prefs.getString("user_data") ?? "";
      if (userData != "") {
        Map<String, dynamic> data = jsonDecode(userData);

        companyId = (data['companyId']);
        print(data);
      }
      DashboardAPI.getTables(companyId).then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          _dashboard = list.map((model) => Dashboard.fromJson(model)).toList();

          print('_dashboard');
          print(_dashboard);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _getUsers() {
    API.getUsers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => UserV2.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    var appBar = AppBar();
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
            textScaleFactor: textScaleFactor,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            )
          ],
        ),
        drawer: AppDrawer(),
        // body: SingleChildScrollView(
        //   child: Column(
        //     children: <Widget>[
        //       Container(height: 10.0),
        //       _auth?.user?.avatar != null
        //           ? Center(
        //               child: Container(
        //                 width: 120.0,
        //                 height: 120.0,
        //                 decoration: BoxDecoration(
        //                   color: Colors.grey[300],
        //                   image: DecorationImage(
        //                     image: NetworkImage(_auth?.user?.avatar),
        //                     fit: BoxFit.cover,
        //                   ),
        //                   borderRadius: BorderRadius.all(Radius.circular(60.0)),
        //                   border: Border.all(
        //                     color: Colors.grey,
        //                     width: 2.0,
        //                   ),
        //                 ),
        //               ),
        //             )
        //           : Container(
        //               height: 0.0,
        //             ),
        //       ListTile(
        //         title: Text('ID'),
        //         subtitle: _auth?.user?.id == null
        //             ? null
        //             : Text(
        //                 _auth?.user?.id.toString() ?? "",
        //               ),
        //       ),
        //       ListTile(
        //         title: Text('Company ID'),
        //         subtitle: _auth?.user?.id == null
        //             ? null
        //             : Text(
        //                'addg',
        //               ),
        //       ),
        //       ListTile(
        //         title: Text('First Name'),
        //         subtitle: _auth?.user?.firstname == null
        //             ? null
        //             : Text(
        //                 _auth?.user?.firstname.toString() ?? "",
        //               ),
        //       ),
        //       ListTile(
        //         title: Text('Last Name'),
        //         subtitle: _auth?.user?.lastname == null
        //             ? null
        //             : Text(
        //                 _auth?.user?.lastname.toString() ?? "",
        //               ),
        //       ),
        //       // ListView.builder(
        //       //   itemCount: _dashboard.length,
        //       //   itemBuilder: (context, index) => DashboardTile(_dashboard[index]),
        //       // ),
        //     ],
        //   ),
        // ),

        body: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.fill, // otherwise the logo will be tiny
                    child: Image.asset("assets/images/table.jpg",
                        //width: 100, height: 100
                        fit: BoxFit.cover,
                        //fit: BoxFit.fill,
                        width: _width,
                        height: _height / 3),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: _dashboard.length > 0
                    ? GridView.count(
                        primary: false,
                        childAspectRatio: 1.2,
                        padding: const EdgeInsets.all(5.0),
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        crossAxisCount: 2,
                        children: _dashboard.map<Widget>((i) {
                          //print(i.url.toString());
                          return GestureDetector(
                              // height: 100,
                              // alignment: Alignment.center,
                              // color: Colors.cyan,
                              // onTap: onTap,
                              onTap: () => Navigator.pushNamed(
                                  context, i.url.toString()),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black12, width: 2),
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: ListTile(
                                  title: Text(
                                    i.name.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                  subtitle: Text(
                                    i.total.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                  // leading: Container(
                                  //   margin: EdgeInsets.only(left: 6.0),
                                  //   child: Image.network(_beer.image_url, height: 50.0, fit: BoxFit.fill,)
                                  // ),
                                  //onTap: () => Navigator.pushNamed(context, i.url.toString()),
                                ),
                              ));
                        }).toList())
                    : Center(
                        child: Text(
                          "Không tìm thấy bàn nào",
                          textAlign: TextAlign.center,
                        ),
                      ),
              )
            ])
        // body: ListView.builder(
        //   itemCount: users.length,
        //   itemBuilder: (context, index) {
        //     return ListTile(title: Text(users[index].name));
        //   },
        // )
        );
  }
}
