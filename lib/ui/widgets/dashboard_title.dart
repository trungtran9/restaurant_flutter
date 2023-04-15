import 'package:flutter/material.dart';
import 'package:flutter_login/data/classes/dashboard.dart';
import 'package:responsive_grid/responsive_grid.dart';
class DashboardTile extends StatelessWidget {
  final Dashboard dashboard;
  DashboardTile(this.dashboard);

  @override
  Widget build(BuildContext context) => ResponsiveGridRow(
    children: [
      ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: Container(
          height: 100,
          alignment:  Alignment.center,
          color: Colors.green,
          child: 
          ListTile(
            title: Text(dashboard.name),
              subtitle: Text(dashboard.total.toString()),
              // leading: Container(
              //   margin: EdgeInsets.only(left: 6.0),
              //   child: Image.network(_beer.image_url, height: 50.0, fit: BoxFit.fill,)
              // ),
            ),
          
        ),
      )
      // ListTile(
      //   title: Text(dashboard.name),
      //   subtitle: Text(dashboard.total.toString()),
      //   // leading: Container(
      //   //   margin: EdgeInsets.only(left: 6.0),
      //   //   child: Image.network(_beer.image_url, height: 50.0, fit: BoxFit.fill,)
      //   // ),
      // ),
      //Divider()
    ],
  );
}
