import '../constants/2mr_table.dart';

int get2mrScore(int time, int ageGroup, bool male) {
  if (male) {
    if (time < 1322) return 100;
    if (time > 2536) return 0;
    for (int i = 0; i < runTable.length; i++) {
      if (runTable[i][ageGroup * 2 - 1] >= time) {
        return runTable[i][0];
      }
    }
    return 0;
  } else {
    if (time < 1500) return 100;
    if (time > 2700) return 0;
    for (int i = 0; i < runTable.length; i++) {
      if (runTable[i][ageGroup * 2] >= time) {
        return runTable[i][0];
      }
    }
    return 0;
  }
}
