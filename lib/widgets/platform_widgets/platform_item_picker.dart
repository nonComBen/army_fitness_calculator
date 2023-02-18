import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

abstract class PlatformItemPicker extends Widget {
  factory PlatformItemPicker({
    required Widget label,
    required String value,
    required List<String> items,
    required void Function(dynamic) onChanged,
  }) {
    if (Platform.isAndroid) {
      return AndroidItemPicker(
          decoration: InputDecoration(
            label: label,
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
        itemBuilder: (context) {
          return items
              .map((e) => PullDownMenuItem(onTap: () => onChanged(e), title: e))
              .toList();
        },
        buttonBuilder: (context, showMenu) {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: label,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0)),
                child: CupertinoButton(
                  padding: EdgeInsets.all(8.0),
                  onPressed: showMenu,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        },
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

class IOSItemPicker extends PullDownButton implements PlatformItemPicker {
  IOSItemPicker({required super.itemBuilder, required super.buttonBuilder});
}
