
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/models/confirm_order.dart';
import '../../utils/popUp.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class ConfirmOrderPage extends StatefulWidget {
  @override
  
  ConfirmOrderPage({required this.tableId});
  final num tableId;
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() { 
    super.initState();
    final _confirmProduct = Provider.of<ConfirmOrderModel>(context, listen: false);
    _confirmProduct.fetchOrderByTable(widget.tableId);
  }
  @override
  Widget build(BuildContext context) {
    final _confirmProduct = Provider.of<ConfirmOrderModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back), 
          onPressed: (){Navigator.of(context).pushNamed('/table-detail/${widget.tableId}');}
        ),
        centerTitle: true,
        title: Text(
          'Xác nhận món',
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: _confirmProduct.productListOrder != null ?
      BottomAppBar(
        color: Colors.lightBlueAccent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.all(12),
              child: new InkResponse(
                onTap: () {
                  final snackbar = SnackBar(
                  duration: Duration(seconds: 4),
                    content: Row(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text("  Xác nhận...")
                      ],
                    ),
                  );
                  //_scaffoldKey.currentState.showSnackBar(snackbar);
                    _confirmProduct.confirmOrder(widget.tableId).then((result){
                      if (result) {
                        //_scaffoldKey.currentState.hideCurrentSnackBar();
                        Navigator.of(context).pushReplacementNamed('/table');
                      } 
                      else {
                          showAlertPopup(context, 'Thông báo', 'Lỗi');
                        } 
                        
                      //Navigator.of(context).pushReplacementNamed('/table-detail/' + tableId.toString());
                  });
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.check_circle, color: Color(0xFFFFFFFF),),
                    //new Text('Xác nhận', style: TextStyle(color: Color(0xFFFFFFFF)),),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Xác nhận', style: TextStyle(color: Color(0xFFFFFFFF)),),
                    ),
                    
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.all(12),
              child: new InkResponse(
                onTap: () {
                  
                  Navigator.of(context).pushReplacementNamed('/table-detail/' + widget.tableId.toString());
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Icon(Icons.add_box, color: Color(0xFFFFFFFF),),
                    new Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Thêm món', style: TextStyle(color: Color(0xFFFFFFFF)),),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
      :
      Container(
        height: 0,
      )
      ,
      body:  _confirmProduct.productListOrder != null ?
      SingleChildScrollView(
        child: Column(
          verticalDirection: VerticalDirection.down,
            children: _confirmProduct.productListOrder.map((i) {
              var img = (i.image != "" )? ( apiHomeURL + '/public/templates/uploads/' + i.image.toString()) : (apiHomeURL + '/public/templates/uploads/no_image.jpg');
              return GestureDetector(
                onTap: () {
                  showAlertDialog(context, widget.tableId, i.id);
                  
                },
                child: 
                  
                  new Container(
                  padding: EdgeInsets.all(6),
                  //margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      //top: BorderSide(width: 16.0, color: Colors.lightBlue.shade50),
                      bottom: BorderSide(width: 1.0, color: Colors.black12),
                    ),
                    //borderRadius: BorderRadius.circular(7),
                  ),
                  child: ListTile(
                    leading: new Container(
                      width: 120.0,
                      //height: 80.0,
                      decoration: new BoxDecoration(
                        //shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new NetworkImage(img),
                        ),
                      ),
                    ),
                    title: Text(capitalize(i.productName.toString().toLowerCase())),
                    trailing: Icon(Icons.delete_outline, color: Colors.red, size: 32,),
                    //subtitle: Text(i.price.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')),
                    subtitle: Row(
                      //alignment: Alignment.center,
                      children: <Widget>[
                        Text(
                          i.price.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') + currency + ', '
                        ),
                        Text(
                          " Số lượng: " + i.qty.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                )
              );
            }).toList()
        )
      )
      :
      Container(
        height: 0,
      )
      ,
      
    );
  }
  //String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String capitalize(String text) {
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }
  showAlertDialog(BuildContext context, num tableId, num productId) {
    final _confirmProduct = Provider.of<ConfirmOrderModel>(context, listen: false);
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop(); // dismiss dialog
        //launchMissile();
      },
    );
    Widget continueButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        final snackbar = SnackBar(
          duration: Duration(seconds: 4),
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("  Hủy món...")
            ],
          ),
        );
        //_scaffoldKey.currentState.showSnackBar(snackbar);
        _confirmProduct.removeTempProduct(tableId, productId).then((result){
          if (result) {
            //_scaffoldKey.currentState.hideCurrentSnackBar();
            showAlertPopup(context, 'Thông báo', 'Hủy món thành công');
          } 
          else {
            showAlertPopup(context, 'Thông báo', 'Lỗi');
          }   
        });
        Navigator.of(context).pop();
      },
    );
  
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Xác nhận"),
      content: Text("Bạn có chắc chắn muốn xóa ?"),
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