import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformItemPicker extends Widget {
  factory PlatformItemPicker({
    required String label,
    required String value,
    required List<String> items,
    required void Function(dynamic)? onChanged,
    required void Function(int)? onSelectedItemChanged,
  }) {
    if (Platform.isAndroid) {
      return AndroidItemPicker(
          decoration: InputDecoration(
            label: Text(label),
          ),
          value: value,
          items: items
              .map(
                (event) => DropdownMenuItem(
                  child: Text(
                    event,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged);
    } else {
      return IOSItemPicker(
        onSelectedItemChanged: onSelectedItemChanged,
        children: items.map((e) => Text(e)).toList(),
        itemExtent: 32,
      );
    }
  }
}

class AndroidItemPicker extends DropdownButtonFormField
    implements PlatformItemPicker {
  AndroidItemPicker({
    super.items,
    super.value,
    super.onChanged,
    super.decoration,
  });
}

class IOSItemPicker extends CupertinoPicker implements PlatformItemPicker {
  IOSItemPicker({
    required super.children,
    required super.onSelectedItemChanged,
    required super.itemExtent,
  });
}
