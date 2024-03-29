import 'package:acft_calculator/widgets/platform_widgets/platform_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ValueInputField extends StatelessWidget {
  const ValueInputField({
    Key? key,
    this.width = 50,
    this.isEnabled = true,
    this.controller,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onEditingComplete,
    this.errorText,
    this.onChanged,
  }) : super(key: key);
  final double width;
  final bool isEnabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final void Function()? onEditingComplete;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: PlatformTextField(
        controller: controller!,
        focusNode: focusNode,
        enabled: isEnabled,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
        ],
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorText: errorText,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
