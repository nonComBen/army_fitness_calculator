import 'package:flutter/material.dart';

class FormattedDropDown extends StatelessWidget {
  const FormattedDropDown(
      {Key? key,
      required this.label,
      required this.value,
      required this.items,
      required this.onChanged})
      : super(key: key);
  final String label;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items.map((event) {
          return DropdownMenuItem(
            child: Text(
              event,
              style: TextStyle(fontSize: 22),
            ),
            value: event,
          );
        }).toList(),
        onChanged: (dynamic value) {
          onChanged(value);
        },
      ),
    );
  }
}
