import 'package:flutter/material.dart';
import 'package:flutter_login/constants.dart';
import 'package:flutter_login/data/models/auth.dart';
import 'package:flutter_login/ui/widgets/custom_widget.dart';
// import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Drawer(
      child: SafeArea(
        // color: Colors.grey[50],
        child: ListView(
          children: <Widget>[
            // ListTile(
            //   leading: Icon(Icons.account_circle),
            //   title: Text(
            //     _auth.user.firstname + " " + _auth.user.lastname,
            //     textScaleFactor: textScaleFactor,
            //     maxLines: 1,
            //   ),
            //   subtitle: Text(
            //     _auth.user.id.toString(),
            //     textScaleFactor: textScaleFactor,
            //     maxLines: 1,
            //   ),
            //   // onTap: () {
            //   //   Navigator.of(context).popAndPushNamed("/myaccount");
            //   // },
            // ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text(
                'Dashboard',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                Navigator.of(context).popAndPushNamed("/home");
              },
            ),
            //Divider(),
            ExpansionTile(
            //initiallyExpanded: true,
              title: Row(
                children: <Widget>[
                  Icon(Icons.table_chart),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text('Quản lý bàn',
                        //style: TextStyle(fontSize: 22)
                    )
                  ),
                ],
              ),
              children: <Widget>[
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(left: 55),
                    child: Text('Tất cả',
                        //style: TextStyle(fontSize: 22)
                    )
                  ),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/table");
                  },
                ),  
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(left: 55),
                    child: Text('Bàn hoạt động',
                        //style: TextStyle(fontSize: 22)
                    )
                  ),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/active-table");
                  },
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(left: 55),
                    child: Text('Bàn Trống',
                        //style: TextStyle(fontSize: 22)
                    )
                  ),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/empty-table");
                  },
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(left: 55),
                    child: Text('Bàn đặt',
                        //style: TextStyle(fontSize: 22)
                    )
                  ),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/reserved-table");
                  },
                )
              ],
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text(
            //     'Settings',
            //     textScaleFactor: textScaleFactor,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).popAndPushNamed("/settings");
            //   },
            // ),
            
            // ListTile(
            //   leading: Icon(Icons.info),
            //   title: Text(
            //     "What's New",
            //     textScaleFactor: textScaleFactor,
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => WhatsNewPage.changelog(
            //           title: Text(
            //             "What's New",
            //             textScaleFactor: textScaleFactor,
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //               fontSize: 22.0,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           buttonText: Text(
            //             'Đóng',
            //             textScaleFactor: textScaleFactor,
            //             style: TextStyle(
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //         fullscreenDialog: true,
            //       ),
            //     );
            //   },
            // ),
            // Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Logout',
                textScaleFactor: textScaleFactor,
              ),
              //onTap: () => _auth.logout(),
              onTap: () {
                SharedPreferences.getInstance().then((prefs) {
                prefs.setString("user_data", '');
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
              });
              } 
            ),
          ],
        ),
      ),
    );
  }
}
