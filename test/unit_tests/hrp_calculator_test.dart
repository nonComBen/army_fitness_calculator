import 'package:acft_calculator/calculators/hrp_calculator.dart';
import 'package:acft_calculator/constants/hrp_table.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

List<List<int>> reps = [
  [10],
  [15],
  [20],
  [25],
  [30],
  [35],
  [40],
  [45],
  [50],
  [55],
  [60],
  [65],
  [70],
  [75],
];

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
      () async {},
    );
  });
}
