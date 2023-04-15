import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/data/classes/table.dart' as tb;
import 'package:flutter_login/data/models/table.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:native_widgets/native_widgets.dart';
//import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_login/data/classes/table.dart' as tb;
import 'package:timeago/timeago.dart' as timeago;
import '../../constants.dart';

class TableCard extends StatelessWidget {
  const TableCard(
      {Key? key,
      required this.model,
      this.onTap,
      required this.areaId,
      this.status = 0,
      this.action = '',
      this.buttonAction})
      : super(key: key);
  final tb.Table model;
  final void Function()? onTap;
  final void Function()? buttonAction;
  final areaId;
  final status;
  final String action;
  Widget build(BuildContext context) {
    final updated = DateTime.parse(model.updated.toString());
    final now = DateTime.now();
    //final _theme = Provider.of<ThemeModel>(context);
    final difference = now.difference(updated).inMinutes;
    final timeAgo =
        new DateTime.now().subtract(new Duration(minutes: difference));
    Color bgWhite = new Color(0xFFFFFFFF);
    // if(_theme.type.toString() == 'ThemeType.dark')
    //   bgWhite = new Color(0xFF8f9499);
    // else if(_theme.type.toString() == 'ThemeType.black')
    //   bgWhite = new Color(0xFF6e6868);

    timeago.setLocaleMessages('vi', timeago.ViMessages());
    return GestureDetector(
        onTap: onTap,
        child: Container(
          //height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 2),
            color: (model.status == 1)
                ? Color.fromARGB(255, 195, 12, 12)
                : (model.status == 0)
                    ? bgWhite
                    : Color.fromARGB(255, 195, 12, 12),
            borderRadius: BorderRadius.circular(7),
          ),
          //
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              ListTile(
                title: (model.status == 1)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Text(
                          model.tableName.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.white,
                            // fontFamily: "Sans",
                          ),
                        ),
                      )
                    //Text(model.tableName.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, height: 1.8),)
                    : Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Text(
                          model.tableName.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.black,
                          ),
                        ),
                      ),

                subtitle: (action == 'move-table')
                    ? new Text(
                        'Chyển bàn',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(255, 16, 101, 206)
                                .withOpacity(0.8), fontSize: 18),
                      )
                    : (action == 'merge-table')
                        ? new Text(
                            'Áp dụng',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 16, 101, 206).withOpacity(0.8),
                                fontSize: 18),
                          )
                        : (model.status == 1)
                            ? Text(model.getTableStatus(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))
                            : Text(
                                model.getTableStatus(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black)
                              ),
                //onTap: () => Navigator.pushNamed(context, '/table'),
              ),
              (model.status == 1)
                  ? Positioned(
                      left: 10.0,
                      top: 10.0,
                      child: Row(children: <Widget>[
                        Icon(Icons.timer, color: Colors.white,
                        ),
                        Text(
                          " " + timeago.format(timeAgo, locale: 'vi'),
                          style: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.white,
                            // fontFamily: "Sans",
                          ),
                        )
                      ]))
                  : Container(
                      height: 0.0,
                    ),
              (model.status == 1)
                  ? Positioned(
                      left: 10.0,
                      bottom: 10.0,
                      child: Row(children: <Widget>[
                        //Icon(Icons.),
                        Text(" " +
                            model.total.toString().replaceAllMapped(
                                new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]},') +
                            currency,
                          style: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.white,
                            // fontFamily: "Sans",
                          ),
                        )
                      ]))
                  : Container(
                      height: 0.0,
                    ),
            ],
          ),
        ));
  }
}
