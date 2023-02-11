import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class PlatformTextField extends Widget {
  factory PlatformTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    InputDecoration? decoration,
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
        focusNode: focusNode,
        enabled: enabled,
        decoration: iosDecoration,
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
  });
}

class IOSTextField extends CupertinoTextField implements PlatformTextField {
  IOSTextField({
    super.controller,
    super.focusNode,
    super.enabled = true,
    super.decoration,
    super.inputFormatters,
    super.keyboardType,
    super.obscureText,
    super.textInputAction,
    super.textCapitalization,
    super.autofocus,
    super.autocorrect,
    super.textAlign,
    super.maxLines,
    super.onChanged,
    super.onEditingComplete,
  });
}
