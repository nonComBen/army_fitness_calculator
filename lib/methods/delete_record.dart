import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteRecord {
  static void deleteRecord({BuildContext context, Function onConfirm}) {
    final title = const Text('Delete Record');
    final content = Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Are you sure you want to delete this record?'),
          ),
        ],
      ),
    );
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context2) => CupertinoAlertDialog(
                title: title,
                content: content,
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context2);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Yes'),
                    onPressed: onConfirm,
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context2) {
            return AlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context2);
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: onConfirm,
                )
              ],
            );
          });
    }
  }
}
