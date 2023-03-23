import '../constants/hrp_table.dart';

int getHrpScore(int pushups, int ageGroup, bool male) {
  int ageIndex = male ? ageGroup * 2 - 1 : ageGroup * 2;
  if (pushups >= hrpTable[0][ageIndex]) return 100;
  for (int i = 0; i < hrpTable.length; i++) {
    if (hrpTable[i][ageIndex] <= pushups) {
      if (pushups == hrpTable[i][ageIndex]) {
        return hrpTable[i][0];
      } else if (i < hrpTable.length - 1) {
        return hrpTable[i + 1][0];
      }
    }
  }
  return 0;
}
