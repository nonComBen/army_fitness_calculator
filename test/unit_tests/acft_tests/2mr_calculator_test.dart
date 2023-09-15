import 'package:acft_calculator/calculators/2mr_calculator.dart';
import 'package:acft_calculator/constants/2mr_table.dart';
import 'package:acft_calculator/constants/pt_age_group_table.dart';
import 'package:flutter_test/flutter_test.dart';

List<List<int>> runTimes = [
  [1300],
  [1315],
  [1330],
  [1345],
  [1400],
  [1415],
  [1430],
  [1445],
  [1500],
  [1515],
  [1530],
  [1545],
  [1600],
  [1615],
  [1630],
  [1645],
  [1700],
  [1715],
  [1730],
  [1745],
  [1800],
  [1815],
  [1830],
  [1845],
  [1900],
  [1915],
  [1930],
  [1945],
  [2000],
  [2015],
  [2030],
  [2045],
  [2100],
  [2115],
  [2130],
  [2145],
  [2200],
  [2215],
  [2230],
  [2245],
  [2300],
  [2315],
  [2330],
  [2345],
  [2400],
  [2415],
  [2430],
  [2445],
  [2500],
  [2515],
  [2530],
  [2545],
];

void main() {
  group('test 2MR Calculator functions', () {
    test(
      "test max get2mrScore function",
      () async {
        for (var i = 0; i < ptAgeGroups.length; i++) {
          for (var n = 0; n < 50; n++) {
            print('Male: ${runTable[0][(i + 1) * 2 - 1] - n}');
            print('Female: ${runTable[0][(i + 1) * 2] - n}');
            int score =
                get2mrScore(runTable[0][(i + 1) * 2 - 1] - n, i + 1, true);
            expect(score, 100);
            score = get2mrScore(runTable[0][(i + 1) * 2] - n, i + 1, false);
            expect(score, 100);
          }
        }
      },
    );

    test(
      "test non-max get2mrScore function",
      () async {},
    );
  });
}
