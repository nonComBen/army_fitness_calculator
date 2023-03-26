import 'package:flutter/material.dart';

import '../methods/theme_methods.dart';
import 'grid_box.dart';

class MinMaxTable extends StatelessWidget {
  const MinMaxTable({super.key, required this.headers, required this.values});
  final List<String> headers, values;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final primaryColor = getPrimaryColor(context);
    final onPrimary = getOnPrimaryColor(context);
    return GridView.count(
      crossAxisCount: headers.length,
      childAspectRatio: width / headers.length / 30,
      crossAxisSpacing: 0.0,
      mainAxisSpacing: 0.0,
      shrinkWrap: true,
      primary: false,
      children: <Widget>[
        GridBox(
          title: headers[0],
          background: primaryColor,
          textColor: onPrimary,
          borderTopLeft: 8.0,
        ),
        GridBox(
          title: headers[1],
          background: primaryColor,
          textColor: onPrimary,
        ),
        GridBox(
          title: headers[2],
          background: primaryColor,
          textColor: onPrimary,
          borderTopRight: 8.0,
        ),
        GridBox(
          title: values[0],
          borderBottomLeft: 8.0,
        ),
        GridBox(
          title: values[1],
        ),
        GridBox(
          title: values[2],
          borderBottomRight: 8.0,
        ),
      ],
    );
  }
}
