import '../constants/spt_table.dart';

int getSptScore(double dist, int ageGroup, bool male) {
  if (male) {
    if (dist > 13.0) return 100;
    if (dist < 3.7) return 0;
    for (int i = 0; i < sptTable.length; i++) {
      if (sptTable[i][ageGroup * 2 - 1] <= dist) {
        return sptTable[i][0].toInt();
      }
    }
    return 0;
  } else {
    if (dist > 8.6) return 100;
    if (dist < 2.3) return 0;
    for (int i = 0; i < sptTable.length; i++) {
      if (sptTable[i][ageGroup * 2] <= dist) {
        return sptTable[i][0].toInt();
      }
    }
    return 0;
  }
}
