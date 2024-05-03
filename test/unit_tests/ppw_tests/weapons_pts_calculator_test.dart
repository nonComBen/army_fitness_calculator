import 'package:acft_calculator/calculators/weapons_pts_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test weapons points calculator', () {
    test(
      "test M4 Table Calculations",
      () async {
        for (int i = 20; i <= 40; i++) {
          int newSgtPoints = newWeaponsPts(0, 'SGT', i);
          int newSsgPoints = newWeaponsPts(0, 'SSG', i);
          print(
              'Hits: $i, SGT Points: $newSgtPoints, SSG Points: $newSsgPoints');
          expect(newSgtPoints,
              m4Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSsgPoints,
              m4Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
    test(
      "test Form 85 Table Calculations",
      () async {
        for (int i = 100; i <= 220; i += 10) {
          int newSgtPoints = newWeaponsPts(1, 'SGT', i);
          int newSsgPoints = newWeaponsPts(1, 'SSG', i);
          print(
              'Hits: $i, SGT Points: $newSgtPoints, SSG Points: $newSsgPoints');
          expect(newSgtPoints, form85Pts('SGT', i));
          expect(newSsgPoints, form85Pts('SSG', i));
        }
      },
    );
    test(
      "test Form 88 Table Calculations",
      () async {
        for (int i = 12; i <= 30; i++) {
          int newSgtPoints = newWeaponsPts(2, 'SGT', i);
          int newSsgPoints = newWeaponsPts(2, 'SSG', i);
          print(
              'Hits: $i, SGT Points: $newSgtPoints, SSG Points: $newSsgPoints');
          expect(newSgtPoints,
              form88Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSsgPoints,
              form88Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
    test(
      "test Form 7814 Table Calculations",
      () async {
        for (int i = 12; i <= 30; i++) {
          int newSgtPoints = newWeaponsPts(3, 'SGT', i);
          int newSsgPoints = newWeaponsPts(3, 'SSG', i);
          print(
              'Hits: $i, SGT Points: $newSgtPoints, SSG Points: $newSsgPoints');
          expect(newSgtPoints,
              form7814Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSsgPoints,
              form7814Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
    test(
      "test Form 5704 Table Calculations",
      () async {
        for (int i = 20; i <= 40; i++) {
          int newSgtPoints = newWeaponsPts(4, 'SGT', i);
          int newSsgPoints = newWeaponsPts(4, 'SSG', i);
          print(
              'Hits: $i, SGT Points: $newSgtPoints, SSG Points: $newSsgPoints');
          expect(newSgtPoints,
              form5704Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSsgPoints,
              form5704Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
    test(
      "test Form 7304 Table Calculations",
      () async {
        for (int i = 50; i <= 110; i += 10) {
          int newSgtPoints = newWeaponsPts(5, 'SGT', i);
          int newSsgPoints = newWeaponsPts(5, 'SSG', i);
          print(
              'Hits: $i, SGT Points: $newSgtPoints, SSG Points: $newSsgPoints');
          expect(newSgtPoints, form7304Pts('SGT', i));
          expect(newSsgPoints, form7304Pts('SSG', i));
        }
      },
    );
    test(
      "test CID Table Calculations",
      () async {
        for (int i = 180; i <= 300; i += 10) {
          int newSgtPoints = newWeaponsPts(6, 'SGT', i);
          int newSsgPoints = newWeaponsPts(6, 'SSG', i);
          print(
              'Hits: $i, SGT Points: $newSgtPoints, SSG Points: $newSsgPoints');
          expect(newSgtPoints, formCidPts('SGT', i));
          expect(newSsgPoints, formCidPts('SSG', i));
        }
      },
    );
    test(
      "test Form 7820 Table Calculations",
      () async {
        for (int i = 30; i <= 50; i++) {
          int newSgtPoints = newWeaponsPts(7, 'SGT', i);
          int newSsgPoints = newWeaponsPts(7, 'SSG', i);
          print(
              'Hits: $i, SGT Points: $newSgtPoints, SSG Points: $newSsgPoints');
          expect(newSgtPoints,
              form7820Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSsgPoints,
              form7820Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
  });
}
