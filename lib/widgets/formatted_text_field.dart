import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormattedTextField extends StatelessWidget {
  const FormattedTextField(
      {Key key,
      this.contoller,
      this.focusNode,
      this.textInputAction,
      this.onEditingComplete,
      this.label,
      this.errorText,
      this.onChanged})
      : super(key: key);
  final TextEditingController contoller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final String label;
  final String errorText;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: contoller,
        focusNode: focusNode,
        keyboardType: TextInputType.numberWithOptions(signed: true),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          label: Text(label),
          border: OutlineInputBorder(),
          errorText: errorText,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
