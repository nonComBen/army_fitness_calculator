import 'package:flutter/material.dart';

class FormattedExpansionTile extends StatelessWidget {
  const FormattedExpansionTile({
    Key key,
    @required this.title,
    @required this.trailing,
    @required this.initiallyExpanded,
    @required this.children,
  }) : super(key: key);
  final String title;
  final String trailing;
  final bool initiallyExpanded;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    return ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 22),
        ),
        trailing: Text(
          trailing,
          style: const TextStyle(fontSize: 22),
        ),
        initiallyExpanded: initiallyExpanded,
        collapsedBackgroundColor: primaryColor,
        collapsedTextColor: onSecondaryColor,
        collapsedIconColor: onSecondaryColor,
        textColor: onSecondaryColor,
        children: children);
  }
}
