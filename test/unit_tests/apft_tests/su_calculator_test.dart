import 'package:acft_calculator/calculators/su_calculator.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test APFT SU Calculator functions', () {
    test(
      "test getSuScore function",
      () async {
        for (var i = 0; i < suTable.length; i++) {
          for (var n = 0; n < ptAgeGroups.length; n++) {
            int score = getSuScore(n, i + 21);
            print('SUs: ${i + 21} - $score');
            expect(score, suTable[i][n]);
          }
        }
      },
    );

    test(
      "test 0 scores",
      () async {
        for (var i = 20; i > 0; i--) {
          print(i);
          expect(getSuScore(0, i), 0);
        }
      },
    );

    test(
      "test 100 scores",
      () async {
        for (var i = 82; i < 92; i++) {
          print(i);
          expect(getSuScore(1, i), 100);
        }
      },
    );
  });
}
