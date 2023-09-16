import 'package:acft_calculator/calculators/spt_calculator.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:acft_calculator/constants/spt_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test SPT Calculator functions', () {
    test(
      "test max getSptScore function",
      () async {
        for (var i = 0; i < ptAgeGroups.length; i++) {
          for (var n = 0.0; n <= 5; n += 0.5) {
            print('Male: ${sptTable[0][(i + 1) * 2 - 1] + n}');
            print('Female: ${sptTable[0][(i + 1) * 2] + n}');
            int score =
                getSptScore(sptTable[0][(i + 1) * 2 - 1] + n, i + 1, true);
            expect(score, 100);
            score = getSptScore(sptTable[0][(i + 1) * 2] + n, i + 1, false);
            expect(score, 100);
          }
        }
      },
    );

    test(
      "test non-max getSptScore function",
      () async {
        for (int i = 0; i < sptTable.length; i++) {
          for (int n = 0; n < ptAgeGroups.length; n++) {
            double maleDist = sptTable[i][(n + 1) * 2 - 1];
            double femaleDist = sptTable[i][(n + 1) * 2];
            double maleScore = getSptScore(maleDist, n + 1, true).toDouble();
            double femaleScore =
                getSptScore(femaleDist, n + 1, false).toDouble();
            print(
                'Male Dist: $maleDist - Male Score: $maleScore, Female Dist: $femaleDist, Score: $femaleScore');
            double maleExpected = sptTable
                .firstWhere((row) => maleDist >= row[(n + 1) * 2 - 1])[0];
            double femaleExpected =
                sptTable.firstWhere((row) => femaleDist >= row[(n + 1) * 2])[0];
            expect(maleScore, maleExpected);
            expect(femaleScore, femaleExpected);
          }
        }
      },
    );
  });
}
