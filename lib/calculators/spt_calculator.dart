import '../constants/spt_table.dart';

int getSptScore(double dist, int ageGroup, bool male) {
  int ageIndex = male ? ageGroup * 2 - 1 : ageGroup * 2;
  if (dist >= sptTable[0][ageIndex]) return 100;
  for (int i = 0; i < sptTable.length; i++) {
    if (dist >= sptTable[i][ageIndex]) {
      return sptTable[i][0].toInt();
    }
  }
  return 0;
}
