import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformIconButton extends StatelessWidget {
  factory PlatformIconButton({
    required Icon icon,
    required void Function()? onPressed,
  }) {
    if (Platform.isAndroid) {
      return AndroidIconButton(icon: icon, onPressed: onPressed);
    } else {
      return IOSIconButton(child: icon, onTap: onPressed);
    }
  }
}

class AndroidIconButton extends IconButton implements PlatformIconButton {
  AndroidIconButton({required super.icon, required super.onPressed});
}

class IOSIconButton extends GestureDetector implements PlatformIconButton {
  IOSIconButton({required super.child, required super.onTap});
}
