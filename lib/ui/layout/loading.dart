import 'package:flutter/material.dart';

class MyLoading extends StatefulWidget {
  @override
  _Loading createState() => _Loading();
}

class _Loading extends State<MyLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
