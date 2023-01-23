import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformTextField extends StatelessWidget {
  factory PlatformTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    InputDecoration? decoration,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputAction textInputAction = TextInputAction.done,
    void Function(String)? onChanged,
    void Function()? onEditingComplete,
  }) {
    if (Platform.isAndroid) {
      return AndroidTextField(
        controller: controller,
        focusNode: focusNode,
        decoration: decoration,
        validator: validator,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      );
    } else {
      return IOSTextField(
        controller: controller,
        focusNode: focusNode,
        decoration: decoration,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      );
    }
  }
}

class AndroidTextField extends StatelessWidget implements PlatformTextField {
  const AndroidTextField({
    required this.controller,
    this.focusNode,
    this.decoration,
    this.validator,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onEditingComplete,
  });
  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      validator: validator,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
    );
  }
}

class IOSTextField extends StatelessWidget implements PlatformTextField {
  const IOSTextField({
    required this.controller,
    this.focusNode,
    this.decoration,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onEditingComplete,
  });
  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final bool obscureText;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    Widget? prefix, suffix;
    if (decoration != null) {
      prefix = Text(
        ' ${decoration!.labelText!}: ',
      );
      suffix = decoration!.icon;
    }
    return CupertinoTextField(
      controller: controller,
      focusNode: focusNode,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      prefix: prefix,
      suffix: suffix,
      obscureText: obscureText,
      cursorColor: Colors.white,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
    );
  }
}
