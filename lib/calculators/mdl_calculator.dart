import '../constants/mdl_table.dart';

int getMdlScore(int weight, int ageGroup, bool male) {
  if (male) {
    if (weight > 330) return 100;
    if (weight < 90) return 0;
    for (int i = 0; i < mdlTable.length; i++) {
      if (mdlTable[i][ageGroup * 2 - 1] <= weight) {
        return mdlTable[i][0];
      }
    }
    return 0;
  } else {
    if (weight > 220) return 100;
    if (weight < 70) return 0;
    for (int i = 0; i < mdlTable.length; i++) {
      if (mdlTable[i][ageGroup * 2] <= weight) {
        return mdlTable[i][0];
      }
    }
    return 0;
  }
}
