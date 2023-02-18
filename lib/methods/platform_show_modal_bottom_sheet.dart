import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showPlatformModalBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  if (Platform.isAndroid) {
    showModalBottomSheet(
      context: context,
      builder: builder,
    );
  } else {
    showCupertinoModalPopup(
      context: context,
      builder: builder,
    );
  }
}
