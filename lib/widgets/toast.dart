import 'package:flutter/material.dart';

class MyToast extends StatelessWidget {
  const MyToast({
    required this.contents,
  });
  final List<Widget> contents;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: contents,
      ),
    );
  }
}
