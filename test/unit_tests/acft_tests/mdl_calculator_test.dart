import 'package:acft_calculator/calculators/mdl_calculator.dart';
import 'package:acft_calculator/constants/mdl_table.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

List<List<int>> weights = [
  [170],
  [180],
  [190],
  [200],
  [210],
  [220],
  [230],
  [240],
  [250],
  [260],
  [270],
  [280],
  [290],
  [300],
  [310],
  [320],
  [330],
];

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
      "test non-max getMDLScore function",
      () async {},
    );
  });
}
