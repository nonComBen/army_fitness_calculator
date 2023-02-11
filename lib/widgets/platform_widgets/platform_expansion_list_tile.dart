import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformExpansionTile extends Widget {
  factory PlatformExpansionTile({
    required Widget title,
    Widget? trailing,
    Widget? leading,
    bool initiallyExpanded = false,
    Color? collapsedBackgroundColor,
    Color? collapsedTextColor,
    Color? collapsedIconColor,
    Color? textColor,
    required List<Widget> children,
  }) {
    if (Platform.isAndroid) {
      return AndroidExpansionTile(
        title: title,
        trailing: trailing,
        leading: leading,
        initiallyExpanded: initiallyExpanded,
        collapsedBackgroundColor: collapsedBackgroundColor,
        collapsedIconColor: collapsedIconColor,
        collapsedTextColor: collapsedTextColor,
        textColor: textColor,
        children: children,
      );
    } else {
      return IOSExpansionTile(
        title: title,
        leading: leading,
        trailing: trailing,
        initiallyExpanded: initiallyExpanded,
        children: children,
      );
    }
  }
}

class AndroidExpansionTile extends ExpansionTile
    implements PlatformExpansionTile {
  AndroidExpansionTile({
    required super.title,
    super.trailing,
    super.leading,
    super.initiallyExpanded,
    super.collapsedBackgroundColor,
    super.collapsedTextColor,
    super.collapsedIconColor,
    super.textColor,
    required super.children,
  });
}

class IOSExpansionTile extends StatefulWidget implements PlatformExpansionTile {
  IOSExpansionTile({
    required this.title,
    this.trailing,
    this.leading,
    this.initiallyExpanded = false,
    this.collapsedBackgroundColor,
    required this.children,
  });
  final Widget title;
  final Widget? trailing;
  final Widget? leading;
  final bool initiallyExpanded;
  final Color? collapsedBackgroundColor;
  final List<Widget> children;

  @override
  State<IOSExpansionTile> createState() => _IOSExpansionTileState();
}

class _IOSExpansionTileState extends State<IOSExpansionTile> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoListTile(
          title: widget.title,
          leading: widget.leading,
          trailing: widget.trailing,
          backgroundColor: !isExpanded ? widget.collapsedBackgroundColor : null,
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          Container(
            child: Column(children: widget.children),
          )
      ],
    );
  }
}
