import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  ButtonText({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: getOnPrimaryColor(context), fontWeight: FontWeight.bold),
    );
  }
}
