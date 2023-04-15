import 'package:flutter/material.dart';

void showAlertPopup(BuildContext context, String title, String detail) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(detail),
        actions: <Widget>[
          // TextButton(
          //   onPressed: () => Navigator.pop(context, 'Cancel'),
          //   child: const Text('Cancel'),
          // ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
}
