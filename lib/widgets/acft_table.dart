import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter/material.dart';

import '../constants/2mr_table.dart';
import '../constants/hrp_table.dart';
import '../constants/mdl_table.dart';
import '../constants/plk_table.dart';
import '../constants/sdc_table.dart';
import '../constants/spt_table.dart';
import 'acft_table_column.dart';

class AcftTable extends StatelessWidget {
  const AcftTable({Key key, this.ageGroup, this.gender}) : super(key: key);
  final String ageGroup;
  final String gender;

  @override
  Widget build(BuildContext context) {
    var tableIndex;
    if (gender == 'Male') {
      tableIndex = (ptAgeGroups.indexOf(ageGroup) + 1) * 2 - 1;
    } else {
      tableIndex = (ptAgeGroups.indexOf(ageGroup) + 1) * 2;
    }
    return Container(
      child: Row(
        children: [
          AcftTableColumn(
            table: mdlTable,
          ),
          AcftTableColumn(
            header: 'MDL',
            table: mdlTable,
            tableIndex: tableIndex,
          ),
          AcftTableColumn(
            header: 'SPT',
            table: sptTable,
            tableIndex: tableIndex,
            shaded: true,
          ),
          AcftTableColumn(
            header: 'HRP',
            table: hrpTable,
            tableIndex: tableIndex,
          ),
          AcftTableColumn(
            header: 'SDC',
            table: sdcTable,
            tableIndex: tableIndex,
            shaded: true,
          ),
          AcftTableColumn(
            header: 'PLK',
            table: plkTable,
            tableIndex: tableIndex,
          ),
          AcftTableColumn(
            header: '2MR',
            table: runTable,
            tableIndex: tableIndex,
            shaded: true,
          )
        ],
      ),
    );
  }
}
