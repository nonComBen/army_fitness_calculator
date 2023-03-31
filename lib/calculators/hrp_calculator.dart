import '../constants/hrp_table.dart';

int getHrpScore(int pushups, int ageGroup, bool male) {
  int ageIndex = male ? ageGroup * 2 - 1 : ageGroup * 2;
  if (pushups >= hrpTable[0][ageIndex]) return 100;
  for (int i = 0; i < hrpTable.length; i++) {
    if (hrpTable[i][ageIndex] <= pushups) {
      return hrpTable[i][0];
    }
  }
  return 0;
}
