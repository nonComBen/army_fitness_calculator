import 'package:flutter/material.dart';

class FormattedRadio extends StatelessWidget {
  const FormattedRadio(
      {Key key,
      @required this.titles,
      @required this.values,
      @required this.groupValue,
      @required this.onChanged})
      : super(key: key);
  final List<String> titles;
  final List<String> values;
  final String groupValue;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          child: RadioListTile(
            title: Text(titles[0]),
            value: values[0],
            groupValue: groupValue,
            activeColor: Theme.of(context).colorScheme.onSecondary,
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
        Flexible(
          child: RadioListTile(
            title: Text(titles[1]),
            value: values[1],
            groupValue: groupValue,
            activeColor: Theme.of(context).colorScheme.onSecondary,
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
