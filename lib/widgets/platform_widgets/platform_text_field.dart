import 'dart:io';

import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class PlatformTextField extends Widget {
  factory PlatformTextField({
    required TextEditingController controller,
    TextStyle? style,
    FocusNode? focusNode,
    String? label,
    required InputDecoration decoration,
    BoxDecoration? iosDecoration,
    String? Function(String?)? validator,
    AutovalidateMode? autovalidateMode,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    bool obscureText = false,
    bool autofocus = false,
    bool autocorrect = false,
    TextInputAction textInputAction = TextInputAction.done,
    TextCapitalization? textCapitalization,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    void Function(String)? onChanged,
    void Function()? onEditingComplete,
  }) {
    if (Platform.isAndroid) {
      return AndroidTextField(
        controller: controller,
        style: style,
        focusNode: focusNode,
        enabled: enabled,
        decoration: decoration,
        validator: validator,
        autovalidateMode: autovalidateMode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        textInputAction: textInputAction,
        autocorrect: autocorrect,
        autofocus: autofocus,
        textAlign: textAlign,
        maxLines: maxLines,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      );
    } else {
      return IOSTextField(
        controller: controller,
        style: style,
        focusNode: focusNode,
        enabled: enabled,
        label: label,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        autocorrect: autocorrect,
        autofocus: autofocus,
        textAlign: textAlign,
        maxLines: maxLines,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      );
    }
  }
}

class AndroidTextField extends TextFormField implements PlatformTextField {
  AndroidTextField({
    required super.controller,
    super.focusNode,
    super.enabled = true,
    super.decoration,
    super.validator,
    super.obscureText,
    super.textInputAction,
    super.autovalidateMode,
    super.keyboardType,
    super.inputFormatters,
    super.textCapitalization,
    super.autofocus,
    super.autocorrect,
    super.textAlign,
    super.maxLines,
    super.onChanged,
    super.onEditingComplete,
    super.style,
    super.textAlignVertical = TextAlignVertical.top,
  });
}

class IOSTextField extends StatelessWidget implements PlatformTextField {
  IOSTextField({
    required this.controller,
    this.focusNode,
    this.enabled = true,
    this.label,
    this.inputFormatters,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.autocorrect = false,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.onChanged,
    this.onEditingComplete,
    this.style,
    this.borderColor,
  });

  final TextEditingController controller;
  final TextStyle? style;
  final FocusNode? focusNode;
  final String? label;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool obscureText;
  final bool autofocus;
  final bool autocorrect;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final int maxLines;
  final Color? borderColor;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (label != null)
          SizedBox(
            width: double.infinity,
            height: 30,
            child: Text(
              label!,
              textAlign: TextAlign.start,
            ),
          ),
        CupertinoTextField(
          padding: EdgeInsets.all(8.0),
          controller: controller,
          style: style,
          focusNode: focusNode,
          decoration: BoxDecoration(
            border: Border.all(color: getTextColor(context)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          enabled: enabled,
          obscureText: obscureText,
          autofocus: autofocus,
          autocorrect: autocorrect,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          textAlign: textAlign,
          maxLines: maxLines,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
        )
      ],
    );
  }
}
