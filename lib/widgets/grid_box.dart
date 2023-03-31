import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:flutter/material.dart';

class GridBox extends StatelessWidget {
  const GridBox({
    Key? key,
    this.title = '',
    this.isTotal = false,
    this.width,
    this.height,
    this.background,
    this.textColor,
    this.borderBottomLeft = 0.0,
    this.borderBottomRight = 0.0,
    this.borderTopLeft = 0.0,
    this.borderTopRight = 0.0,
  }) : super(key: key);
  final String title;
  final bool isTotal;
  final double? width;
  final double? height;
  final Color? background;
  final Color? textColor;
  final double borderTopLeft;
  final double borderTopRight;
  final double borderBottomLeft;
  final double borderBottomRight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        child: Padding(
          padding: EdgeInsets.all(isTotal ? 8.0 : 4.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: getTextColor(context)),
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderTopLeft),
            topRight: Radius.circular(borderTopRight),
            bottomLeft: Radius.circular(borderBottomLeft),
            bottomRight: Radius.circular(borderBottomRight),
          ),
        ),
      ),
    );
  }
}
