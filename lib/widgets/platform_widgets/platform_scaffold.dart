import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformScaffold extends StatelessWidget {
  factory PlatformScaffold({
    String? title,
    List<Widget> actions = const [],
    required Widget body,
  }) {
    if (Platform.isAndroid) {
      return AndroidScaffold(
        title: title,
        actions: actions,
        body: body,
      );
    } else {
      return IOSScaffold(
        title: title,
        actions: actions,
        body: body,
      );
    }
  }
}

class AndroidScaffold extends StatelessWidget implements PlatformScaffold {
  const AndroidScaffold({
    this.title,
    this.actions = const [],
    required this.body,
  });
  final String? title;
  final List<Widget> actions;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
            )
          : null,
      body: body,
    );
  }
}

class IOSScaffold extends StatelessWidget implements PlatformScaffold {
  const IOSScaffold({
    this.title,
    this.actions = const [],
    required this.body,
  });
  final String? title;
  final List<Widget> actions;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: title != null
          ? CupertinoNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              middle: Text(title!),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ),
            )
          : null,
      child: body,
    );
  }
}
