import 'package:acft_calculator/calculators/spt_calculator.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:acft_calculator/constants/spt_table.dart';
import 'package:flutter_test/flutter_test.dart';

List<List<dynamic>> distances = [
  [4.0],
  [4.5],
  [5.0],
  [5.5],
  [6.0],
  [6.5],
  [7.0],
  [7.5],
  [8.0],
  [8.5],
  [9.0],
  [9.5],
  [10.0],
  [10.5],
  [11.0],
  [11.5],
  [12.0],
  [12.5],
  [13.0],
  [13.5],
  [14.0],
  [14.5],
  [15.0],
  [15.5],
];

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
      () async {},
    );
  });
}
