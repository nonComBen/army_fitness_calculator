import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color getPrimaryColor(BuildContext context) {
  if (Platform.isAndroid) {
    return Theme.of(context).colorScheme.primary;
  } else {
    return CupertinoTheme.of(context).primaryColor;
  }
}

Color getOnPrimaryColor(BuildContext context) {
  if (Platform.isAndroid) {
    return Theme.of(context).colorScheme.onPrimary;
  } else {
    return CupertinoTheme.of(context).primaryContrastingColor;
  }
}

Color getBackgroundColor(BuildContext context) {
  if (Platform.isAndroid) {
    return Theme.of(context).scaffoldBackgroundColor;
  } else {
    return CupertinoTheme.of(context).scaffoldBackgroundColor;
  }
}
