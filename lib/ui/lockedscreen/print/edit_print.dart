import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/confirm_order.dart';
import '../../../data/models/table_detail.dart';
import '../../common/api.dart';
import '../confirm_order.dart';
import 'print.dart';
import '../table/table_view.dart';
import '../../widgets/custom_widget.dart';
import '../../../utils/popUp.dart';
import 'package:provider/provider.dart';
// import 'package:dropdown_formfield/dropdown_formfield.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';

class EditPrintPage extends StatefulWidget {
  EditPrintPage({required this.tableId});
  final num tableId;
  @override
  _EditPrintPageState createState() => _EditPrintPageState();
}

class _EditPrintPageState extends State<EditPrintPage> {
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  String _myActivity = '';
  String _myActivityResult = '';
  //final PrinterNetworkManager printerManager = PrinterNetworkManager();
  @override
  void initState() {
    // TODO: implement initState
    final _printOrder = Provider.of<ConfirmOrderModel>(context, listen: false);
    _printOrder.fetchPrintByTable(widget.tableId);
    super.initState();
    _myActivity = 'Running';
    _myActivityResult = '';
  }

  @override
  Widget build(BuildContext context) {
    final _printOrder = Provider.of<ConfirmOrderModel>(context);
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
                    builder: (context) => PrintPage(
                      tableId: widget.tableId,
                    ),
                  ),
                );
              }),
          centerTitle: true,
          title: Text(
            'Chỉnh sửa báo bếp',
            textAlign: TextAlign.center,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
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
                    //_scaffoldKey.currentState.showSnackBar(snackbar);
                    //(printerManager);
                    //_scaffoldKey.currentState.hideCurrentSnackBar();
                    // _tblDetail.removeTempOrder(widget.id).then((result){
                    //     if (result) {}
                    //     else {
                    //         //setState(() => this._status = 'rejected');
                    //         showAlertPopup(context, 'Thông báo', 'Lỗi');
                    //       }
                    //       _scaffoldKey.currentState.hideCurrentSnackBar();
                    //       showAlertPopup(context, 'Thông báo', 'Hủy món thành công');
                    //       setState(() {
                    //         //listOrder = List();
                    //       });
                    //       //Navigator.of(context).pushReplacementNamed('/table-detail/' + tableId.toString());
                    // });
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
            ],
          ),
        ),
        body: _printOrder.productListPrint != null
            ? SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  Column(
                      verticalDirection: VerticalDirection.down,
                      children: _printOrder.productListPrint.map((i) {
                        TextDecoration style = i.status == 2
                            ? TextDecoration.lineThrough
                            : TextDecoration.none;
                        return GestureDetector(
                            onTap: () {
                              showAlertDialog(
                                  context, widget.tableId, i.id, i.qty);
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
                  //  Column(
                  //    children: <Widget>[
                  //     Container(
                  //       padding: EdgeInsets.all(16),
                  //       child: DropDownFormField(
                  //         titleText: 'Chọn lịch sử',
                  //         hintText: 'Please choose one',
                  //         value: _myActivity,
                  //         onSaved: (value) {
                  //           setState(() {
                  //             _myActivity = value;
                  //           });
                  //         },
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _myActivity = value;
                  //             print(value);
                  //           });
                  //         },
                  //         dataSource: [
                  //           {
                  //             "display": "Running",
                  //             "value": "Running",
                  //           },
                  //           {
                  //             "display": "Climbing",
                  //             "value": "Climbing",
                  //           },
                  //           {
                  //             "display": "Walking",
                  //             "value": "Walking",
                  //           },
                  //           {
                  //             "display": "Swimming",
                  //             "value": "Swimming",
                  //           },
                  //           {
                  //             "display": "Soccer Practice",
                  //             "value": "Soccer Practice",
                  //           },
                  //           {
                  //             "display": "Baseball Practice",
                  //             "value": "Baseball Practice",
                  //           },
                  //           {
                  //             "display": "Football Practice",
                  //             "value": "Football Practice",
                  //           },
                  //         ],
                  //         textField: 'display',
                  //         valueField: 'value',
                  //       ),
                  //     )

                  //    ],
                  //  ),
                ],
              ))
            : Container(
                height: 0,
              ));
  }

  showAlertDialog(BuildContext context, num tableId, num productId, num qty) {
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
        //_scaffoldKey.currentState.showSnackBar(snackbar);
        _removeProduct
            .removeProductPrint(tableId, productId, qty)
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
  // void printNotify(PrinterNetworkManager printerManager) async{
  //   final PrinterNetworkManager printerManager = PrinterNetworkManager();
  //   // To discover network printers in your subnet, consider using
  //   // ping_discover_network package (https://pub.dev/packages/ping_discover_network).
  //   // Note that most of ESC/POS printers are available on port 9100 by default.
  //   printerManager.selectPrinter('192.168.1.100', port: 9100);

  //   final PosPrintResult res =
  //       await printerManager.printTicket(await testTicket());
  //   print('Print result: ${res.msg}');
  // }
  // void testTicket() async {
  //   final Ticket ticket = Ticket(PaperSize.mm80);

  //   ticket.text(
  //       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  //   ticket.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
  //       styles: PosStyles(codeTable: PosCodeTable.westEur));
  //   ticket.text('Special 2: blåbærgrød',
  //       styles: PosStyles(codeTable: PosCodeTable.westEur));

  //   ticket.text('Bold text', styles: PosStyles(bold: true));
  //   ticket.text('Reverse text', styles: PosStyles(reverse: true));
  //   ticket.text('Underlined text',
  //       styles: PosStyles(underline: true), linesAfter: 1);
  //   ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
  //   ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
  //   ticket.text('Align right',
  //       styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  //   ticket.row([
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col6',
  //       width: 6,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //   ]);

  //   ticket.text('Text size 200%',
  //       styles: PosStyles(
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ));

  //   // Print image
  //   // final ByteData data = await rootBundle.load('assets/logo.png');
  //   // final Uint8List bytes = data.buffer.asUint8List();
  //   // final Image image = decodeImage(bytes);
  //   // ticket.image(image);
  //   // Print image using alternative commands
  //   // ticket.imageRaster(image);
  //   // ticket.imageRaster(image, imageFn: PosImageFn.graphics);

  //   // Print barcode
  //   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
  //   ticket.barcode(Barcode.upcA(barData));

  //   // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
  //   // ticket.text(
  //   //   'hello ! 中文字 # world @ éphémère &',
  //   //   styles: PosStyles(codeTable: PosCodeTable.westEur),
  //   //   containsChinese: true,
  //   // );

  //   ticket.feed(2);

  //   ticket.cut();
  //   return ticket;
  // }
}
