import 'package:acft_calculator/calculators/run_calculator.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test APFT Run Calculator functions', () {
    test(
      "test max and min male getRunScore function",
      () async {
        for (var i = 2631; i < 2660; i++) {
          var score = getRunScore(true, 1, i);
          print('$i - $score');
          expect(score, 0);
        }
        for (var i = 1259; i > 1200; i--) {
          var score = getRunScore(true, 1, i);
          print('$i - $score');
          expect(score, 100);
        }
      },
    );

    test(
      "test max and min female getRunScore function",
      () async {
        for (var i = 2631; i < 2660; i++) {
          var score = getRunScore(false, 1, i);
          print('$i - $score');
          expect(score, 0);
        }
        for (var i = 1535; i > 1200; i--) {
          var score = getRunScore(false, 1, i);
          print('$i - $score');
          expect(score, 100);
        }
      },
    );

    test(
      "test male getRunScore function",
      () async {
        for (var i = 0; i < maleTable.length; i++) {
          print('Run Time: ${maleTable[i][0] - 2}');
          for (var n = 0; n < ptAgeGroups.length; n++) {
            int score = getRunScore(true, n, maleTable[i][0] - 2)!;
            expect(score, maleTable[i][n + 1]);
          }
        }
      },
    );

    test(
      "test female getRunScore function",
      () async {
        for (var i = 0; i < femaleTable.length; i++) {
          print('Run Time: ${femaleTable[i][0] - 2}');
          for (var n = 0; n < ptAgeGroups.length; n++) {
            int score = getRunScore(false, n, femaleTable[i][0] - 2)!;
            expect(score, femaleTable[i][n + 1]);
          }
        }
      },
    );
  });
}
