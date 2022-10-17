import '../constants/plk_table.dart';

int getPlkScore(int time, int ageGroup, bool male) {
  if (male) {
    if (time > 340) return 100;
    if (time < 40) return 0;
    for (int i = 0; i < plkTable.length; i++) {
      if (plkTable[i][ageGroup * 2 - 1] <= time) {
        return plkTable[i][0];
      }
    }
    return 0;
  } else {
    if (time > 340) return 100;
    if (time < 40) return 0;
    for (int i = 0; i < plkTable.length; i++) {
      if (plkTable[i][ageGroup * 2] <= time) {
        return plkTable[i][0];
      }
    }
    return 0;
  }
}
