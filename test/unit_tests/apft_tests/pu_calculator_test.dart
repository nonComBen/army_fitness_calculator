import 'package:acft_calculator/calculators/pu_calculator.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test APFT PU Calculator functions', () {
    test(
      "test male getPuScore function",
      () async {
        for (var i = 0; i < maleTable.length; i++) {
          print('PUs: ${i + 1}');
          for (var n = 0; n < ptAgeGroups.length; n++) {
            int score = getPuScore(true, n, i + 1);
            expect(score, maleTable[i][n]);
          }
        }
      },
    );

    test(
      "test 0 male scores",
      () async {
        for (var i = 0; i > -10; i--) {
          print(i);
          expect(getPuScore(true, 0, i), 0);
        }
      },
    );

    test(
      "test 100 male scores",
      () async {
        for (var i = 76; i < 86; i++) {
          print(i);
          expect(getPuScore(true, 1, i), 100);
        }
      },
    );

    test(
      "test female getPuScore function",
      () async {
        for (var i = 0; i < femaleTable.length; i++) {
          print('PUs: ${i + 1}');
          for (var n = 0; n < ptAgeGroups.length; n++) {
            int score = getPuScore(false, n, i + 1);
            expect(score, femaleTable[i][n]);
          }
        }
      },
    );

    test(
      "test 0 female scores",
      () async {
        for (var i = 0; i > -10; i--) {
          print(i);
          expect(getPuScore(false, 0, i), 0);
        }
      },
    );

    test(
      "test 100 female scores",
      () async {
        for (var i = 49; i < 59; i++) {
          print(i);
          expect(getPuScore(false, 1, i), 100);
        }
      },
    );
  });
}
