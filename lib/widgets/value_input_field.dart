import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ValueInputField extends StatelessWidget {
  const ValueInputField(
      {Key key,
      this.width = 60,
      this.controller,
      this.focusNode,
      this.textInputAction = TextInputAction.next,
      this.onEditingComplete,
      this.errorText,
      this.onChanged})
      : super(key: key);
  final double width;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final String errorText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
        ],
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        decoration:
            InputDecoration(border: OutlineInputBorder(), errorText: errorText),
        onChanged: onChanged,
      ),
    );
  }
}
