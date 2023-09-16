import 'package:acft_calculator/calculators/plk_calculator.dart';
import 'package:acft_calculator/constants/plk_table.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test PLK Calculator functions', () {
    test(
      "test max getPlkScore function",
      () async {
        for (var i = 0; i < ptAgeGroups.length; i++) {
          for (var n = 0; n <= 50; n++) {
            print('Male: ${plkTable[0][(i + 1) * 2 - 1] + n}');
            print('Female: ${plkTable[0][(i + 1) * 2] + n}');
            int score =
                getPlkScore(plkTable[0][(i + 1) * 2 - 1] + n, i + 1, true);
            expect(score, 100);
            score = getPlkScore(plkTable[0][(i + 1) * 2] + n, i + 1, false);
            expect(score, 100);
          }
        }
      },
    );

    test(
      "test non-max getPlkScore function",
      () async {
        for (int i = 0; i < plkTable.length; i++) {
          for (int n = 0; n < ptAgeGroups.length; n++) {
            int maleTime = plkTable[i][(n + 1) * 2 - 1];
            int femaleTime = plkTable[i][(n + 1) * 2];
            int maleScore = getPlkScore(maleTime, n + 1, true);
            int femaleScore = getPlkScore(femaleTime, n + 1, false);
            print(
                'Male Time: $maleTime - Male Score: $maleScore, Female Time: $femaleTime, Score: $femaleScore');
            int maleExpected = plkTable
                .firstWhere((row) => maleTime >= row[(n + 1) * 2 - 1])[0];
            int femaleExpected =
                plkTable.firstWhere((row) => femaleTime >= row[(n + 1) * 2])[0];
            expect(maleScore, maleExpected);
            expect(femaleScore, femaleExpected);
          }
        }
      },
    );
  });
}
