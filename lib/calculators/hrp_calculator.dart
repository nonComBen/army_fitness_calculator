import '../constants/hrp_table.dart';

int getHrpScore(int pushups, int ageGroup, bool male) {
  if (male) {
    if (pushups > 60) return 100;
    if (pushups < 5) return 0;
    for (int i = 0; i < hrpTable.length; i++) {
      if (hrpTable[i][ageGroup * 2 - 1] <= pushups) {
        return hrpTable[i][0];
      }
    }
    return 0;
  } else {
    if (pushups > 53) return 100;
    if (pushups < 5) return 0;
    for (int i = 0; i < hrpTable.length; i++) {
      if (hrpTable[i][ageGroup * 2] <= pushups) {
        return hrpTable[i][0];
      }
    }
    return 0;
  }
}
