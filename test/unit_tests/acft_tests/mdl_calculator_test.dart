import 'package:acft_calculator/calculators/mdl_calculator.dart';
import 'package:acft_calculator/constants/mdl_table.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test MDL Calculator functions', () {
    test(
      "test max getMDLScore function",
      () async {
        for (var i = 0; i < ptAgeGroups.length; i++) {
          for (var n = 0; n <= 50; n += 10) {
            print('Male: ${mdlTable[0][(i + 1) * 2 - 1] + n}');
            print('Female: ${mdlTable[0][(i + 1) * 2] + n}');
            int score =
                getMdlScore(mdlTable[0][(i + 1) * 2 - 1] + n, i + 1, true);
            expect(score, 100);
            score = getMdlScore(mdlTable[0][(i + 1) * 2] + n, i + 1, false);
            expect(score, 100);
          }
        }
      },
    );

    test(
      "test non-max getMdlScore function",
      () async {
        for (int i = 0; i < mdlTable.length; i++) {
          for (int n = 0; n < ptAgeGroups.length; n++) {
            int maleWeight = mdlTable[i][(n + 1) * 2 - 1];
            int femaleWeight = mdlTable[i][(n + 1) * 2];
            int maleScore = getMdlScore(maleWeight, n + 1, true);
            int femaleScore = getMdlScore(femaleWeight, n + 1, false);
            print(
                'Male Weight: $maleWeight - Male Score: $maleScore, Female Weight: $femaleWeight, Score: $femaleScore');
            int maleExpected = mdlTable
                .firstWhere((row) => maleWeight >= row[(n + 1) * 2 - 1])[0];
            int femaleExpected = mdlTable
                .firstWhere((row) => femaleWeight >= row[(n + 1) * 2])[0];
            expect(maleScore, maleExpected);
            expect(femaleScore, femaleExpected);
          }
        }
      },
    );
  });
}
