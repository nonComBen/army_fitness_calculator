import 'package:acft_calculator/calculators/hrp_calculator.dart';
import 'package:acft_calculator/constants/hrp_table.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test HRP Calculator functions', () {
    test(
      "test max getHrpScore function",
      () async {
        for (var i = 0; i < ptAgeGroups.length; i++) {
          for (var n = 0; n <= 10; n++) {
            print('Male: ${hrpTable[0][(i + 1) * 2 - 1] + n}');
            print('Female: ${hrpTable[0][(i + 1) * 2] + n}');
            int score =
                getHrpScore(hrpTable[0][(i + 1) * 2 - 1] + n, i + 1, true);
            expect(score, 100);
            score = getHrpScore(hrpTable[0][(i + 1) * 2] + n, i + 1, false);
            expect(score, 100);
          }
        }
      },
    );

    test(
      "test non-max getHrpScore function",
      () async {
        for (int i = 0; i < hrpTable.length; i++) {
          for (int n = 0; n < ptAgeGroups.length; n++) {
            int maleReps = hrpTable[i][(n + 1) * 2 - 1];
            int femaleReps = hrpTable[i][(n + 1) * 2];
            int maleScore = getHrpScore(maleReps, n + 1, true);
            int femaleScore = getHrpScore(femaleReps, n + 1, false);
            print(
                'Male Reps: $maleReps - Male Score: $maleScore, Female Reps: $femaleReps, Score: $femaleScore');
            int maleExpected = hrpTable
                .firstWhere((row) => maleReps >= row[(n + 1) * 2 - 1])[0];
            int femaleExpected =
                hrpTable.firstWhere((row) => femaleReps >= row[(n + 1) * 2])[0];
            expect(maleScore, maleExpected);
            expect(femaleScore, femaleExpected);
          }
        }
      },
    );
  });
}
