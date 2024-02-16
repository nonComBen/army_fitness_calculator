import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformButton extends StatelessWidget {
  factory PlatformButton(
      {required Widget child, required VoidCallback onPressed}) {
    if (Platform.isAndroid) {
      return AndroidButton(onPressed: onPressed, child: child);
    } else {
      return IOSButton(onPressed: onPressed, child: child);
    }
  }
}

class AndroidButton extends StatelessWidget implements PlatformButton {
  const AndroidButton({
    required this.child,
    required this.onPressed,
  });
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class IOSButton extends StatelessWidget implements PlatformButton {
  const IOSButton({
    required this.child,
    required this.onPressed,
  });
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
      borderRadius: BorderRadius.circular(25),
      onPressed: onPressed,
      child: child,
    );
  }
}
