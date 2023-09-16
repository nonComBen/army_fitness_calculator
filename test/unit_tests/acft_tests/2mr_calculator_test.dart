import 'package:acft_calculator/calculators/2mr_calculator.dart';
import 'package:acft_calculator/constants/2mr_table.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test 2MR Calculator functions', () {
    test(
      "test max get2mrScore function",
      () async {
        for (var i = 0; i < ptAgeGroups.length; i++) {
          for (var n = 0; n < 50; n++) {
            print('Male: ${runTable[0][(i + 1) * 2 - 1] - n}');
            print('Female: ${runTable[0][(i + 1) * 2] - n}');
            int score =
                get2mrScore(runTable[0][(i + 1) * 2 - 1] - n, i + 1, true);
            expect(score, 100);
            score = get2mrScore(runTable[0][(i + 1) * 2] - n, i + 1, false);
            expect(score, 100);
          }
        }
      },
    );

    test(
      "test non-max get2mrScore function",
      () async {
        for (int i = 0; i < runTable.length; i++) {
          for (int n = 0; n < ptAgeGroups.length; n++) {
            int maleTime = runTable[i][(n + 1) * 2 - 1];
            int femaleTime = runTable[i][(n + 1) * 2];
            int maleScore = get2mrScore(maleTime, n + 1, true);
            int femaleScore = get2mrScore(femaleTime, n + 1, false);
            print(
                'Male Time: $maleTime - Male Score: $maleScore, Female Time: $femaleTime, Score: $femaleScore');
            int maleExpected = runTable
                .firstWhere((row) => maleTime <= row[(n + 1) * 2 - 1])[0];
            int femaleExpected =
                runTable.firstWhere((row) => femaleTime <= row[(n + 1) * 2])[0];
            expect(maleScore, maleExpected);
            expect(femaleScore, femaleExpected);
          }
        }
      },
    );
  });
}
