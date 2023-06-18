import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../data/classes/product.dart';
import '../../../data/models/confirm_order.dart';
import '../../../data/models/product.dart';
import '../../../data/models/table_detail.dart';
import '../confirm_order.dart';
import '../product/product_detail.dart';
import 'table_view.dart';
import '../../widgets/custom_widget.dart';
import '../../../utils/popUp.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import 'package:badges/badges.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TableDetailPage extends StatefulWidget {
  @override
  TableDetailPage({required this.id});
  final num id;
  _TableDetailPageState createState() => _TableDetailPageState();
}

class _TableDetailPageState extends State<TableDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List listOrder = [];
  num totalCart = 0;
  List<TextEditingController> _controllerQty = [];
  //final SlidableController slidableController = SlidableController();
  @override
  void initState() {
    super.initState();
    final _tblDetail = Provider.of<TableDetailModel>(context, listen: false);
    _tblDetail.fetchProductsByTable(widget.id);
    _tblDetail.getTotalCart(widget.id);
    final _product = Provider.of<ProductModel>(context, listen: false);
    _product.fetchProducts();

    _tblDetail.getOrderTempByTableId(widget.id);
    //listOrder = _tblDetail.productOrderList;
    final _confirmProduct =
        Provider.of<ConfirmOrderModel>(context, listen: false);
    _confirmProduct.fetchOrderByTable(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final _tblDetail = Provider.of<TableDetailModel>(context);
    final _product = Provider.of<ProductModel>(context);
    final _confirmProduct = Provider.of<ConfirmOrderModel>(context);
    num totals = _tblDetail.totalCart;
    int count = 0;
    print(totals);
    listOrder = _tblDetail.productOrderList;
    return Scaffold(
        key: _scaffoldKey,
        //resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          //automaticallyImplyLeading: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              //Navigator.of(context).popAndPushNamed('/table');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TableViewPage(
                    tableId: id,
                  ),
                ),
              );
            },
          ),
          centerTitle: true,
          title: Text(
            "Chọn món vào đơn",
            textScaleFactor: textScaleFactor,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            //_rightTopSearchIcon(id)
          ],
        ),
        //drawer: AppDrawer(),
        bottomNavigationBar: (listOrder != null && listOrder.length > 0)
            ? BottomAppBar(
                color: Colors.lightBlueAccent,
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // IconButton(
                    //   icon: Icon(Icons.menu),
                    //   onPressed: () {},
                    // ),
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
                                Text("  Hủy món...")
                              ],
                            ),
                          );
                          //_scaffoldKey.currentState.showSnackBar(snackbar);
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          _tblDetail.removeTempOrder(widget.id).then((result) {
                            if (result) {
                            } else {
                              //setState(() => this._status = 'rejected');
                              showAlertPopup(context, 'Thông báo', 'Lỗi');
                            }
                            //_scaffoldKey.currentState.hideCurrentSnackBar();
                            showAlertPopup(
                                context, 'Thông báo', 'Hủy món thành công');
                            setState(() {
                              //listOrder = List();
                            });
                            //Navigator.of(context).pushReplacementNamed('/table-detail/' + tableId.toString());
                          });
                        },
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Icon(
                              Icons.replay,
                              color: Color(0xFFFFFFFF),
                            ),
                            new Text(
                              'Chọn lại',
                              style: TextStyle(color: Color(0xFFFFFFFF)),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmOrderPage(
                                tableId: widget.id,
                              ),
                            ),
                          );
                        },
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // new Icon(Icons.replay, color: Color(0xFFFFFFFF),),
                            // new Text(list.length.toString(), style: TextStyle(color: Color(0xFFFFFFFF)),),
                            Badge(
                              //badgeContent: Text(cartTotal(_confirmProduct.productListOrder).toString(), style: TextStyle(color: Color(0xFFFFFFFF))),
                              badgeContent: Text(totals.toString(),
                                  style: TextStyle(color: Color(0xFFFFFFFF))),
                              child: Icon(Icons.shopping_cart,
                                  color: Color(0xFFFFFFFF)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(height: 0, color: Colors.white // This is optional
                ),
        body: _product.productList != null
            ? SingleChildScrollView(
                child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: _product.productList.map((i) {
                  _controllerQty.add(TextEditingController(text: '1'));

                  var img = (i.image != "")
                      ? (apiHomeURL +
                          '/public/templates/uploads/' +
                          i.image.toString())
                      : (apiHomeURL + '/public/templates/uploads/no_image.jpg');
                  print(img);
                  //var checkOrder = (listOrder != null && listOrder.length > 0 && listOrder.contains(i.id) ? 1 : 0);

                  var checkOrder = 0;
                  //print(_controllerQty);
                  return GestureDetector(
                      //onTap: () => {Navigator.of(context).pushNamed('/product/${i.id}')},
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ProductDetailPage(product: i, tableId: widget.id,),
                        //   ),
                        // );
                      },
                      child: checkOrder == 1
                          ? new Container(
                              padding: EdgeInsets.all(6),
                              //margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black12),
                                ),
                                //borderRadius: BorderRadius.circular(7),
                              ),
                              // child: Slidable(
                              //   controller: slidableController,
                              //   actionPane: SlidableDrawerActionPane(),
                              //   actionExtentRatio: 0.7,
                              //   child:ListTile(
                              //     leading: new Container(
                              //       width: 120.0,
                              //       //height: 80.0,
                              //       decoration: new BoxDecoration(
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color: Colors.grey,
                              //             blurRadius: 1.0, // has the effect of softening the shadow
                              //             spreadRadius: 1.0, // has the effect of extending the shadow
                              //             offset: Offset(
                              //               1.0, // horizontal, move right 10
                              //               1.0, // vertical, move down 10
                              //             ),
                              //           )
                              //         ],
                              //        // shape: BoxShape.circle,
                              //         image: new DecorationImage(
                              //           fit: BoxFit.cover,
                              //           image: new CachedNetworkImageProvider(img),
                              //         ),
                              //       ),
                              //       child: Stack(
                              //         children: <Widget>[

                              //           Positioned(
                              //             left: 2.0,
                              //             top: 5.0,
                              //             child: Row(
                              //               children: <Widget>[
                              //                 Icon(Icons.check_circle, color: Color(0xFF09a13b)),
                              //               ]
                              //             )
                              //           )
                              //         ])
                              //     ),
                              //     title: Text(i.productName),
                              //     subtitle: Text(i.price.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')),

                              //   ),
                              //   secondaryActions: <Widget>[
                              //     Row(
                              //       //spacing: 12, // space between two icons
                              //       children: <Widget>[
                              //         Container(
                              //           margin: const EdgeInsets.only(top: 5),
                              //           child: IconButton(
                              //             icon: new Icon(Icons.remove),
                              //             onPressed: ()=>
                              //             setState(() {
                              //               var rmItem = num.parse(_controllerQty[index].text);
                              //               rmItem > 1 ? rmItem-- :rmItem = rmItem;
                              //               _controllerQty[index].text = rmItem.toString();
                              //             }
                              //             ),
                              //           ),
                              //         ),
                              //         Container(
                              //           width: 75,
                              //           height: 40,
                              //           child: TextFormField(
                              //             onChanged: (text) {
                              //               setState(() {
                              //                 // _itemCount = num.parse(text) ;
                              //                 }
                              //               );
                              //             },
                              //             textAlign: TextAlign.center,
                              //             decoration: InputDecoration(
                              //               enabledBorder: UnderlineInputBorder(
                              //                 borderSide: BorderSide(color: Colors.black26, width: 1.2),
                              //               ),
                              //               contentPadding: const EdgeInsets.all(6.0)
                              //               ),
                              //               minLines: 1,
                              //               maxLines: 1,
                              //               //onSaved: (val) => _qty = num.parse(val),
                              //               obscureText: false,
                              //               keyboardType: TextInputType.number,
                              //               controller: _controllerQty[index],
                              //               autocorrect: false,
                              //           ),
                              //         ),
                              //         Container(
                              //           margin: const EdgeInsets.only(top: 5),
                              //           child: IconButton(

                              //             icon: new Icon(Icons.add),
                              //             onPressed: ()=>
                              //             setState((){
                              //               var addItem = num.parse(_controllerQty[index].text);
                              //               addItem++;
                              //               _controllerQty[index].text = addItem.toString();
                              //             })
                              //           ),
                              //         ),// icon-1

                              //         IconSlideAction(
                              //           //caption: 'Đặt món',
                              //           color: Colors.transparent,
                              //           //icon: Icons.delete,
                              //           onTap: () {
                              //             //print(_controllerQty[index].text);
                              //             final snackbar = SnackBar(
                              //               duration: Duration(seconds: 4),
                              //                 content: Row(
                              //                   children: <Widget>[
                              //                     CircularProgressIndicator(),
                              //                     Text("  Đặt món...")
                              //                   ],
                              //                 ),
                              //             );
                              //             _scaffoldKey.currentState.showSnackBar(snackbar);
                              //             _tblDetail.addItem(id, i.id, num.parse(_controllerQty[index].text), i.price).then((result){
                              //               if (result)
                              //                 //_scaffoldKey.currentState.hideCurrentSnackBar();
                              //               else
                              //                 showAlertPopup(context, 'Thông báo', 'Lỗi đặt món');

                              //             });
                              //           },
                              //           iconWidget: Text('Đặt món'),
                              //         ),
                              //       ],
                              //     )
                              //   ],
                              // )
                            )
                          : new Container(
                              padding: EdgeInsets.all(6),
                              //margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  //top: BorderSide(width: 16.0, color: Colors.lightBlue.shade50),
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black12),
                                ),
                                //borderRadius: BorderRadius.circular(7),
                              ),
                              // child: Slidable(

                              //   controller: slidableController,
                              //   actionPane: SlidableDrawerActionPane(),
                              //   actionExtentRatio: 0.7,
                              //   child: ListTile(
                              //     leading: new Container(
                              //       width: 120.0,
                              //       //height: 80.0,
                              //       decoration: new BoxDecoration(
                              //         //shape: BoxShape.circle,
                              //         image: new DecorationImage(
                              //           fit: BoxFit.cover,
                              //           image: new CachedNetworkImageProvider(img),
                              //         ),
                              //       ),
                              //     ),
                              //     title: Text(i.productName),
                              //     // title: TextField(
                              //     //   //obscureText: true,
                              //     //   controller: _controllerQty[index],
                              //     //   decoration: InputDecoration(
                              //     //     border: OutlineInputBorder(),
                              //     //     labelText: 'Password',
                              //     //   ),
                              //     // ),
                              //     subtitle: Text(i.price.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')),
                              //   ),
                              //   secondaryActions: <Widget>[
                              //     Row(
                              //       //spacing: 12, // space between two icons
                              //       children: <Widget>[
                              //         Container(
                              //           margin: const EdgeInsets.only(top: 5),
                              //           child: IconButton(
                              //             icon: new Icon(Icons.remove),
                              //             onPressed: ()=>
                              //             setState(() {
                              //               var rmItem = num.parse(_controllerQty[index].text);
                              //               rmItem > 1 ? rmItem-- :rmItem = rmItem;
                              //               _controllerQty[index].text = rmItem.toString();
                              //             }
                              //             ),
                              //           ),
                              //         ),
                              //         Container(
                              //           width: 75,
                              //           height: 40,
                              //           child: TextFormField(
                              //             onChanged: (text) {
                              //               setState(() {
                              //                 // _itemCount = num.parse(text) ;
                              //                 }
                              //               );
                              //             },
                              //             textAlign: TextAlign.center,
                              //             decoration: InputDecoration(
                              //               enabledBorder: UnderlineInputBorder(
                              //                 borderSide: BorderSide(color: Colors.black26, width: 1.2),
                              //               ),
                              //               contentPadding: const EdgeInsets.all(6.0)
                              //               ),
                              //               minLines: 1,
                              //               maxLines: 1,
                              //               //onSaved: (val) => _qty = num.parse(val),
                              //               obscureText: false,
                              //               keyboardType: TextInputType.number,
                              //               controller: _controllerQty[index],
                              //               autocorrect: false,
                              //           ),
                              //         ),
                              //         Container(
                              //           margin: const EdgeInsets.only(top: 5),
                              //           child: IconButton(

                              //             icon: new Icon(Icons.add),
                              //             onPressed: ()=>
                              //             setState((){
                              //               var addItem = num.parse(_controllerQty[index].text);
                              //               addItem++;
                              //               _controllerQty[index].text = addItem.toString();
                              //             })
                              //           ),
                              //         ),// icon-1

                              //         IconSlideAction(
                              //           //caption: 'Đặt món',
                              //           color: Colors.transparent,
                              //           //icon: Icons.delete,
                              //           onTap: () {
                              //             //print(_controllerQty[index].text);
                              //             final snackbar = SnackBar(
                              //               duration: Duration(seconds: 4),
                              //                 content: Row(
                              //                   children: <Widget>[
                              //                     CircularProgressIndicator(),
                              //                     Text("  Đặt món...")
                              //                   ],
                              //                 ),
                              //             );
                              //             _scaffoldKey.currentState.showSnackBar(snackbar);
                              //             _tblDetail.addItem(id, i.id, num.parse(_controllerQty[index].text), i.price).then((result){
                              //               // if (result)
                              //               //   _scaffoldKey.currentState.hideCurrentSnackBar();
                              //               // else
                              //               //   showAlertPopup(context, 'Thông báo', 'Lỗi đặt món');

                              //             });
                              //           },
                              //           iconWidget: Text('Đặt món'),
                              //         ),
                              //       ],
                              //     )
                              //   ],
                              // ),
                            ));
                }).toList(),
                // children: _product.productList.map((i) {
                //   //_controllerQty.add(TextEditingController());
                //   //_controllerQty[i.id] = new TextEditingController() ;
                //   _controllerQty.add(TextEditingController());

                //   count++;
                //   //_controllerQty.add(TextEditingController());
                //   var img = (i.image != "")
                //       ? (apiHomeURL +
                //           '/public/templates/uploads/' +
                //           i.image.toString())
                //       : (apiHomeURL +
                //           '/public/templates/uploads/no_image.jpg');
                //   var checkOrder = (listOrder != null &&
                //           listOrder.length > 0 &&
                //           listOrder.contains(i.id)
                //       ? 1
                //       : 0);
                //   //print(_controllerQty);
                //   return GestureDetector(
                //       //onTap: () => {Navigator.of(context).pushNamed('/product/${i.id}')},
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => ProductDetailPage(
                //               product: i,
                //               tableId: widget.id,
                //             ),
                //           ),
                //         );
                //       },
                //       child: checkOrder == 1
                //           ? new Container(
                //               padding: EdgeInsets.all(6),
                //               //margin: EdgeInsets.all(10),
                //               decoration: BoxDecoration(
                //                 border: Border(
                //                   bottom: BorderSide(
                //                       width: 1.0, color: Colors.black12),
                //                 ),
                //                 //borderRadius: BorderRadius.circular(7),
                //               ),
                //               child: ListTile(
                //                 leading: new Container(
                //                     width: 120.0,
                //                     //height: 80.0,
                //                     decoration: new BoxDecoration(
                //                       boxShadow: [
                //                         BoxShadow(
                //                           color: Colors.grey,
                //                           blurRadius:
                //                               1.0, // has the effect of softening the shadow
                //                           spreadRadius:
                //                               1.0, // has the effect of extending the shadow
                //                           offset: Offset(
                //                             1.0, // horizontal, move right 10
                //                             1.0, // vertical, move down 10
                //                           ),
                //                         )
                //                       ],
                //                       // shape: BoxShape.circle,
                //                       image: new DecorationImage(
                //                         fit: BoxFit.cover,
                //                         image:
                //                             new CachedNetworkImageProvider(
                //                                 img),
                //                       ),
                //                     ),
                //                     child: Stack(children: <Widget>[
                //                       Positioned(
                //                           left: 2.0,
                //                           top: 5.0,
                //                           child: Row(children: <Widget>[
                //                             Icon(Icons.check_circle,
                //                                 color: Color(0xFF09a13b)),
                //                           ]))
                //                     ])),
                //                 //title: Text(i.productName),
                //                 title: TextField(
                //                   //obscureText: true,
                //                   controller: _controllerQty[count],
                //                   decoration: InputDecoration(
                //                     border: OutlineInputBorder(),
                //                     labelText: 'Password',
                //                   ),
                //                 ),
                //                 trailing: TextButton(
                //                   onPressed: () {
                //                     print(_controllerQty[count].text);
                //                   },
                //                   //color: Colors.white,
                //                   child: Text('BUY'),
                //                 ),
                //                 subtitle: Text(i.price
                //                     .toString()
                //                     .replaceAllMapped(
                //                         new RegExp(
                //                             r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                //                         (Match m) => '${m[1]},')),
                //               ),
                //             )
                //           : new Container(
                //               padding: EdgeInsets.all(6),
                //               //margin: EdgeInsets.all(10),
                //               decoration: BoxDecoration(
                //                 border: Border(
                //                   //top: BorderSide(width: 16.0, color: Colors.lightBlue.shade50),
                //                   bottom: BorderSide(
                //                       width: 1.0, color: Colors.black12),
                //                 ),
                //                 //borderRadius: BorderRadius.circular(7),
                //               ),
                //               child: ListTile(
                //                 leading: new Container(
                //                   width: 120.0,
                //                   //height: 80.0,
                //                   decoration: new BoxDecoration(
                //                     //shape: BoxShape.circle,
                //                     image: new DecorationImage(
                //                       fit: BoxFit.cover,
                //                       image: new CachedNetworkImageProvider(
                //                           img),
                //                     ),
                //                   ),
                //                 ),
                //                 //title: Text(i.productName),
                //                 title: TextField(
                //                   //obscureText: true,
                //                   controller: _controllerQty[count],
                //                   decoration: InputDecoration(
                //                     border: OutlineInputBorder(),
                //                     labelText: 'Password',
                //                   ),
                //                 ),
                //                 subtitle: Text(i.price
                //                     .toString()
                //                     .replaceAllMapped(
                //                         new RegExp(
                //                             r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                //                         (Match m) => '${m[1]},')),
                //                 trailing: TextButton(
                //                   onPressed: () {
                //                     print(_controllerQty[count].text);
                //                   },
                //                   //color: Colors.white,
                //                   child: Text('BUY'),
                //                 ),
                //               ),
                //             ));
                // }).toList()
              ))
            : Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Center(child: CircularProgressIndicator()),
              )
            );
  }

  num cartTotal(List<Product> list) {
    num total = 0;
    list.forEach((element) {
      if (element.qty > 0) total += element.qty;
    });
    return total;
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
