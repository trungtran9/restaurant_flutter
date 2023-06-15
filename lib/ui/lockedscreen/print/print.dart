import 'dart:typed_data';

// import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/data/classes/option.dart';
import 'package:flutter_login/data/classes/print.dart';
import 'package:flutter_login/data/classes/select_print.dart';
import 'package:flutter_login/data/models/confirm_order.dart';
import 'package:flutter_login/data/models/print.dart';
import 'package:flutter_login/data/models/table_detail.dart';
import 'package:flutter_login/ui/common/api.dart';
import 'package:flutter_login/ui/lockedscreen/confirm_order.dart';
import 'package:flutter_login/ui/lockedscreen/print/edit_print.dart';
import 'package:flutter_login/ui/lockedscreen/table/table_view.dart';
import 'package:flutter_login/utils/popUp.dart';
import 'package:provider/provider.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:convert';
import 'package:charset_converter/charset_converter.dart';
import 'package:tiengviet/tiengviet.dart';
// import 'package:ping_discover_network/ping_discover_network.dart';
// import 'package:wifi/wifi.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';

class PrintPage extends StatefulWidget {
  PrintPage({required this.tableId, required this.companyId, this.tableName,  this.areaName});
  final num tableId;
  final num companyId;
  final String? tableName;
  final String? areaName;
  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  //final PrinterNetworkManager printerManager = PrinterNetworkManager();
  String _myActivity = '0';
  String _myActivityResult = '';
  List<Print> _newPrintList = [];
  List<Print> _checkPrint = [];
  List<SelectPrint> _selectPrint = [];
  List<String> devices = [];
  bool isDiscovering = false;
  String choosePrint = '';
  int found = -1;
  bool isHistory = false;
  final List<String> items = [];
  String? selectedValue;
  String? selectedValuePrint;
  @override
  void initState() {
    // TODO: implement initState
    final _printOrder = Provider.of<ConfirmOrderModel>(context, listen: false);
    _printOrder.fetchPrintByTable(widget.tableId);
    _printOrder.getPrint(widget.companyId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _printOrder = Provider.of<ConfirmOrderModel>(context);
    print('_printOrder.productIncludePrint');
    print(countOrder((_printOrder.getNotify)));
    _selectPrint = (_printOrder.printList);
   
    
    if(_selectPrint.length > 0) {
      _selectPrint.forEach((element) async {
      
      if(!items.contains(element.printName))
        items.add(element.printName);
      });
    }
    
    print(items);
    var _productToPrint = _printOrder.productIncludePrint;
    if (_productToPrint != null) {
      // final _finalProductToPrint = _productToPrint.values.toList();
      // //List list= _productToPrint.map((array)=>array['name']).toList();
      // print(_finalProductToPrint);
      // _productToPrint.forEach((k, v) {
      //   print('${k}: ${v}');
      // });
    }

    // Create a new instance of the printer
    // printerManager = PrinterNetworkManager();
    
    
    // // Connect to the printer
    // printerManager.selectPrinter(printer);
    // printerManager.connect();
    
    // // Print the text
    // printer.text('Hello World');
    
    // // Cut the paper and disconnect from the printer
    // printer.cut();
    // printer.disconnect();

    if (_printOrder.productListPrint != null)
      _checkPrint = _printOrder.productListPrint
          .where((item) => item.status == 0)
          .toList();
    //print(_checkPrint.length != 0 && isHistory == false);
    if (_printOrder.productListPrint != null && !isHistory)
      _newPrintList = _printOrder.productListPrint
          .where((item) => item.status == 0)
          .toList();
    final _print = Provider.of<PrintModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TableViewPage(
                    tableId: widget.tableId,
                  ),
                ),
              );
            }),
        centerTitle: true,
        title: Text(
          'In báo bếp',
          textAlign: TextAlign.center,
        ),
         actions: <Widget>[

            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  customButton: const Icon(
                    Icons.print,
                    size: 32,
                    color: Colors.white,
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as String;
                      
                      print(selectedValue);
                      _selectPrint.forEach((element) async {
      
                      if(selectedValue == (element.printName))
                        choosePrint = (element.ip);
                      });
                      print(choosePrint);
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 160,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.redAccent,
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.yellow,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 200,
                    padding: null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.redAccent,
                    ),
                    elevation: 8,
                    offset: const Offset(-20, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ),
          ],
      ),
      bottomNavigationBar: _printOrder.productListPrint != null &&
              _checkPrint.length != 0 &&
              _productToPrint != null &&
              isHistory == false
          ? BottomAppBar(
              color: Colors.lightBlueAccent,
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              Text("  In báo bếp...")
                            ],
                          ),
                        );
                        
                        printD();
                        
                        //_scaffoldKey.currentState.showSnackBar(snackbar);

                        // printNotify(
                        //     printerManager, _newPrintList, widget.tableId);
                        // printNotifyWithIp(
                        //     printerManager, widget.tableId, _productToPrint);
                        //_scaffoldKey.currentState.hideCurrentSnackBar();
                      },
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Icon(
                            Icons.print,
                            color: Color(0xFFFFFFFF),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: new Text(
                              'Báo bếp',
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
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
                  //           builder: (context) => EditPrintPage(tableId: widget.tableId, companyId: widget.tableId),
                  //         ),
                  //       );
                  //     },
                  //     child: new Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: <Widget>[
                  //         new Icon(Icons.edit, color: Color(0xFFFFFFFF),),
                  //         Padding(
                  //           padding: EdgeInsets.only(left: 5),
                  //           child: new Text('Báo bếp sửa món', style: TextStyle(color: Color(0xFFFFFFFF)),),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )
          : isHistory == true
              ? BottomAppBar(
                  color: Colors.lightBlueAccent,
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.all(12),
                        child: new InkResponse(
                          onTap: () {
                            _newPrintList = _printOrder.productListPrint
                                .where((item) =>
                                    item.printCount == num.parse(_myActivity))
                                .toList();
                            // printHistoryNotifyWithIp(
                            //     printerManager,
                            //     widget.tableId,
                            //     _productToPrint,
                            //     num.parse(_myActivity));
                            printD();
                          },
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Icon(
                                Icons.print,
                                color: Color(0xFFFFFFFF),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: new Text(
                                  'Báo bếp sửa món',
                                  style: TextStyle(color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  height: 0,
                ),
      body: _newPrintList != null
          ? SingleChildScrollView(
              child: Column(
              children: <Widget>[
                Column(
                    verticalDirection: VerticalDirection.down,
                    children: _newPrintList.map((i) {
                      TextDecoration style = i.status == 2
                          ? TextDecoration.lineThrough
                          : TextDecoration.none;
                      return GestureDetector(
                          onTap: () {
                            num.parse(_myActivity) != 0
                                ? showAlertDialog(
                                    context, widget.tableId, i.id, i.qty)
                                : showAlertDialog(
                                    context, widget.tableId, i.id, i.qty,
                                    printCount: num.parse(_myActivity));
                          },
                          child: new Container(
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
                            child: ListTile(
                              title: Text(
                                AppAPI.capitalize(
                                    i.productName.toString().toLowerCase()),
                                style: TextStyle(decoration: style),
                              ),
                              trailing: i.status != 2
                                  ? Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 32,
                                    )
                                  : Text(''),
                              subtitle: Row(
                                //alignment: Alignment.center,
                                children: <Widget>[
                                  Text(
                                    " Số lượng: " + i.qty.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        decoration: style),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }).toList()),
                _printOrder.getNotify != 0
                    ? Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16),
                            child:Center(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Text(
                                    'Chọn lịch sử',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: countOrder((_printOrder.getNotify))
                                          .map((item) => DropdownMenuItem<String>(
                                    value:  (item + 1).toString(),
                                    child: Text(
                                      'Chọn món lần ' + (item + 1).toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                                          .toList(),
                                  value: selectedValuePrint,
                                  onChanged: (value) {

                                    setState(() {

                                    _myActivity = value ?? '0'; 

                                    selectedValuePrint = _myActivity;

                                      _newPrintList = _printOrder.productListPrint
                                          .where((item) =>
                                              item.printCount == num.parse(_myActivity))
                                          .toList();
                                      if (num.parse(_myActivity) != 0)
                                        isHistory = true;
                                      else
                                        isHistory = false;
                                      print(isHistory);
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 40,
                                    width: 140,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                            ),
                            // child: DropDownFormField(
                            //   titleText: 'Chọn lịch sử',
                            //   hintText: 'Chỉnh sửa gọi món',
                            //   value: _myActivity,
                            //   onSaved: (value) {
                            //     setState(() {
                            //       _myActivity = value;
                            //     });
                            //   },
                            //   onChanged: (value) {
                            //     setState(() {
                            //       _myActivity = value;
                            //       print('56');
                            //       _newPrintList = _printOrder.productListPrint
                            //           .where((item) =>
                            //               item.printCount == num.parse(value))
                            //           .toList();
                            //       if (num.parse(value) != 0)
                            //         isHistory = true;
                            //       else
                            //         isHistory = false;
                            //       print(isHistory);
                            //     });
                            //   },
                            //   dataSource: showOption(_printOrder.getNotify),
                            //   textField: 'display',
                            //   valueField: 'value',
                            // ),
                          )
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Container(
                            height: 0,
                          ),
                          // TextButton(
                          //   style: ButtonStyle(
                          //     foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          //   ),
                          //   onPressed: () { 
                          //     //printD(); 
                          //     Printing.layoutPdf(
                          //       // [onLayout] will be called multiple times
                          //       // when the user changes the printer or printer settings
                          //       onLayout: (PdfPageFormat format) {
                          //         // Any valid Pdf document can be returned here as a list of int
                          //         return buildPdf(format);
                          //       },
                          //     );
                          //   },
                          //   child: Text('TextButton'),
                          // ),
                        ],
                      ),
              ],
            ))
          : _printOrder.getNotify != 0
              ? Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child:Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: Text(
                                'Chọn lịch sử gọi món',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: countOrder(_printOrder.getNotify)
                                      .map((item) => DropdownMenuItem<String>(
                                value:  (item + 1).toString(),
                                child: Text(
                                  'Chọn món lần ' + (item + 1).toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                                      .toList(),
                              value: selectedValuePrint,
                              onChanged: (value) {
                                // setState(() {
                                //   selectedValuePrint = value as String;
                                // });
                                
                                setState(() {
                                  // selectedValuePrint = value as String ?? '0';
                                  // if(selectedValuePrint != '0')
                                  
                                  //     _myActivity = selectedValuePrint;
                                  // else
                                  //   _myActivity = '0';
                                   _myActivity = value ?? '0'; 
                                   selectedValuePrint = _myActivity;
                                  _newPrintList = _printOrder.productListPrint
                                      .where((item) =>
                                          item.printCount == num.parse(_myActivity))
                                      .toList();
                                  if (num.parse(_myActivity) != 0)
                                    isHistory = true;
                                  else
                                    isHistory = false;
                                  print(isHistory);
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 40,
                                width: 140,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ),

                      // child: DropDownFormField(
                      //   titleText: 'Chọn lịch sử',
                      //   hintText: 'Chỉnh sửa gọi món',
                      //   value: _myActivity,
                      //   onSaved: (value) {
                      //     setState(() {
                      //       _myActivity = value;
                      //     });
                      //   },
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _myActivity = value;
                      //       print('456');
                      //       _newPrintList = _printOrder.productListPrint
                      //           .where((item) =>
                      //               item.printCount == num.parse(value))
                      //           .toList();
                      //       print(_newPrintList);
                      //       if (num.parse(value) != 0)
                      //         isHistory = true;
                      //       else
                      //         isHistory = false;
                      //       print(isHistory);
                      //     });
                      //   },
                      //   dataSource: showOption(_printOrder.getNotify),
                      //   textField: 'display',
                      //   valueField: 'value',
                      // ),
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                   
                    Container(
                      height: 0,
                    ),
                  ],
                ),
    );
  }

  showAlertDialog(BuildContext context, num tableId, num productId, num qty, {num? printCount}) {
    final _removeProduct =
        Provider.of<ConfirmOrderModel>(context, listen: false);
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
        //launchMissile();
      },
    );
    Widget continueButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        final snackbar = SnackBar(
          duration: Duration(seconds: 4),
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("  Xóa món...")
            ],
          ),
        );
       // _scaffoldKey.currentState.showSnackBar(snackbar);
        if (num.parse(_myActivity) != 0)
          _removeProduct
              .removeProductPrint(tableId, productId, qty,
                  printCount: num.parse(_myActivity))
              .then((result) {
            if (result) {
              //_scaffoldKey.currentState.hideCurrentSnackBar();
              showAlertPopup(context, 'Thông báo', 'Xóa món thành công');
            } else {
              showAlertPopup(context, 'Thông báo', 'Lỗi');
            }
          });
        else
          _removeProduct
              .removeProductPrint(
            tableId,
            productId,
            qty,
          )
              .then((result) {
            if (result) {
              //_scaffoldKey.currentState.hideCurrentSnackBar();
              showAlertPopup(context, 'Thông báo', 'Xóa món thành công');
            } else {
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

  void printD() async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    print(printer);
    try{
    final PosPrintResult res = await printer.connect('192.168.1.12', port: 9100);
    print(res);
    if (res == PosPrintResult.success) {
      testReceipt(printer);
     printer.disconnect();
    } 
     testReceipt(printer);
    }
     catch (e) {    
        print(e);
        // do stuff
    }  
    // final String ip = await Wifi.ip;
    // final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    // final int port = 80;
    
    // final stream = NetworkAnalyzer.discover2(subnet, port);
    // stream.listen((NetworkAddress addr) {
    //   if (addr.exists) {
    //     print('Found device: ${addr.ip}');
    //   }
    // });
    
    // print('Print result: ${res.msg}');
   
  }

  

  
  void testReceipt(NetworkPrinter printer) {
    printer.text(
          'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));
  
    printer.text('Bold text', styles: PosStyles(bold: true));
    printer.text('Reverse text', styles: PosStyles(reverse: true));
    printer.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    printer.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);
  
    printer.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
  
    printer.feed(2);
    printer.cut();
  }

  // void printNotifyWithIp(PrinterNetworkManager printerManager, num tableId,
  //     var printProduct) async {
  //   //ip = ip != null ? ip : '192.168.1.100';
  //   // To discover network printers in your subnet, consider using
  //   // ping_discover_network package (https://pub.dev/packages/ping_discover_network).
  //   // Note that most of ESC/POS printers are available on port 9100 by default.

  //   final snackbar = SnackBar(
  //     duration: Duration(seconds: 4),
  //     content: Row(
  //       children: <Widget>[
  //         CircularProgressIndicator(),
  //         Text("  In báo bếp...")
  //       ],
  //     ),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackbar);

  //   if (printProduct != null) {
  //     // print('f-------------------------------');
  //     // print(printProduct);
  //     // print('f-------------------------------');

  //     printProduct.forEach((key, value) async {
  //       final PrinterNetworkManager printerManager = PrinterNetworkManager();
  //       final _print = Provider.of<PrintModel>(context, listen: false);
  //       print(key);
  //       printerManager.selectPrinter(key, port: 9100);
  //       Iterable printOb = value.map((model) => Print.fromJson(model)).toList();
  //       List<Print> printProducts =
  //           (value as List).map((model) => Print.fromJson(model)).toList();
  //       // print(value);
  //       // print(printProducts);
  //       printProducts =
  //           printProducts.where((item) => item.status == 0).toList();
  //       print(printProducts);
  //       final PosPrintResult res =
  //           await printerManager.printTicket(await printTicket(printProducts));
  //       print('Print result: ${res.msg}');
  //       if (res.msg.contains('Error'))
  //         showAlertPopup(context, 'Thông báo',
  //             'Lỗi kết nối máy in, hãy thử lại 1 lần nữa');
  //       else {
  //         _print.printOrder(tableId, 0).then((result) {
  //           if (result) {
  //             showAlertPopup(context, 'Thông báo', 'Đã báo bếp');
  //             Navigator.of(context).pushReplacementNamed('/table');
  //           } else
  //             showAlertPopup(
  //                 context, 'Thông báo', 'Lỗi báo bếp, vui lòng thử lại');
  //         });
  //       }
  //     });
  //   }

  //   //_scaffoldKey.currentState.hideCurrentSnackBar();
  // }

  // void printNotify(PrinterNetworkManager printerManager,
  //     List<Print> productPrint, num tableId) async {
  //   final PrinterNetworkManager printerManager = PrinterNetworkManager();
  //   final _print = Provider.of<PrintModel>(context, listen: false);
  //   // To discover network printers in your subnet, consider using
  //   // ping_discover_network package (https://pub.dev/packages/ping_discover_network).
  //   // Note that most of ESC/POS printers are available on port 9100 by default.
  //   printerManager.selectPrinter('192.168.1.100', port: 9100);
  //   final snackbar = SnackBar(
  //     duration: Duration(seconds: 4),
  //     content: Row(
  //       children: <Widget>[
  //         CircularProgressIndicator(),
  //         Text("  In báo bếp...")
  //       ],
  //     ),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackbar);
  //   final PosPrintResult res =
  //       await printerManager.printTicket(await printTicket(productPrint));
  //   print('Print result: ${res.msg}');
  //   if (res.msg.contains('Error'))
  //     showAlertPopup(
  //         context, 'Thông báo', 'Lỗi kết nối máy in, hãy thử lại 1 lần nữa');
  //   else {
  //     _print.printOrder(tableId).then((result) {
  //       if (result) {
  //         showAlertPopup(context, 'Thông báo', 'Đã báo bếp');
  //         Navigator.of(context).pushReplacementNamed('/table');
  //       } else
  //         showAlertPopup(context, 'Thông báo', 'Lỗi báo bếp, vui lòng thử lại');
  //     });
  //   }
  //   _scaffoldKey.currentState.hideCurrentSnackBar();
  // }

  // void printHistoryNotify(PrinterNetworkManager printerManager,
  //     List<Print> productPrint, num tableId) async {
  //   final PrinterNetworkManager printerManager = PrinterNetworkManager();
  //   final _print = Provider.of<PrintModel>(context, listen: false);
  //   // To discover network printers in your subnet, consider using
  //   // ping_discover_network package (https://pub.dev/packages/ping_discover_network).
  //   // Note that most of ESC/POS printers are available on port 9100 by default.

  //   printerManager.selectPrinter('192.168.1.100', port: 9100);
  //   final snackbar = SnackBar(
  //     duration: Duration(seconds: 4),
  //     content: Row(
  //       children: <Widget>[
  //         CircularProgressIndicator(),
  //         Text("  In báo bếp...")
  //       ],
  //     ),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackbar);
  //   final PosPrintResult res =
  //       await printerManager.printTicket(await printTicket(productPrint));
  //   print('Print result: ${res.msg}');
  //   if (res.msg.contains('Error'))
  //     showAlertPopup(
  //         context, 'Thông báo', 'Lỗi kết nối máy in, hãy thử lại 1 lần nữa');
  //   else {
  //     showAlertPopup(context, 'Thông báo', 'Đã báo bếp');
  //     Navigator.of(context).pushReplacementNamed('/table');
  //   }
  //   //_scaffoldKey.currentState.hideCurrentSnackBar();
  // }

  // void printHistoryNotifyWithIp(PrinterNetworkManager printerManager,
  //     num tableId, var printProduct, history) async {
  //   //ip = ip != null ? ip : '192.168.1.100';
  //   // To discover network printers in your subnet, consider using
  //   // ping_discover_network package (https://pub.dev/packages/ping_discover_network).
  //   // Note that most of ESC/POS printers are available on port 9100 by default.

  //   final snackbar = SnackBar(
  //     duration: Duration(seconds: 4),
  //     content: Row(
  //       children: <Widget>[
  //         CircularProgressIndicator(),
  //         Text("  In báo bếp...")
  //       ],
  //     ),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackbar);

  //   if (printProduct != null) {
  //     printProduct.forEach((key, value) async {
  //       final PrinterNetworkManager printerManager = PrinterNetworkManager();
  //       final _print = Provider.of<PrintModel>(context, listen: false);
  //       print(key);
  //       printerManager.selectPrinter(key, port: 9100);
  //       Iterable printOb = value.map((model) => Print.fromJson(model)).toList();
  //       List<Print> printProducts =
  //           (value as List).map((model) => Print.fromJson(model)).toList();
  //       // print(value);
  //       // print(printProducts);
  //       printProducts =
  //           printProducts.where((item) => item.printCount == history).toList();
  //       print(printProducts);
  //       final PosPrintResult res =
  //           await printerManager.printTicket(await printTicket(printProducts));
  //       print('Print result: ${res.msg}');
  //       if (res.msg.contains('Error'))
  //         showAlertPopup(context, 'Thông báo',
  //             'Lỗi kết nối máy in, hãy thử lại 1 lần nữa');
  //       else {
  //         _print.printOrder(tableId, 1).then((result) {
  //           if (result) {
  //             showAlertPopup(context, 'Thông báo', 'Đã báo bếp');
  //             Navigator.of(context).pushReplacementNamed('/table');
  //           } else
  //             showAlertPopup(
  //                 context, 'Thông báo', 'Lỗi báo bếp, vui lòng thử lại');
  //         });
  //       }
  //     });
  //   }

  //   //_scaffoldKey.currentState.hideCurrentSnackBar();
  // }

  // void printTicket(List<Print> productPrint) async {
  //   final Ticket ticket = Ticket(PaperSize.mm80);
  //   print(productPrint);
  //   var title = 'Báo Bếp - ' + widget.tableName;

  //   // print(tiengviet('Xin chào việt nam'));
  //   // Uint8List  encVn =
  //   // await CharsetConverter.encode("ISO-8859-1", title);
  //   // ticket.textEncoded(encVn, styles: PosStyles(bold: true, align: PosAlign.center, codeTable: PosCodeTable.vietnam));
  //   ticket.text('Bao Bep - ' + tiengviet(widget.tableName),
  //       styles: PosStyles(
  //           bold: true,
  //           align: PosAlign.center,
  //           height: PosTextSize.size2,
  //           width: PosTextSize.size2),
  //       linesAfter: 1);
  //   if (widget.areaName != '')
  //     ticket.text('Khu Vuc - ' + tiengviet(widget.areaName),
  //         styles: PosStyles(
  //           bold: true,
  //           align: PosAlign.center,
  //         ),
  //         linesAfter: 1);
  //   ticket.row([
  //     PosColumn(
  //       text: 'STT',
  //       width: 2,
  //       styles: PosStyles(align: PosAlign.right),
  //     ),
  //     PosColumn(
  //       text: 'TEN MON',
  //       width: 8,
  //       styles: PosStyles(align: PosAlign.right),
  //     ),
  //     PosColumn(
  //       text: 'SL',
  //       width: 2,
  //       styles: PosStyles(
  //         align: PosAlign.right,
  //         underline: true,
  //       ),
  //     ),
  //   ]);
  //   ticket.hr();
  //   var i = 0;
  //   productPrint.forEach((element) {
  //     if (element.status == 2)
  //       ticket.row([
  //         PosColumn(
  //           text: (++i).toString() + '.',
  //           width: 2,
  //           styles: PosStyles(align: PosAlign.right),
  //         ),
  //         PosColumn(
  //           text: tiengviet(element.productName),
  //           width: 8,
  //           styles: PosStyles(align: PosAlign.right),
  //         ),
  //         PosColumn(
  //           text: 'HUY',
  //           width: 2,
  //           styles: PosStyles(align: PosAlign.right),
  //         ),
  //       ]);
  //     else
  //       ticket.row([
  //         PosColumn(
  //           text: (++i).toString() + '.',
  //           width: 2,
  //           styles: PosStyles(align: PosAlign.right),
  //         ),
  //         PosColumn(
  //           text: tiengviet(element.productName),
  //           width: 8,
  //           styles: PosStyles(align: PosAlign.right),
  //         ),
  //         PosColumn(
  //           text: element.qty.toString(),
  //           width: 2,
  //           styles: PosStyles(align: PosAlign.right),
  //         ),
  //       ]);
  //   });

  //   ticket.feed(2);

  //   ticket.cut();
  //   return ticket;
  // }

// show option
List<dynamic> showOption(num numberOption) {
    //List<OptionSelect> options;
    var options = [];
    OptionSelect ob = OptionSelect(value: '0', display: 'Chỉnh sửa gọi món');
    options.add(ob.toJson());
    if (numberOption != 0)
      for (var i = 0; i < numberOption; i++) {
        OptionSelect ob = OptionSelect(
            value: (i + 1).toString(),
            display: 'Chọn món lần ' + (i + 1).toString());
        options.add(ob.toJson());
      }
    return (options);
  }
}

// show new option
List<dynamic> countOrder(num numberOption) {
    var options = [];
    //options.add(0);
    if (numberOption != 0)
      for (var i = 0; i < numberOption; i++) {
        options.add(i);
      }
    return (options);
}
