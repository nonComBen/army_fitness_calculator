import 'package:flutter/material.dart';

import '../methods/theme_methods.dart';

class IncrementDecrementButton extends StatelessWidget {
  const IncrementDecrementButton(
      {Key? key,
      this.child,
      this.width = 42,
      this.fontSize = 24,
      this.onPressed})
      : super(key: key);
  final String? child;
  final double width;
  final double fontSize;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        highlightColor: Colors.grey,
        child: Container(
          width: width,
          height: 42,
          child: Center(
            child: Text(
              child!,
              style: TextStyle(
                  fontSize: fontSize, color: getOnPrimaryColor(context)),
            ),
          ),
        ),
        onTap: () {
          onPressed!();
        },
      ),
    );
  }
}
