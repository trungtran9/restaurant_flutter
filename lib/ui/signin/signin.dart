import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../data/models/auth.dart';
import '../../utils/popUp.dart';
import 'newaccount.dart';
// import 'forgot.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.username = ''});

  final String username;

  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _status = 'no-action';
  String _username = '';
  String _password = '';

  // Initially password is obscure
  bool _obscureText = true;

  final formKey = GlobalKey<FormState>();
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controllerUsername = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();

  @override
  initState() {
    // _controllerUsername = TextEditingController();
    // _controllerPassword = TextEditingController();
    _loadUsername();
    super.initState();
    print(_status);
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _loadUsername() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _username = _prefs.getString("saved_username") ?? "";
      var _password = _prefs.getString("saved_password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      if (_remeberMe) {
        _controllerUsername.text = _username;
        _controllerPassword.text = _password;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          key: PageStorageKey("Divider 1"),
          children: <Widget>[
            // SizedBox(
            //   height: 220.0,
            //   child: Padding(
            //       padding: EdgeInsets.all(16.0),
            //       child: Icon(
            //         Icons.person,
            //         size: 175.0,
            //       )),
            // ),
            SizedBox(
              height: 220,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.asset(
                  "assets/images/logo2.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tài khoản';
                        }
                        return null;
                      },
                      onSaved: (value) => _username = value ?? '',
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _controllerUsername,
                      autocorrect: false,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        return null;
                      },
                      // onSaved: (val) => _password = val ?? '',
                      obscureText: _obscureText,
                      controller: _controllerPassword,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
            ),
            // ListTile(
            //   title: Text(
            //     'Remember Me',
            //     textScaleFactor: textScaleFactor,
            //   ),
            //   trailing: Switch.adaptive(
            //     onChanged: _auth.handleRememberMe,
            //     value: _auth.rememberMe,
            //   ),
            // ),
            Container(
              // padding: const EdgeInsets.all(20),
              margin: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        // padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              onChanged: _auth.handleRememberMe,
                              value: _auth.rememberMe,
                            ),
                            const Text(
                              'Duy trì đăng nhập',
                              style: TextStyle(
                                // color: Colors.black,
                                // fontWeight: FontWeight.w800,
                                // fontFamily: 'Roboto',
                                // letterSpacing: 0.5,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // const TextSpan(
                      //   text: 'Hello world!',
                      //   style: TextStyle(color: Colors.black),
                      // )
                      // TextSpan(
                      //   text: 'but this is',
                      //   style: new TextStyle(color: Colors.blue),
                      //   recognizer: new TapGestureRecognizer()
                      //     ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                      //   },
                      // ),
                      GestureDetector(
                        child: Text(
                          'Quên mật khẩu ?',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        onTap: () {
                          print('Text was tapped!');
                          // launch('https://flutter.dev/');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.only(left: 0.0, right: 8.0),
                        child: MaterialButton(
                          onPressed: () {
                            final form = formKey.currentState!;
                            if (form.validate()) {
                              //form.save();
                              final snackBar = SnackBar(
                                //duration: Duration(seconds: 30),
                                content: Row(
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    Text("  Logging In...")
                                  ],
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              setState(() => this._status = 'loading');
                              _auth
                                  .login(
                                _controllerUsername.text
                                    .toString()
                                    .toLowerCase()
                                    .trim(),
                                _controllerPassword.text.toString().trim(),
                              )
                                  .then((result) {
                                print(result);

                                if (result) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home');
                                } else {
                                  setState(() => this._status = 'rejected');
                                  showAlertPopup(
                                      context, 'Thông báo', _auth.errorMessage);
                                }
                                // if (!globals.isBioSetup) {
                                //   setState(() {
                                //     print('Bio No Longer Setup');
                                //   });
                                // }
                              });
                            }
                          },
                          color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.signal_cellular_alt_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Quản lý",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.only(left: 8.0, right: 0.0),
                        child: MaterialButton(
                          // minWidth: double.infinity,
                          onPressed: () {},
                          color: Colors.green,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Bán hàng",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            ListTile(
                // title: TextButton(
                //   child: Text(
                //     'Đăng nhập',
                //     textScaleFactor: textScaleFactor,
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.blue,
                //     // fixedSize: Size(250, 50),
                //   ),
                //   //color: Colors.blue,
                //   onPressed: () {
                //     final form = formKey.currentState!;
                //     if (form.validate()) {
                //       //form.save();
                //       final snackBar = SnackBar(
                //         //duration: Duration(seconds: 30),
                //         content: Row(
                //           children: <Widget>[
                //             CircularProgressIndicator(),
                //             Text("  Logging In...")
                //           ],
                //         ),
                //       );
                //       ScaffoldMessenger.of(context).showSnackBar(snackBar);

                //       setState(() => this._status = 'loading');
                //       _auth
                //           .login(
                //         _controllerUsername.text.toString().toLowerCase().trim(),
                //         _controllerPassword.text.toString().trim(),
                //       )
                //           .then((result) {
                //         print(result);

                //         if (result) {
                //           Navigator.of(context).pushReplacementNamed('/home');
                //         } else {
                //           setState(() => this._status = 'rejected');
                //           showAlertPopup(
                //               context, 'Thông báo', _auth.errorMessage);
                //         }
                //         // if (!globals.isBioSetup) {
                //         //   setState(() {
                //         //     print('Bio No Longer Setup');
                //         //   });
                //         // }
                //       });
                //     }
                //   },
                // ),
                // trailing: !globals.isBioSetup
                //     ? null
                //     : NativeButton(
                //         child: Icon(
                //           Icons.fingerprint,
                //           color: Colors.white,
                //         ),
                //         color: Colors.redAccent[400],
                //         onPressed: globals.isBioSetup
                //             ? loginWithBio
                //             : () {
                //                 globals.Utility.showAlertPopup(context, 'Info',
                //                     "Please Enable in Settings after you Login");
                //               },
                //       ),
                ),
            // FlatButton(
            //   child: Text(
            //     'Need an Account?',
            //     textScaleFactor: textScaleFactor,
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => CreateAccount(),
            //           fullscreenDialog: true),
            //     ).then((success) => success
            //         ? showAlertPopup(
            //             context, 'Info', "New Account Created, Login Now.")
            //         : null);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
