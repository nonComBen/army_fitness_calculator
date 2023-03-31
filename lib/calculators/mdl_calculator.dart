import '../constants/mdl_table.dart';

int getMdlScore(int weight, int ageGroup, bool male) {
  int ageIndex = male ? ageGroup * 2 - 1 : ageGroup * 2;
  if (weight >= mdlTable[0][ageIndex]) return 100;
  for (int i = 0; i < mdlTable.length; i++) {
    if (weight >= mdlTable[i][ageIndex]) {
      return mdlTable[i][0];
    }
  }
  return 0;
}
