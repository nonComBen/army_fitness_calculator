import '../constants/sdc_table.dart';

int getSdcScore(int time, int ageGroup, bool male) {
  if (male) {
    if (time < 129) return 100;
    if (time > 416) return 0;
    for (int i = 0; i < sdcTable.length; i++) {
      if (sdcTable[i][ageGroup * 2 - 1] >= time) {
        return sdcTable[i][0];
      }
    }
    return 0;
  } else {
    if (time < 155) return 100;
    if (time > 548) return 0;
    for (int i = 0; i < sdcTable.length; i++) {
      if (sdcTable[i][ageGroup * 2] >= time) {
        return sdcTable[i][0];
      }
    }
    return 0;
  }
}
