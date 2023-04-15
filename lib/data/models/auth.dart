import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../classes/user.dart';

class AuthModel extends ChangeNotifier {
  String errorMessage = "";

  bool _rememberMe = false;
  bool _stayLoggedIn = true;
  bool _useBio = false;
  late User _user;

  bool get rememberMe => _rememberMe;

  void handleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", value);
    });
  }

  bool get isBioSetup => _useBio;

  void handleIsBioSetup(bool value) {
    _useBio = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("use_bio", value);
    });
  }

  bool get stayLoggedIn => _stayLoggedIn;

  void handleStayLoggedIn(bool value) {
    _stayLoggedIn = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("stay_logged_in", value);
    });
  }

  void loadSettings() async {
    var _prefs = await SharedPreferences.getInstance();
    try {
      _useBio = _prefs.getBool("use_bio") ?? false;
    } catch (e) {
      print(e);
      _useBio = false;
    }
    try {
      _rememberMe = _prefs.getBool("remember_me") ?? false;
    } catch (e) {
      print(e);
      _rememberMe = false;
    }
    try {
      _stayLoggedIn = _prefs.getBool("stay_logged_in") ?? false;
    } catch (e) {
      print(e);
      _stayLoggedIn = false;
    }

    if (_stayLoggedIn) {
      User _savedUser;
      try {
        final _saved = _prefs.getString("user_data") ?? "";
        print("Saved: $_saved");
        _savedUser = User.fromJson(json.decode(_saved));
      } catch (e) {
        print("User Not Found: $e");
      }
      // if (!kIsWeb && _useBio) {
      //   if (await biometrics()) {
      //     _user = _savedUser;
      //   }
      // } else {
      //   _user = _savedUser;
      // }
    }
    notifyListeners();
  }

  // Future<bool> biometrics() async {
  //   final LocalAuthentication auth = LocalAuthentication();
  //   bool authenticated = false;
  //   try {
  //     authenticated = await auth.authenticateWithBiometrics(
  //         localizedReason: 'Scan your fingerprint to authenticate',
  //         useErrorDialogs: true,
  //         stickyAuth: false);
  //   } catch (e) {
  //     print(e);
  //   }
  //   return authenticated;
  // }

  User get user => _user;

  Future getInfo(String token, String username, String password) async {
    try {
      var _data = await http.get(Uri.parse(apiUserURL));
      var _companyData = await http.get(
          Uri.parse(apiURL + '/authentication/company?username=$username'));
      print(json.decode(_companyData.body)["data"]);
      //var _newUser = User.fromJson(json.decode(_data.body)["data"]);
      //_newUser.username = username;
      //_newUser.companyId = json.decode(_companyData.body)["data"];
      //print(_newUser);
      // return _newUser;
    } catch (e) {
      print("Could Not Load Data: $e");
      return null;
    }
  }

  Future<bool> login(String username, String password) async {
    var uuid = new Uuid();
    String _username = username;
    String _password = password;
    var _newUser;
    print(username);
    print(password);
    // TODO: API LOGIN CODE HERE
    await Future.delayed(Duration(seconds: 3));
    try {
      var url = apiURL + '/authentication/';
      var _data = await http.post(Uri.parse(url),
          body: {'email': username, 'password': password});
      // http.Response _data = await http.post(
      //   url,
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(
      //       <String, dynamic>{'email': username, 'password': password}),
      // );
      print(json.decode(_data.body)['data']);
      if (json.decode(_data.body)['status'] == false) {
        errorMessage = json.decode(_data.body)['message'];
        return false;
      }
      print(json.decode(_data.body)["data"]['company_id']);
      var _newUser = User.fromJson(json.decode(_data.body)["data"]);
      _newUser.username = username;
      _newUser.companyId = json.decode(_data.body)["data"]['company_id'];
      if (_newUser.id != 0) {
        _user = _newUser;
        notifyListeners();

        SharedPreferences.getInstance().then((prefs) {
          var _save = json.encode(_user.toJson());
          print("Data: $_save");
          prefs.setString("user_data", _save);
        });
      }
    } catch (e) {
      errorMessage = "Lỗi gọi API";
      print("Could Not Load Data: $e");
      return false;
    }
    if (_rememberMe) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString("saved_username", _username);
        prefs.setString("saved_password", password);
      });
    }

    // Get Info For User
    // User _newUser = await getInfo(uuid.v4().toString(), username, password);
    

    return true;
  }

  Future<void> logout() async {
    //_user = null;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("user_data", '');
    });
    return;
  }
}
