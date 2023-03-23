import '../constants/mdl_table.dart';

int getMdlScore(int weight, int ageGroup, bool male) {
  int ageIndex = male ? ageGroup * 2 - 1 : ageGroup * 2;
  if (weight >= mdlTable[0][ageIndex]) return 100;
  for (int i = mdlTable.length - 1; i >= 0; i--) {
    if (mdlTable[i][ageIndex] >= weight) {
      if (weight == mdlTable[i][ageIndex]) {
        return mdlTable[i][0];
      } else if (i < mdlTable.length - 1) {
        return mdlTable[i + 1][0];
      }
    }
  }
  return 0;
}
