import 'package:acft_calculator/calculators/plk_calculator.dart';
import 'package:acft_calculator/constants/plk_table.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

List<List<int>> times = [
  [120],
  [130],
  [140],
  [150],
  [200],
  [210],
  [220],
  [230],
  [240],
  [250],
  [300],
  [310],
  [320],
  [330],
  [340],
];

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
      () async {},
    );
  });
}
