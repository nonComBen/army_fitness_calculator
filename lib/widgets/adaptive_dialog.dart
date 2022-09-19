import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog(
      {Key key, this.title, this.content, this.affirmTitle, this.onAffirm})
      : super(key: key);
  final Widget title;
  final Widget content;
  final String affirmTitle;
  final Function onAffirm;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              onAffirm();
            },
            child: Text(affirmTitle),
          )
        ],
      );
    } else {
      return AlertDialog(
        title: title,
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onAffirm();
            },
            child: Text(affirmTitle),
          )
        ],
      );
    }
  }
}
