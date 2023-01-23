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
          fixedSize: MaterialStateProperty.all<Size>(
            const Size(100, 40),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: onPressed,
        child: child);
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
        borderRadius: BorderRadius.circular(25),
        onPressed: onPressed,
        child: child);
  }
}
