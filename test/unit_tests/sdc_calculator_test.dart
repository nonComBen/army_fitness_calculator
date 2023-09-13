import 'package:acft_calculator/calculators/sdc_calculator.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:acft_calculator/constants/sdc_table.dart';
import 'package:flutter_test/flutter_test.dart';

List<List<int>> times = [
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
  [350],
  [400],
  [410],
  [420],
  [430],
  [440],
  [450],
];

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
      () async {},
    );
  });
}
