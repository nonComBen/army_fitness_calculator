import 'package:acft_calculator/calculators/sdc_calculator.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:acft_calculator/constants/sdc_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test SDC Calculator functions', () {
    test(
      "test max getSdcScore function",
      () async {
        for (var i = 0; i < ptAgeGroups.length; i++) {
          for (var n = 0; n < 50; n++) {
            print('Male: ${sdcTable[0][(i + 1) * 2 - 1] - n}');
            print('Female: ${sdcTable[0][(i + 1) * 2] - n}');
            int score =
                getSdcScore(sdcTable[0][(i + 1) * 2 - 1] - n, i + 1, true);
            expect(score, 100);
            score = getSdcScore(sdcTable[0][(i + 1) * 2] - n, i + 1, false);
            expect(score, 100);
          }
        }
      },
    );

    test(
      "test non-max getSdcScore function",
      () async {
        for (int i = 0; i < sdcTable.length; i++) {
          for (int n = 0; n < ptAgeGroups.length; n++) {
            int maleTime = sdcTable[i][(n + 1) * 2 - 1];
            int femaleTime = sdcTable[i][(n + 1) * 2];
            int maleScore = getSdcScore(maleTime, n + 1, true);
            int femaleScore = getSdcScore(femaleTime, n + 1, false);
            print(
                'Male Time: $maleTime - Male Score: $maleScore, Female Time: $femaleTime, Score: $femaleScore');
            int maleExpected = sdcTable
                .firstWhere((row) => maleTime <= row[(n + 1) * 2 - 1])[0];
            int femaleExpected =
                sdcTable.firstWhere((row) => femaleTime <= row[(n + 1) * 2])[0];
            expect(maleScore, maleExpected);
            expect(femaleScore, femaleExpected);
          }
        }
      },
    );
  });
}
