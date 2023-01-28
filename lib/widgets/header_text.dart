import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  HeaderText({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
