import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformListTile extends Widget {
  factory PlatformListTile({
    required Widget title,
    Widget? subtitle,
    Widget? leading,
    Widget? trailing,
    void Function()? onTap,
  }) {
    if (Platform.isAndroid) {
      return AndroidListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
      );
    } else {
      return IOSListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
      );
    }
  }
}

class AndroidListTile extends ListTile implements PlatformListTile {
  AndroidListTile({
    super.title,
    super.subtitle,
    super.leading,
    super.trailing,
    super.onTap,
  });
}

class IOSListTile extends CupertinoListTile implements PlatformListTile {
  IOSListTile({
    required super.title,
    super.subtitle,
    super.leading,
    super.trailing,
    super.onTap,
  });
}
