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
import 'package:badges/badges.dart' as badges;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../data/classes/category.dart' as cat;
import '../../../data/models/category.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  num _itemCount = 0;
  var index = 0;
  late ScrollController _scrollController;
  // List<TextEditingController> _controllerQty = [];
  //final SlidableController slidableController = SlidableController();
  late TabController _controllerTab;
  int _page = 1;
  final int _limit = 10;

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = true;
  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  final List<TextEditingController> _controllerQty = [];
  // final List<int> _itemCount = [];

  @override
  void initState() {
    super.initState();
    final _tblDetail = Provider.of<TableDetailModel>(context, listen: false);
    _tblDetail.fetchProductsByTable(widget.id);
    _tblDetail.getTotalCart(widget.id);
    final _product = Provider.of<ProductModel>(context, listen: false);
    _product.fetchProducts();
    final _categories = Provider.of<CategoryModel>(context, listen: false);
    _categories.fetchCategories();

    _tblDetail.getOrderTempByTableId(widget.id);
    //listOrder = _tblDetail.productOrderList;
    final _confirmProduct =
        Provider.of<ConfirmOrderModel>(context, listen: false);
    _confirmProduct.fetchOrderByTable(widget.id);
    _scrollController = ScrollController();
    _loadVarriable();
  }

  createControllers(products) {
    for (var i = 0; i < products.length; i++) {
      _controllerQty.add(TextEditingController());
      //_itemCount.add(i);
    }
  }

  void _loadVarriable() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();

      _prefs.setInt('tableId', int.parse(widget.id.toString()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final _tblDetail = Provider.of<TableDetailModel>(context);
    final _product = Provider.of<ProductModel>(context);

    createControllers(_product.productList);

    final _confirmProduct = Provider.of<ConfirmOrderModel>(context);
    final _categories = Provider.of<CategoryModel>(context);
    var _allCategories = _categories.categoryList;
    num totals = _tblDetail.totalCart;
    int count = 0;

    Iterable lProducts = [];
    _allCategories.insert(0, new cat.Category(id: 0, name: 'Tất cả'));

    listOrder = _tblDetail.productOrderList;
    return Scaffold(
        key: _scaffoldKey,
        //resizeToAvoidBottomPadding: false,
        // appBar: new AppBar(
        //   //automaticallyImplyLeading: true,
        //   leading: new IconButton(
        //     icon: new Icon(Icons.arrow_back),
        //     onPressed: () {
        //       //Navigator.of(context).popAndPushNamed('/table');
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => TableViewPage(
        //             tableId: id,
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        //   centerTitle: true,
        //   title: Text(
        //     "Chọn món vào đơn",
        //     textScaleFactor: textScaleFactor,
        //     textAlign: TextAlign.center,
        //   ),
        //   actions: <Widget>[
        //     //_rightTopSearchIcon(id)
        //     IconButton(
        //       onPressed: () {
        //         // method to show the search bar
        //         showSearch(
        //           context: context,
        //           // delegate to customize the search bar
        //           delegate: CustomSearchDelegate(id: id),
        //           //query: id.toString()
        //         );
        //       },
        //       icon: const Icon(Icons.search),
        //     )
        //   ],
        // ),
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
                          //ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          _tblDetail.removeTempOrder(widget.id).then((result) {
                            if (result) {
                               setState(() {
                                listOrder = [];
                                totals = 0;
                              });
                            } else {
                              //showAlertPopup(context, 'Thông báo', 'Lỗi');
                              Fluttertoast.showToast(
                                  msg: "Lỗi",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                           
                            // showAlertPopup(
                            //     context, 'Thông báo', 'Hủy món thành công');
                            Fluttertoast.showToast(
                                  msg: "Hủy món thành công",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
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
                            badges.Badge(
                              
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
        // body: _product.productList.isNotEmpty
        //     ? _renderTableView(_product.productList, listOrder)

        //     : Container(
        //         height: MediaQuery.of(context).size.height / 2,
        //         child: Center(child: CircularProgressIndicator()),
        //       )
        body: DefaultTabController(
          //initialIndex: 1,
          length: _allCategories.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Chọn món vào đơn",
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
                      delegate: CustomSearchDelegate(id: id),
                      //query: id.toString()
                    );
                  },
                  icon: const Icon(Icons.search),
                )
              ],
              bottom: new TabBar(
                // tabs: [
                //   new Tab(icon: new Icon(Icons.directions_car)),
                //   new Tab(icon: new Icon(Icons.directions_transit)),
                //   new Tab(icon: new Icon(Icons.directions_bike)),
                // ],
                // controller: _controllerTab,
                isScrollable: true,
                tabs: List<Widget>.generate(_allCategories.length, (int index) {
                  return new Tab(
                    //icon: Icon(Icons.android),
                    text: _allCategories[index].name.toString(),
                    // child: SizedBox(
                    //   height: 100, // <-- match_parent
                    //   child: TextButton(
                    //     style: TextButton.styleFrom(
                    //       //primary: Colors.blue,
                    //     ),
                    //     onPressed: () { print(_allCategories[index].id); },
                    //     child: Text(
                    //       _allCategories[index].name.toString(),
                    //       style: TextStyle(color: Colors.white),

                    //     ),
                    //   ),
                    // ),
                  );
                }),
                indicatorColor: Colors.white,
              ),
              // const TabBar(
              //   tabs: <Widget>[
              //     Tab(
              //       icon: Icon(Icons.cloud_outlined),
              //     ),
              //     Tab(
              //       icon: Icon(Icons.beach_access_sharp),
              //     ),
              //     Tab(
              //       icon: Icon(Icons.brightness_5_sharp),
              //     ),
              //   ],
              // ),
            ),
            body: _allCategories.length != 0
                ? new TabBarView(
                    //controller: _controllerTab,
                    children: List<Widget>.generate(_allCategories.length,
                        (int index) {
                      // print( '_product.productList.length');
                      // print( _product.productList.length);
                      //return Text(_allCategories[index].id.toString());

                      if (_allCategories[index].id == 0)
                        lProducts = _product.productList;
                      else {
                        if (_product.productList.length != 0)
                          lProducts = _product.productList
                              .where((item) =>
                                  item.categoryId == _allCategories[index].id)
                              .toList();
                      }

                      return _renderTableView(
                          lProducts, listOrder, _allCategories[index].id);
                      //return _tableListRender(_allArea[index].id);
                    }),
                  )
                : new TabBarView(
                    children: [
                      //new Icon(Icons.directions_car,size: 50.0,),
                      //new Icon(Icons.directions_transit,size: 50.0,),
                      Container(
                          height: 100,
                          margin: const EdgeInsets.all(10.0),
                          child: Center(child: CircularProgressIndicator())),
                    ],
                  ),

            // const TabBarView(
            //   children: <Widget>[
            //     Center(
            //       child: Text("It's cloudy here"),
            //     ),
            //     Center(
            //       child: Text("It's rainy here"),
            //     ),
            //     Center(
            //       child: Text("It's sunny here"),
            //     ),
            //   ],
            // ),
          ),
        ));
  }

  num cartTotal(List<Product> list) {
    num total = 0;
    list.forEach((element) {
      if (element.qty > 0) total += element.qty;
    });
    return total;
  }

  Widget _renderTableView(products, listOrder, categoryId) {
    final _tblDetail = Provider.of<TableDetailModel>(context, listen: false);
    if (products.length != 0) {
      // if(categoryId == 0) {
      // }
      // else {
      //   products =  products.where((item) => item.categoryId == categoryId).toList();
      // }
        
        return ListView.builder(
          //controller: _scrollController,
          itemCount: products.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            var product = products[index];
            var img = (product.image != "" || product.image != null)
                ? (apiHomeURL +
                    'public/templates/uploads/' +
                    product.image.toString())
                : (apiHomeURL + 'public/templates/uploads/no_image.jpg');
  
            var checkOrder = (listOrder != null &&
                    listOrder.length > 0 &&
                    listOrder.contains(product.id)
                ? 1
                : 0);
            return GestureDetector(
                //onTap: () => {Navigator.of(context).pushNamed('/product/${i.id}')},
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        product: product,
                        tableId: widget.id,
                      ),
                      //borderRadius: BorderRadius.circular(7),
                    ),
                    //child: Slidable(

                    child: ListTile(
                      leading: new Container(
                          width: 120.0,
                          //height: 80.0,
                          decoration: new BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius:
                                    1.0, // has the effect of softening the shadow
                                spreadRadius:
                                    1.0, // has the effect of extending the shadow
                                offset: Offset(
                                  1.0, // horizontal, move right 10
                                  1.0, // vertical, move down 10
                                ),
                              )
                            ],
                            // shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(img),
                            ),
                          ),
                          child: Stack(children: <Widget>[
                            Positioned(
                                left: 2.0,
                                top: 5.0,
                                child: Row(children: <Widget>[
                                  Icon(Icons.check_circle,
                                      color: Color(0xFF09a13b)),
                                ]))
                          ])),
                      title: Text(product.productName),
                      subtitle: Text(product.price.toString().replaceAllMapped(
                          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},')),
                    ),

                    // )
                  )
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: Stack(
                      children: [
                        Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                    0.2,
                                  ),
                                  spreadRadius: 3.0,
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  //color: Colors.green,
                                  height: 50,
                                  width: 100,
                                  child: Text(
                                    '${product.productName}\n',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  //color: Colors.green,
                                  height: 20,
                                  width: 100,
                                  child: Text(
                                    '\$${product.price.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}\n',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(
                              15,
                            ),
                          ),
                          child: Container(
                            height: 120,
                            width: 120,
                            color: Colors.orange,
                            child: Image.network(
                              img,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 100,
                          child: Container(
                            child: IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () {
                                // cubit.adding(widget.product);setState(() {
                                _itemCount++;
                                _controllerQty[index].text =
                                    _itemCount.toString();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 25,
                          right: 40,
                          child: Container(
                            height: 30,
                            width: 68,
                            child: TextField(
                              //obscureText: true,
                              controller: _controllerQty[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Số lượng',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 0,
                          child: Container(
                            child: IconButton(
                              onPressed: () {
                                //setState(() {
                                _itemCount > 1
                                    ? _itemCount--
                                    : _itemCount = _itemCount;
                                _controllerQty[index].text =
                                    _itemCount.toString();
                              },
                              icon: const Icon(
                                Icons.remove_circle,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 20,
                            bottom: 10,
                            child: Container(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey.shade900),
                                  onPressed: () {
                                    //saveData(index);
                                    print( _controllerQty[index].text);
                                    print( product.id);

                                      final snackbar = SnackBar(
                                        duration: Duration(seconds: 4),
                                          content: Row(
                                            children: <Widget>[
                                              CircularProgressIndicator(),
                                              Text("  Đặt món...")
                                            ],
                                          ),
                                      );
                                      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                      _tblDetail.addItem(widget.id, product.id, num.parse(_controllerQty[index].text), product.price).then((result){
                                        if (result)
                                          // showAlertPopup(context, 'Thông báo', 'Đặt món thành công');
                                          Fluttertoast.showToast(
                                              msg: "Đặt món thành công",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        else
                                          showAlertPopup(context, 'Thông báo', 'Lỗi đặt món');

                                      });
                                  },
                                  child: const Text('Thêm món')),
                            ))
                      ],
                    ),
                  ),
            // new Card(
            //color: Colors.blueGrey.shade200,
            // elevation: 5.0,
            // child: Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     mainAxisSize: MainAxisSize.max,
            //     children: [
            //       Image(
            //         height: 80,
            //         width: 80,
            //         image: NetworkImage(img),
            //       ),
            //       // Container(
            //       //   width: 80,
            //       //   height: 80.0,
            //       //   decoration: new BoxDecoration(
            //       //     //shape: BoxShape.circle,
            //       //     image: new DecorationImage(
            //       //       fit: BoxFit.cover,
            //       //       image: NetworkImage(img),
            //       //     ),
            //       //   ),
            //       // ),
            //       SizedBox(
            //         width: 160,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const SizedBox(
            //               height: 5.0,
            //             ),
            //             RichText(
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 1,
            //               text: TextSpan(
            //                   text: 'Name: ',
            //                   style: TextStyle(
            //                       color: Colors.blueGrey.shade800,
            //                       fontSize: 16.0),
            //                   children: [
            //                     TextSpan(
            //                         text: '${product.productName}\n',
            //                         style: const TextStyle(
            //                             fontWeight: FontWeight.bold)),
            //                   ]),
            //             ),
            //             // TextField(
            //             //   //obscureText: true,
            //             //   controller: _controllerQty[index],
            //             //   decoration: InputDecoration(
            //             //     border: OutlineInputBorder(),
            //             //     labelText: 'Số lượng',
            //             //   ),
            //             //   style: TextStyle(color: Colors.black),
            //             // ),
            //             RichText(
            //               maxLines: 1,
            //               text: TextSpan(
            //                   text: 'Price: ' r"",
            //                   style: TextStyle(
            //                       color: Colors.blueGrey.shade800,
            //                       fontSize: 16.0),
            //                   children: [
            //                     TextSpan(
            //                         text:
            //                             '${product.price.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}\n',
            //                         style: const TextStyle(
            //                             fontWeight: FontWeight.bold)),
            //                   ]),
            //             ),
            //           ],
            //         ),
            //       ),
            //       ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //               primary: Colors.blueGrey.shade900),
            //           onPressed: () {
            //             //saveData(index);
            //             print(_controllerQty[index].text);
            //             print(product.id);

            //             final snackbar = SnackBar(
            //               duration: Duration(seconds: 4),
            //               content: Row(
            //                 children: <Widget>[
            //                   CircularProgressIndicator(),
            //                   Text("  Đặt món...")
            //                 ],
            //               ),
            //             );
            //             ScaffoldMessenger.of(context)
            //                 .showSnackBar(snackbar);
            //             _tblDetail
            //                 .addItem(
            //                     widget.id,
            //                     product.id,
            //                     num.parse(_controllerQty[index].text),
            //                     product.price)
            //                 .then((result) {
            //               if (result)
            //                 showAlertPopup(context, 'Thông báo',
            //                     'Đặt món thành công');
            //               else
            //                 showAlertPopup(
            //                     context, 'Thông báo', 'Lỗi đặt món');
            //             });
            //           },
            //           child: const Text('Thêm món')),
            //     ],
            //   ),
            // ),
            // )
            // new Container(
            //     padding: EdgeInsets.all(6),
            //     //margin: EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       border: Border(
            //         //top: BorderSide(width: 16.0, color: Colors.lightBlue.shade50),
            //         bottom: BorderSide(width: 1.0, color: Colors.black12),
            //       ),
            //       //borderRadius: BorderRadius.circular(7),
            //     ),
            //     //child: Slidable(

            //     child: ListTile(
            //       leading: new Container(
            //         width: 120.0,
            //         //height: 80.0,
            //         decoration: new BoxDecoration(
            //           //shape: BoxShape.circle,
            //           image: new DecorationImage(
            //             fit: BoxFit.cover,
            //             image: NetworkImage(img),
            //           ),
            //         ),
            //       ),
            //       // title: Text(i.productName),
            //       title: TextField(
            //         //obscureText: true,
            //         //controller: _controllerQty[++index],
            //         decoration: InputDecoration(
            //           border: OutlineInputBorder(),
            //           labelText: 'Số lượng',
            //         ),
            //       ),
            //       subtitle: Text(product.price
            //           .toString()
            //           .replaceAllMapped(
            //               new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            //               (Match m) => '${m[1]},')),
            //     ),

            //     //),
            //   )
          );
        },
      );
    }
    return Container(
      child: Center(
        child: Text("không có món ăn nào", style: TextStyle(fontSize: 25)),
      ),
    );
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
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
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

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    final _product = Provider.of<ProductModel>(context);

    List<Product> matchQuery = [];
    for (var p in _product.productList) {
      if (p.productName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(p);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.productName),
          onTap: () {
            //Go to the next screen with Navigator.push
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  product: result,
                  tableId: id,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
