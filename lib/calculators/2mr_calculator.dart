import '../constants/2mr_table.dart';

int get2mrScore(int time, int ageGroup, bool male) {
  int ageIndex = male ? ageGroup * 2 - 1 : ageGroup * 2;
  if (time <= runTable[0][ageIndex]) return 100;
  for (int i = 0; i < runTable.length; i++) {
    if (runTable[i][ageIndex] >= time) {
      return runTable[i][0];
    }
  }
  return 0;
}
