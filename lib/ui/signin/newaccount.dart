import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../../utils/popUp.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  String _username = '', _password = '';

  final formKey = GlobalKey<FormState>();
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  initState() {
    // _controllerUsername = TextEditingController();
    // _controllerPassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Create Account",
          textScaleFactor: textScaleFactor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          key: const PageStorageKey("Divider 1"),
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        //val.length < 1 ? 'Username Required' : null,
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tài khoản';
                        }
                        return null;
                      },
                      onSaved: (val) => _username = val ?? "",
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _controllerUsername,
                      autocorrect: false,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        //val.length < 1 ? 'Password Required' : null,
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        return null;
                      },
                      onSaved: (val) => _password = val ?? '',
                      obscureText: true,
                      controller: _controllerPassword,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  // fixedSize: Size(250, 50),
                ),
                onPressed: () async {
                  final form = formKey.currentState!;
                  if (form.validate()) {
                    //form.save();
                    //_scaffoldKey.currentState.showSnackBar(snackbar);

                    auth
                        .login(
                      _username.toString().toLowerCase().trim(),
                      _password.toString().trim(),
                    )
                        .then((result) async {
                      if (result) {
                        //_scaffoldKey.currentState.showSnackBar(snackbar);

                        await Future.delayed(const Duration(seconds: 3));
                        //_scaffoldKey.currentState.hideCurrentSnackBar();
                        Navigator.pop(context, true);
                      } else {
                        //_scaffoldKey.currentState.hideCurrentSnackBar();
                        showAlertPopup(context, 'Info', auth.errorMessage);
                      }
                    });
                  }
                },
                child: const Text(
                  'Save',
                  textScaleFactor: textScaleFactor,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
