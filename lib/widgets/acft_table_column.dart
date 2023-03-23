import 'package:flutter/material.dart';

import '../methods/theme_methods.dart';
import 'grid_box.dart';

class AcftTableColumn extends StatelessWidget {
  const AcftTableColumn(
      {Key? key,
      this.header = '',
      required this.table,
      this.tableIndex = 0,
      this.shaded = false})
      : super(key: key);
  final String header;
  final List<List<num>> table;
  final int tableIndex;
  final bool shaded;

  List<String> getValues() {
    final isTime = header == 'SDC' || header == 'PLK' || header == '2MR';
    List<String> list = table.map((e) {
      String title = e[tableIndex].toString();
      if (isTime) {
        title =
            '${title.substring(0, title.length - 2)}:${title.substring(title.length - 2)}';
      }
      return title;
    }).toList();
    for (int i = 0; i < list.length - 1; i++) {
      if (list[i] == list[i + 1]) {
        list[i] = '--';
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox.fromSize(
          size: Size((width - 24) / 7, 24),
          child: GridBox(
            background: getPrimaryColor(context),
            textColor: getOnPrimaryColor(context),
            title: header,
          ),
        ),
        ...getValues().map((e) {
          return SizedBox.fromSize(
            size: Size((width - 24) / 7, 24),
            child: GridBox(
              title: e,
              background: tableIndex == 0
                  ? getPrimaryColor(context)
                  : shaded
                      ? Colors.grey
                      : null,
              textColor: tableIndex == 0 ? getOnPrimaryColor(context) : null,
            ),
          );
        }).toList(),
      ],
    );
  }
}
