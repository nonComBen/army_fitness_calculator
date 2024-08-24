import 'dart:io';

import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformOutlinedButton extends StatelessWidget {
  factory PlatformOutlinedButton(
      {required Widget child, required VoidCallback onPressed}) {
    if (Platform.isAndroid) {
      return AndroidButton(onPressed: onPressed, child: child);
    } else {
      return IOSButton(onPressed: onPressed, child: child);
    }
  }
}

class AndroidButton extends StatelessWidget implements PlatformOutlinedButton {
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
        backgroundColor: MaterialStateProperty.all<Color>(
            getContrastingBackgroundColor(context)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class IOSButton extends StatelessWidget implements PlatformOutlinedButton {
  const IOSButton({
    required this.child,
    required this.onPressed,
  });
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
