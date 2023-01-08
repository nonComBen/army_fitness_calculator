import 'package:flutter/material.dart';

import 'grid_box.dart';

class AcftTableColumn extends StatelessWidget {
  const AcftTableColumn(
      {Key? key,
      this.header = '',
      this.table,
      this.tableIndex = 0,
      this.shaded = false})
      : super(key: key);
  final String header;
  final List<List<num>>? table;
  final int tableIndex;
  final bool shaded;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTime = header == 'SDC' || header == 'PLK' || header == '2MR';
    return Column(
      children: [
        SizedBox.fromSize(
          size: Size((width - 24) / 7, 24),
          child: GridBox(
            background: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            title: header,
          ),
        ),
        ...table!.map((e) {
          var title = e[tableIndex].toString();
          if (isTime) {
            title =
                '${title.substring(0, title.length - 2)}:${title.substring(title.length - 2)}';
          }
          return SizedBox.fromSize(
            size: Size((width - 24) / 7, 24),
            child: GridBox(
              title: title,
              background: tableIndex == 0
                  ? Theme.of(context).colorScheme.primary
                  : shaded
                      ? Colors.grey
                      : null,
              textColor: tableIndex == 0
                  ? Theme.of(context).colorScheme.onPrimary
                  : null,
            ),
          );
        }).toList(),
      ],
    );
  }
}
