import '../constants/plk_table.dart';

int getPlkScore(int time, int ageGroup, bool male) {
  int ageIndex = male ? ageGroup * 2 - 1 : ageGroup * 2;
  if (time >= plkTable[0][ageIndex]) return 100;
  for (int i = 0; i < plkTable.length; i++) {
    if (plkTable[i][ageIndex] <= time) {
      return plkTable[i][0];
    }
  }
  return 0;
}
