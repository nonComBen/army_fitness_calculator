import 'package:flutter/material.dart';

class GridBox extends StatelessWidget {
  const GridBox(
      {Key key,
      this.title = '',
      this.centered = true,
      this.background,
      this.textColor})
      : super(key: key);
  final String title;
  final bool centered;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      child: centered
          ? Center(
              child: Text(
              title,
              style: TextStyle(color: textColor),
            ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: TextStyle(color: textColor)),
            ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black), color: background),
    );
  }
}
