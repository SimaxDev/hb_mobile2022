import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// hiện thông báo
Future<void> showAlertDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Thông báo'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message ==  null ? "" :message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();

            },
          ),
        ],
      );
    },
  );
}
// hiển thị loading
Future<void> showLoading(BuildContext context) async {
  return showDialog<void>(
    context: context,
   // barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return CircularProgressIndicator();
    },
  );
}
