import '../constants/sdc_table.dart';

int getSdcScore(int time, int ageGroup, bool male) {
  int ageIndex = male ? ageGroup * 2 - 1 : ageGroup * 2;
  if (time <= sdcTable[0][ageIndex]) return 100;
  for (int i = 0; i < sdcTable.length; i++) {
    if (sdcTable[i][ageIndex] >= time) {
      return sdcTable[i][0];
    }
  }
  return 0;
}
