import 'package:acft_calculator/calculators/award_pts_calculator.dart';
import 'package:acft_calculator/classes/award_decoration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test award and badge calculations', () {
    test(
      "test decoration calculation",
      () async {
        for (var i = 0; i < awardTypes.length; i++) {
          print('Award: ${awardTypes[i]}, points: ${awardTable[i][1]}');
          expect(
              calcAwardpts([AwardDecoration(name: awardTypes[i], number: 2)]),
              awardTable[awardTypes.indexOf(awardTypes[i])][1] * 2);
        }
      },
    );
    test(
      "test max COAs calculation",
      () async {
        expect(calcAwardpts([AwardDecoration(name: 'COA', number: 5)]), 20);
      },
    );
    test(
      "test badge new calculation",
      () async {
        for (var i = 1; i < badgeTypes.length; i++) {
          int points = newBadgePts([
            {'name': badgeTypes[i], 'number': 1}
          ]);
          print('Badge: ${badgeTypes[i]}, points: $points');
          int expected = 0;
          if (i == 1) {
            expected = 60;
          } else if (i <= 2) {
            expected = 30;
          } else if (i <= 9) {
            expected = 20;
          } else if (i <= 21) {
            expected = 15;
          } else {
            expected = 10;
          }
          expect(points, expected);
        }
      },
    );
  });
}
