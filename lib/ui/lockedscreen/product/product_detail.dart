
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/classes/product.dart';
import '../../../data/models/product.dart';
import '../../common/api.dart';
import '../table/table.dart';
import '../../widgets/custom_widget.dart';
import '../../../utils/popUp.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage(
      {Key? key,
      this.id = 0,
      this.productName = '',
      required this.product,
      required this.tableId})
      : super(key: key);
  final num id;
  final String productName;
  final Product product;
  final num tableId;
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<bool> isSelected = [];
  num _price = 0, _qty = 1, _discount = 0;
  String _note = '';
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerQty = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  final TextEditingController _controllerDiscount = TextEditingController();
  num _itemCount = 1;
  num _priceChanged = 0;
  String _discountOption = 'vnd';
  @override
  void initState() {
    // TODO: implement initState
    // _controllerPrice = TextEditingController();
    // _controllerQty = TextEditingController();
    // _controllerNote = TextEditingController();
    // _controllerDiscount = TextEditingController();
    super.initState();
    final _product = Provider.of<ProductModel>(context, listen: false);
    var ob = _product.getProduct(widget.product.id);
    _controllerQty.text = _itemCount.toString();
    _controllerDiscount.text = '0';
  }

  @override
  void dispose() {
    // other dispose methods
    _controllerPrice.dispose();
    _controllerQty.dispose();
    _controllerNote.dispose();
    _controllerDiscount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<ProductModel>(context);
    final product = widget.product;
    final tableId = (widget.tableId);
    //_priceChanged = product.price;
    print(tableId);
    print(_discountOption);
    print(widget.product.id);
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          automaticallyImplyLeading: true,
          //   leading: new IconButton(
          //   icon: new Icon(Icons.arrow_back),
          //   onPressed: () {
          //     // Navigator.push(
          //     //   context,
          //     //   new MaterialPageRoute(builder: (context) => new TablePage()),
          //     // );
          //     //Navigator.of(context).popAndPushNamed('/table');
          //   },
          // ),
          centerTitle: true,
          title: Text(
            "Món ăn",
            textScaleFactor: textScaleFactor,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            IconButton(
              iconSize: getDimention(context, 30),
              alignment: Alignment.center,
              padding: EdgeInsets.all(0),
              onPressed: () {
                final form = formKey.currentState!;
                if (form.validate()) {
                  //form.save();
                  final snackbar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Row(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text("  Đặt món...")
                      ],
                    ),
                  );
                  //_scaffoldKey.currentState.showSnackBar(snackbar);
                   ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  _product
                      .orderProduct(
                          widget.tableId,
                          num.parse(product.id.toString()),
                          num.parse(_controllerQty.text),
                          num.parse((product.price * _itemCount - _priceChanged)
                              .toStringAsFixed(1)
                              .toString()),
                          _controllerNote.text.toString())
                      .then((result) {
                    if (result) {
                    } else {
                      //setState(() => this._status = 'rejected');
                      Fluttertoast.showToast(
                        msg: "Lỗi đặt món",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    }
                    //_scaffoldKey.currentState.hideCurrentSnackBar();
                    // Navigator.of(context).pushReplacementNamed('/home');

                    //showAlertPopup(context, 'Thông báo', 'Đặt món thành công');
                    Fluttertoast.showToast(
                        msg: "Đặt món thành công",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //   builder: (context) => ProductDetailPage(product: product, tableId: widget.tableId,),
                    //   ),
                    // );
                    Navigator.of(context).pushReplacementNamed(
                        '/table-detail/' + tableId.toString());
                  });
                }
              },
              icon: Text('Xong',
                  style: TextStyle(
                    fontSize: 17.0,
                  )),
            )
          ],
        ),
        //drawer: AppDrawer(),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          _topDetail(product),
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    ResponsiveGridRow(children: [
                      ResponsiveGridCol(
                        xs: 3,
                        md: 3,
                        child: Container(
                          height: 100,
                          alignment: Alignment(0, 0),
                          //color: Colors.green,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "Giảm giá",
                                style: TextStyle(fontSize: 17.0),
                              )),
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 2,
                        md: 3,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10.0, right: 1),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _discountOption = 'vnd';
                                if (_controllerDiscount.text != '' &&
                                    num.parse(_controllerDiscount.text) <
                                        product.price * _itemCount) {
                                  _priceChanged = num.parse(
                                      num.parse(_controllerDiscount.text)
                                          .toStringAsFixed(1));
                                } else {
                                  _priceChanged = 0;
                                  _controllerDiscount.text = '0';
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: _discountOption == '%'
                                  ? Colors.blue
                                  : Colors.grey, // background
                              onPrimary: Colors.white, // foreground
                              padding: EdgeInsets.symmetric(horizontal: 7.0),
                            ),
                            // padding: EdgeInsets.all(7.0),
                            // color: _discountOption == 'usd'
                            //     ? Colors.blue
                            //     : Colors.grey,
                            // textColor: Colors.white,
                            // disabledColor: Colors.grey,
                            // disabledTextColor: Colors.black,
                            // splashColor: Colors.blueAccent,
                            child: Text(
                              "VND",
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                        ),
                      ),

                      ResponsiveGridCol(
                        xs: 2,
                        md: 3,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _discountOption = '%';
                                _priceChanged = _controllerDiscount.text != ''
                                    ? product.price *
                                        (num.parse(_controllerDiscount.text) /
                                            100)
                                    : 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: _discountOption == '%' ? Colors.blue : Colors.grey, // background
                              onPrimary: Colors.white, // foreground
                              padding: EdgeInsets.symmetric(horizontal: 7.0),
                            ),
                            // padding: EdgeInsets.all(7.0),
                            // color: _discountOption == '%'
                            //     ? Colors.blue
                            //     : Colors.grey,
                            // textColor: Colors.white,
                            // disabledColor: Colors.grey,
                            // disabledTextColor: Colors.black,
                            //splashColor: Colors.blueAccent,
                            child: Text(
                              "%",
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 5,
                        md: 3,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            onChanged: (text) {
                              setState(() {
                                var numValue = num.tryParse(text) ?? 0;
                                if (_controllerDiscount.text == '') {
                                  //_controllerDiscount.text = '0';
                                  _priceChanged = 0;
                                }
                                if (_discountOption.toString() == '%') {
                                  if (numValue != 0 && numValue > 100) {
                                    _controllerDiscount.text = '0';
                                    _priceChanged = 0;
                                  }
                                  _priceChanged =
                                      product.price * (numValue / 100);
                                } else if (_discountOption.toString() ==
                                    'vnd') {
                                  if (numValue != 0 &&
                                      numValue > (product.price * _itemCount)) {
                                    _controllerDiscount.text = '0';
                                    _priceChanged = 0;
                                  }
                                  _priceChanged = numValue;
                                }
                                _priceChanged =
                                    _priceChanged > product.price * _itemCount
                                        ? 0
                                        : _priceChanged;
                              });
                            },
                            validator: (val) {
                              
                              var numValue = num.tryParse(val ?? '0') != null
                                  ? num.tryParse(val ?? '0')
                                  : 0;

                              if (_discountOption.toString() == '%') {
                                if (numValue != null &&  numValue > 100) {
                                  // _controllerDiscount.text = '0';
                                  // _priceChanged = 0;
                                  return 'Giá giảm > 100% ';
                                }
                                //_priceChanged = product.price*(numValue/100);
                              } else if (_discountOption.toString() == 'vnd') {
                                if (numValue != null &&
                                    numValue > (product.price * _itemCount)) {
                                  // _controllerDiscount.text = '0';
                                  // _priceChanged = 0;
                                  return 'Giá giảm vượt quá giá SP';
                                }
                                _priceChanged = numValue ?? 0;
                              }
                              return null;
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              //hintText: 'Ghi chú',
                              //fillColor: Colors.white, filled: true,
                              // focusedBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.blue, width: 1.2),
                              // ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.black26, width: 1.2),
                              // ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 1.2),
                              ),
                              // focusedBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.green)
                              // ),
                            ),
                            minLines: 1,
                            maxLines: 1,
                            //onSaved: (val) => _discount = num.parse(val) != null ?  num.parse(val) : 0,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            controller: _controllerDiscount,
                            autocorrect: false,
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 7,
                        md: 3,
                        child: Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Số lượng",
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            )),
                      ),

                      ResponsiveGridCol(
                          xs: 5,
                          md: 3,
                          child: Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            // spacing: 5,
                            // runSpacing: 5,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: IconButton(
                                  icon: new Icon(Icons.remove),
                                  onPressed: () => setState(() {
                                    _itemCount > 1
                                        ? _itemCount--
                                        : _itemCount = _itemCount;
                                    _controllerQty.text = _itemCount.toString();
                                    //_priceChanged = num.parse(text);
                                  }),
                                ),
                              ),
                              Container(
                                width: 75,
                                height: 40,
                                child: TextFormField(
                                  onChanged: (text) {
                                    setState(() {
                                      _itemCount = num.parse(text);
                                    });
                                  },
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black26, width: 1.2),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.all(6.0)),
                                  minLines: 1,
                                  maxLines: 1,
                                  onSaved: (val) => _qty = num.parse(val ?? '1'),
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  controller: _controllerQty,
                                  autocorrect: false,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () => setState(() {
                                          _itemCount++;
                                          _controllerQty.text =
                                              _itemCount.toString();
                                        })),
                              )
                            ],
                          )),
                      ResponsiveGridCol(
                        xs: 7,
                        md: 3,
                        child: Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 20.0, bottom: 20),
                            child: Text(
                              "Thành tiền",
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            )),
                      ),
                      //_showPrice(_product, _itemCount),
                      ResponsiveGridCol(
                          xs: 5,
                          md: 3,
                          child: Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              (product.price * _itemCount - _priceChanged)
                                  .toStringAsFixed(1)
                                  .toString(),
                              textAlign: TextAlign.right,
                            ),
                          )),
                    ]),
                  ],
                ),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ghi chú',
                      //border: InputBorder.,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 1.2),
                      ),
                    ),
                    //validator: (val) => val.length < 1 ? 'Username Required' : null,
                    onSaved: (val) => _note = val.toString(),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    controller: _controllerNote,
                    autocorrect: false,
                    minLines: 4,
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          ),
        ]
                // )

                )));
  }

  Widget _topDetail(Product _product) {
    if (_product != null) {
      var img = (_product.image != null)
          ? (apiHomeURL +
              'public/templates/uploads/' +
              _product.image.toString())
          : (apiHomeURL + 'public/templates/uploads/no_image.jpg');
      return ListView(shrinkWrap: true, children: <Widget>[
        Container(
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
            title: Text(_product.productName),
            subtitle: Text(_product.price.toString().replaceAllMapped(
                new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},')),
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
          ),
        )
      ]);
    } else {
      return Container(
        //height: MediaQuery.of(context).size.height / 2,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _showPrice(ProductModel _product, num x) {
    if (_product.productObject != null) {
      var price = _product.productObject.price * x;
      return ResponsiveGridCol(
          xs: 5,
          md: 3,
          child: Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: Text(
              price.toString(),
              textAlign: TextAlign.right,
            ),
          ));
    } else {
      return ResponsiveGridCol(
          xs: 5,
          md: 3,
          child: Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: Text(
              '0',
              textAlign: TextAlign.right,
            ),
          ));
    }
  }
}
