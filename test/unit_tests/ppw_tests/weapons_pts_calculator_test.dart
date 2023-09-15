import 'package:acft_calculator/calculators/weapons_pts_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test weapons points calculator', () {
    test(
      "test M4 Table Calculations",
      () async {
        for (int i = 20; i <= 40; i++) {
          int oldSgtPoints = newWeaponsPts(0, 'SGT', i, false);
          int newSgtPoints = newWeaponsPts(0, 'SGT', i, true);
          int oldSsgPoints = newWeaponsPts(0, 'SSG', i, false);
          int newSsgPoints = newWeaponsPts(0, 'SSG', i, true);
          print(
              'Hits: $i, Old SGT Points: $oldSgtPoints, New SGT Points: $newSgtPoints, Old SSG Points: $oldSsgPoints, New SSG Points: $newSsgPoints');
          expect(oldSgtPoints,
              oldM4Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSgtPoints,
              m4Table.firstWhere((element) => i >= element[0])[1]);
          expect(oldSsgPoints,
              oldM4Table.firstWhere((element) => i >= element[0])[2]);
          expect(newSsgPoints,
              m4Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
    test(
      "test Form 85 Table Calculations",
      () async {
        for (int i = 100; i <= 220; i += 10) {
          int oldSgtPoints = newWeaponsPts(1, 'SGT', i, false);
          int newSgtPoints = newWeaponsPts(1, 'SGT', i, true);
          int oldSsgPoints = newWeaponsPts(1, 'SSG', i, false);
          int newSsgPoints = newWeaponsPts(1, 'SSG', i, true);
          print(
              'Hits: $i, Old SGT Points: $oldSgtPoints, New SGT Points: $newSgtPoints, Old SSG Points: $oldSsgPoints, New SSG Points: $newSsgPoints');
          expect(oldSgtPoints,
              oldForm85Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSgtPoints, form85Pts('SGT', i));
          expect(oldSsgPoints,
              oldForm85Table.firstWhere((element) => i >= element[0])[2]);
          expect(newSsgPoints, form85Pts('SSG', i));
        }
      },
    );
    test(
      "test Form 88 Table Calculations",
      () async {
        for (int i = 12; i <= 30; i++) {
          int oldSgtPoints = newWeaponsPts(2, 'SGT', i, false);
          int newSgtPoints = newWeaponsPts(2, 'SGT', i, true);
          int oldSsgPoints = newWeaponsPts(2, 'SSG', i, false);
          int newSsgPoints = newWeaponsPts(2, 'SSG', i, true);
          print(
              'Hits: $i, Old SGT Points: $oldSgtPoints, New SGT Points: $newSgtPoints, Old SSG Points: $oldSsgPoints, New SSG Points: $newSsgPoints');
          expect(oldSgtPoints,
              oldForm88Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSgtPoints,
              form88Table.firstWhere((element) => i >= element[0])[1]);
          expect(oldSsgPoints,
              oldForm88Table.firstWhere((element) => i >= element[0])[2]);
          expect(newSsgPoints,
              form88Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
    test(
      "test Form 7814 Table Calculations",
      () async {
        for (int i = 12; i <= 30; i++) {
          int oldSgtPoints = newWeaponsPts(3, 'SGT', i, false);
          int newSgtPoints = newWeaponsPts(3, 'SGT', i, true);
          int oldSsgPoints = newWeaponsPts(3, 'SSG', i, false);
          int newSsgPoints = newWeaponsPts(3, 'SSG', i, true);
          print(
              'Hits: $i, Old SGT Points: $oldSgtPoints, New SGT Points: $newSgtPoints, Old SSG Points: $oldSsgPoints, New SSG Points: $newSsgPoints');
          expect(oldSgtPoints,
              form7814Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSgtPoints,
              form7814Table.firstWhere((element) => i >= element[0])[1]);
          expect(oldSsgPoints,
              form7814Table.firstWhere((element) => i >= element[0])[2]);
          expect(newSsgPoints,
              form7814Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
    test(
      "test Form 5704 Table Calculations",
      () async {
        for (int i = 20; i <= 40; i++) {
          int oldSgtPoints = newWeaponsPts(4, 'SGT', i, false);
          int newSgtPoints = newWeaponsPts(4, 'SGT', i, true);
          int oldSsgPoints = newWeaponsPts(4, 'SSG', i, false);
          int newSsgPoints = newWeaponsPts(4, 'SSG', i, true);
          print(
              'Hits: $i, Old SGT Points: $oldSgtPoints, New SGT Points: $newSgtPoints, Old SSG Points: $oldSsgPoints, New SSG Points: $newSsgPoints');
          expect(oldSgtPoints,
              oldForm5704Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSgtPoints,
              form5704Table.firstWhere((element) => i >= element[0])[1]);
          expect(oldSsgPoints,
              oldForm5704Table.firstWhere((element) => i >= element[0])[2]);
          expect(newSsgPoints,
              form5704Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
    test(
      "test Form 7304 Table Calculations",
      () async {
        for (int i = 50; i <= 110; i += 10) {
          int oldSgtPoints = newWeaponsPts(5, 'SGT', i, false);
          int newSgtPoints = newWeaponsPts(5, 'SGT', i, true);
          int oldSsgPoints = newWeaponsPts(5, 'SSG', i, false);
          int newSsgPoints = newWeaponsPts(5, 'SSG', i, true);
          print(
              'Hits: $i, Old SGT Points: $oldSgtPoints, New SGT Points: $newSgtPoints, Old SSG Points: $oldSsgPoints, New SSG Points: $newSsgPoints');
          expect(oldSgtPoints, form7304Pts('SGT', i));
          expect(newSgtPoints, form7304Pts('SGT', i));
          expect(oldSsgPoints, form7304Pts('SSG', i));
          expect(newSsgPoints, form7304Pts('SSG', i));
        }
      },
    );
    test(
      "test CID Table Calculations",
      () async {
        for (int i = 180; i <= 300; i += 10) {
          int oldSgtPoints = newWeaponsPts(6, 'SGT', i, false);
          int newSgtPoints = newWeaponsPts(6, 'SGT', i, true);
          int oldSsgPoints = newWeaponsPts(6, 'SSG', i, false);
          int newSsgPoints = newWeaponsPts(6, 'SSG', i, true);
          print(
              'Hits: $i, Old SGT Points: $oldSgtPoints, New SGT Points: $newSgtPoints, Old SSG Points: $oldSsgPoints, New SSG Points: $newSsgPoints');
          expect(oldSgtPoints, formCidPts('SGT', i));
          expect(newSgtPoints, formCidPts('SGT', i));
          expect(oldSsgPoints, formCidPts('SSG', i));
          expect(newSsgPoints, formCidPts('SSG', i));
        }
      },
    );
    test(
      "test Form 7820 Table Calculations",
      () async {
        for (int i = 30; i <= 50; i++) {
          int oldSgtPoints = newWeaponsPts(7, 'SGT', i, false);
          int newSgtPoints = newWeaponsPts(7, 'SGT', i, true);
          int oldSsgPoints = newWeaponsPts(7, 'SSG', i, false);
          int newSsgPoints = newWeaponsPts(7, 'SSG', i, true);
          print(
              'Hits: $i, Old SGT Points: $oldSgtPoints, New SGT Points: $newSgtPoints, Old SSG Points: $oldSsgPoints, New SSG Points: $newSsgPoints');
          expect(oldSgtPoints,
              oldForm7820Table.firstWhere((element) => i >= element[0])[1]);
          expect(newSgtPoints,
              form7820Table.firstWhere((element) => i >= element[0])[1]);
          expect(oldSsgPoints,
              oldForm7820Table.firstWhere((element) => i >= element[0])[2]);
          expect(newSsgPoints,
              form7820Table.firstWhere((element) => i >= element[0])[2]);
        }
      },
    );
  });
}
