import 'package:acft_calculator/calculators/pt_pts_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test PT point calculator', () {
    test(
      "test acft points calculation",
      () async {
        for (int i = 0; i < acftTable.length; i++) {
          for (int n = 0; n < 5; n++) {
            int score = acftTable[i][0] - n;
            int pts = acftPts(
              score,
            );
            int expected = 0;
            if (score >= 360) {
              expected = acftTable.firstWhere(
                  (element) => acftTable[i][0] - n >= element[0])[1];
            }
            print('Score: $score; Points: $pts');
            expect(pts, expected);
          }
        }
      },
    );

    test(
      "test apft points calculation",
      () async {
        for (int i = 0; i < apftTable.length; i++) {
          int score = apftTable[i][0];
          int sgtPoints = apftPts(score, 'SGT');
          int ssgPoints = apftPts(score, 'SSG');
          print(
              'Score: $score, SGT Points: $sgtPoints, SSG Points: $ssgPoints');
          expect(sgtPoints,
              apftTable.firstWhere((element) => score >= element[0])[1]);
          expect(ssgPoints,
              apftTable.firstWhere((element) => score >= element[0])[2]);
        }
      },
    );

    test(
      "test zero apft points",
      () async {
        for (int i = 179; i > 150; i--) {
          int points = apftPts(i, 'SGT');
          print('Score: $i, Points: $points');
          expect(points, 0);
        }
      },
    );
  });
}
