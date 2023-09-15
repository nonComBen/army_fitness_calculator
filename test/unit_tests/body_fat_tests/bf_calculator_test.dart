import 'package:acft_calculator/calculators/bf_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

final List<String> ageGroups = ['17-20', '21-27', '28-39', '40+'];

void main() {
  group('Body Composition tests', () {
    test(
      "test male body composition benchmarks",
      () async {
        for (int height = 58; height < 80; height++) {
          for (var n = 0; n < ageGroups.length; n++) {
            List<int> benchmarks = setBfBenchmarks(true, n, height);
            print(benchmarks);
            expect(benchmarks[0], heightWeightTable[height - 58][8]);
            expect(benchmarks[1], heightWeightTable[height - 58][n]);
            expect(benchmarks[2], percentTable[n]);
          }
        }
      },
    );

    test(
      "test male old bf calc min values",
      () async {
        for (var i = 10.0; i > 0.0; i -= 0.5) {
          print(i);
          expect(getBfPercent(cirValue: i, isNewVersion: false, weight: 0), 0);
        }
      },
    );

    test(
      "test male new body fat calculations",
      () async {
        for (var i = 10.5; i < 40.5; i += 0.5) {
          for (var n = 130; n < 300; n += 10) {
            var percent =
                getBfPercent(cirValue: i, isNewVersion: true, weight: n);
            print('Weight: $n, Circumference: $i, BF %: $percent');
            double weightSolution = (0.12) * n;
            double circSolution = (1.99) * i;
            expect(percent, (-26.97 - weightSolution + circSolution).round());
          }
        }
      },
    );

    test(
      "test male old get body fat calculation",
      () async {
        for (var i = 10.5; i < 40.5; i += 0.5) {
          for (var n = 58.0; n < 80.5; n += 0.5) {
            print('Height: $n, Circumference: $i');
            var percent = getBfPercent(
                cirValue: i, isNewVersion: false, weight: 0, height: n);
            expect(percent,
                maleBfTable[maleCirValues.indexOf(i)][heights.indexOf(n)]);
          }
        }
      },
    );

    test(
      "test female body composition benchmarks",
      () async {
        for (int height = 58; height < 80; height++) {
          for (var n = 0; n < ageGroups.length; n++) {
            List<int> benchmarks = setBfBenchmarks(false, n, height);
            print(benchmarks);
            expect(benchmarks[0], heightWeightTable[height - 58][8]);
            expect(benchmarks[1], heightWeightTable[height - 58][n + 4]);
            expect(benchmarks[2], percentTable[n + 4]);
          }
        }
      },
    );

    test(
      "test female old bf calc min values",
      () async {
        for (var i = 34.0; i > 24.0; i -= 0.5) {
          print(i);
          expect(
              getBfPercent(
                  cirValue: i, isNewVersion: false, weight: 0, male: false),
              0);
        }
      },
    );

    test(
      "test female new body fat calculations",
      () async {
        for (var i = 10.5; i < 40.5; i += 0.5) {
          for (var n = 80; n < 300; n += 10) {
            var percent = getBfPercent(
                cirValue: i, isNewVersion: true, weight: n, male: false);
            print('Weight: $n, Circumference: $i, BF %: $percent');
            double weightSolution = (0.015) * n;
            double circSolution = (1.27) * i;
            expect(percent, (-9.15 - weightSolution + circSolution).round());
          }
        }
      },
    );

    test(
      "test female old get body fat calculation",
      () async {
        for (var i = 34.5; i < 90.5; i += 0.5) {
          for (var n = 58.0; n < 80.5; n += 0.5) {
            print('Height: $n, Circumference: $i');
            var percent = getBfPercent(
                cirValue: i,
                isNewVersion: false,
                weight: 0,
                height: n,
                male: false);
            expect(percent,
                femaleBfTable[femaleCirValues.indexOf(i)][heights.indexOf(n)]);
          }
        }
      },
    );
  });
}
