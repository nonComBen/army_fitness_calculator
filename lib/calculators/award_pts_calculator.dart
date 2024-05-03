import '../classes/award_decoration.dart';

int calcAwardpts(List<AwardDecoration> awards) {
  int points = 0;
  for (AwardDecoration award in awards) {
    int pts = awardTable[awardTypes.indexOf(award.name)][1] * award.number!;
    if (award.name == 'COA' && pts > 20) {
      pts = 20;
    }
    points += pts;
  }
  return points;
}

int newBadgePts(List<dynamic> badges) {
  int points = 0;
  for (Map<String, dynamic> badge in badges) {
    int pts = badgeTable.firstWhere(
        (element) => badgeTypes.indexOf(badge['name']) <= element[0])[1];

    points += pts;
  }
  return points;
}

const List<String?> awardTypes = [
  'None',
  'Soldiers Medal',
  'Purple Heart',
  'BSM',
  'BSM w/V Device',
  'MSM/DMSM',
  'ARCOM/JSCOM/Equiv',
  'ARCOM/Air Medal w/V Device',
  'AAM/JSAM/Equiv',
  'MOVSM',
  'AGCM/AF Res Medal',
  'COA',
];

const List<String?> badgeTypes = [
  'None',
  'EIB/EFMB/ESB',
  'CIB/CMB/CAB',
  'Master Parachute Badge',
  'Master EOD Badge',
  'Master/Gold Recruiter Badge',
  'Master Gunner Badge',
  'Divers Badge (First Class)',
  'Master Aviation Badge',
  'Master Instructor Badge',
  'Instructor Badge (Basic/Senior)',
  'Senior Parachute Badge',
  'Senior EOD Badge',
  'Presidential Service Badge',
  'VP Service Badge',
  'Drill Sergeant Badge',
  'Recruiter Badge (Basic)',
  'Divers Badge (Supervisor/Salvage)',
  'Parachute Combat Badge (Senior)',
  'Senior Aviation Badge',
  'Free Fall Badge (Master)',
  'Senior Space Badge',
  'Parachute Badge',
  'Parachute Combat Badge (Basic)',
  'Rigger Badge',
  'Divers Badge (SCUBA/2nd Class)',
  'EOD Badge (Basic)',
  'Pathfinder Badge',
  'Air Assault Badge',
  'Aviation Badge',
  'Army Staff ID Badge',
  'JCoS ID Badge',
  'SecDef Service Badge',
  'Space Badge',
  'Free Fall Badge (Basic)',
  'Special Operations Divers Badge (Basic)',
  'Tomb Guard ID Badge',
  'Military Horseman ID Badge',
  'Driver/Mech Badge',
];

const List<List<int>> awardTable = [
  [0, 0],
  [1, 35],
  [2, 30],
  [3, 30],
  [4, 35],
  [5, 25],
  [6, 20],
  [7, 25],
  [8, 10],
  [9, 10],
  [10, 10],
  [11, 5],
];

const List<List<int>> badgeTable = [
  [0, 0],
  [1, 60],
  [2, 30],
  [9, 20],
  [21, 15],
  [38, 10],
];
