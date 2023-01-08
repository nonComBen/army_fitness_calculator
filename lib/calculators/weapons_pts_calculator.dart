int newWeaponsPts(int cardIndex, String? rank, int hits, bool newVersion) {
  int rankIndex = rank == 'SGT' ? 1 : 2;
  if (newVersion) {
    switch (cardIndex) {
      case 0:
        return m4Table.firstWhere((element) => hits >= element[0])[rankIndex];
      case 1:
        return form85Pts(rank, hits);
      case 2:
        return form88Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      case 3:
        return form7814Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      case 4:
        return form5704Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      case 5:
        return form7304Pts(rank, hits);
      case 6:
        return formCidPts(rank, hits);
      case 7:
        return form7820Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      default:
        return 0;
    }
  } else {
    switch (cardIndex) {
      case 0:
        return oldM4Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      case 1:
        return oldForm85Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      case 2:
        return oldForm88Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      case 3:
        return form7814Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      case 4:
        return oldForm5704Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      case 5:
        return form7304Pts(rank, hits);
      case 6:
        return formCidPts(rank, hits);
      case 7:
        return oldForm7820Table
            .firstWhere((element) => hits >= element[0])[rankIndex];
      default:
        return 0;
    }
  }
}

const List<List<int>> m4Table = [
  [40, 160, 110],
  [39, 153, 106],
  [38, 145, 101],
  [37, 138, 96],
  [36, 130, 91],
  [35, 123, 86],
  [34, 115, 81],
  [33, 108, 76],
  [32, 100, 71],
  [31, 93, 66],
  [30, 85, 61],
  [29, 77, 56],
  [28, 69, 51],
  [27, 62, 46],
  [26, 54, 41],
  [25, 47, 36],
  [24, 40, 32],
  [23, 33, 28],
  [
    0,
    0,
    0,
  ],
];

const List<List<int>> oldM4Table = [
  [40, 160, 110],
  [39, 153, 107],
  [38, 153, 104],
  [37, 138, 101],
  [36, 130, 98],
  [35, 123, 91],
  [34, 115, 84],
  [33, 108, 77],
  [32, 100, 70],
  [31, 93, 63],
  [30, 85, 56],
  [29, 78, 52],
  [28, 70, 48],
  [27, 63, 44],
  [26, 55, 40],
  [25, 48, 36],
  [24, 40, 32],
  [23, 33, 28],
  [
    0,
    0,
    0,
  ],
];

const List<List<int>> form88Table = [
  [30, 160, 110],
  [29, 151, 104],
  [28, 142, 98],
  [27, 133, 92],
  [26, 124, 86],
  [25, 115, 80],
  [24, 106, 74],
  [23, 97, 68],
  [22, 88, 62],
  [21, 79, 56],
  [20, 70, 50],
  [19, 61, 44],
  [18, 52, 38],
  [17, 43, 33],
  [16, 33, 28],
  [
    0,
    0,
    0,
  ],
];

const List<List<int>> oldForm88Table = [
  [30, 160, 110],
  [29, 151, 107],
  [28, 142, 104],
  [27, 133, 95],
  [26, 124, 86],
  [25, 115, 79],
  [24, 106, 72],
  [23, 97, 63],
  [22, 88, 54],
  [21, 79, 49],
  [20, 70, 44],
  [19, 61, 40],
  [18, 52, 36],
  [17, 43, 32],
  [16, 33, 28],
  [
    0,
    0,
    0,
  ],
];

const List<List<int>> form7814Table = [
  [30, 160, 110],
  [29, 146, 101],
  [28, 132, 92],
  [27, 118, 83],
  [26, 104, 74],
  [25, 90, 65],
  [24, 75, 55],
  [23, 61, 46],
  [22, 47, 37],
  [21, 33, 28],
  [
    0,
    0,
    0,
  ],
];

const List<List<int>> form5704Table = [
  [40, 160, 110],
  [39, 152, 105],
  [38, 144, 100],
  [37, 136, 94],
  [36, 128, 89],
  [35, 120, 84],
  [34, 112, 78],
  [33, 104, 73],
  [32, 96, 68],
  [31, 88, 62],
  [30, 80, 57],
  [29, 72, 52],
  [28, 64, 46],
  [27, 56, 43],
  [26, 48, 38],
  [25, 40, 33],
  [24, 33, 28],
  [
    0,
    0,
    0,
  ],
];

const List<List<int>> oldForm5704Table = [
  [40, 160, 110],
  [39, 152, 104],
  [38, 144, 99],
  [37, 136, 93],
  [36, 128, 88],
  [35, 120, 82],
  [34, 112, 77],
  [33, 104, 71],
  [32, 96, 65],
  [31, 88, 60],
  [30, 80, 55],
  [29, 72, 50],
  [28, 64, 46],
  [27, 56, 41],
  [26, 48, 37],
  [25, 40, 32],
  [24, 33, 28],
  [
    0,
    0,
    0,
  ],
];

const List<List<int>> form7820Table = [
  [50, 160, 110],
  [49, 151, 105],
  [48, 142, 100],
  [47, 133, 94],
  [46, 124, 88],
  [45, 116, 82],
  [44, 108, 76],
  [43, 100, 70],
  [42, 92, 64],
  [41, 84, 58],
  [40, 76, 53],
  [39, 68, 48],
  [38, 60, 43],
  [37, 51, 38],
  [36, 42, 33],
  [35, 33, 28],
  [
    0,
    0,
    0,
  ],
];

const List<List<int>> oldForm7820Table = [
  [50, 160, 110],
  [49, 152, 105],
  [48, 144, 100],
  [47, 135, 95],
  [46, 127, 88],
  [45, 119, 83],
  [44, 110, 76],
  [43, 102, 71],
  [42, 94, 64],
  [41, 85, 59],
  [40, 77, 52],
  [39, 69, 48],
  [38, 60, 42],
  [37, 52, 38],
  [36, 43, 32],
  [35, 33, 28],
  [
    0,
    0,
    0,
  ],
];

int form85Pts(String? rank, int hits) {
  if (hits >= 212) {
    return rank == 'SGT' ? 160 : 110;
  } else if (hits >= 208) {
    return rank == 'SGT' ? 153 : 106;
  } else if (hits >= 204) {
    return rank == 'SGT' ? 146 : 102;
  } else if (hits >= 200) {
    return rank == 'SGT' ? 139 : 97;
  } else if (hits >= 196) {
    return rank == 'SGT' ? 132 : 92;
  } else if (hits >= 192) {
    return rank == 'SGT' ? 125 : 87;
  } else if (hits >= 189) {
    return rank == 'SGT' ? 118 : 82;
  } else if (hits >= 186) {
    return rank == 'SGT' ? 111 : 77;
  } else if (hits >= 182) {
    return rank == 'SGT' ? 104 : 72;
  } else if (hits >= 178) {
    return rank == 'SGT' ? 97 : 67;
  } else if (hits >= 174) {
    return rank == 'SGT' ? 90 : 62;
  } else if (hits >= 170) {
    return rank == 'SGT' ? 83 : 58;
  } else if (hits >= 166) {
    return rank == 'SGT' ? 76 : 54;
  } else if (hits >= 162) {
    return rank == 'SGT' ? 69 : 50;
  } else if (hits >= 157) {
    return rank == 'SGT' ? 62 : 46;
  } else if (hits >= 153) {
    return rank == 'SGT' ? 56 : 42;
  } else if (hits >= 149) {
    return rank == 'SGT' ? 50 : 38;
  } else if (hits >= 145) {
    return rank == 'SGT' ? 44 : 34;
  } else if (hits >= 141) {
    return rank == 'SGT' ? 38 : 30;
  } else if (hits >= 139) {
    return rank == 'SGT' ? 33 : 28;
  } else {
    return 0;
  }
}

const List<List<int>> oldForm85Table = [
  [212, 160, 110],
  [208, 153, 107],
  [204, 146, 102],
  [200, 139, 97],
  [196, 132, 92],
  [192, 125, 87],
  [189, 119, 82],
  [186, 112, 77],
  [182, 105, 72],
  [178, 98, 67],
  [174, 91, 62],
  [170, 85, 58],
  [166, 78, 54],
  [162, 71, 50],
  [157, 64, 46],
  [153, 57, 42],
  [149, 50, 38],
  [145, 44, 34],
  [141, 38, 30],
  [139, 33, 28],
  [
    0,
    0,
    0,
  ],
];

int form7304Pts(String? rank, int hits) {
  if (hits >= 106) {
    return rank == 'SGT' ? 160 : 110;
  } else if (hits >= 105) {
    return rank == 'SGT' ? 153 : 105;
  } else if (hits >= 104) {
    return rank == 'SGT' ? 146 : 100;
  } else if (hits >= 102) {
    return rank == 'SGT' ? 139 : 95;
  } else if (hits >= 100) {
    return rank == 'SGT' ? 132 : 90;
  } else if (hits >= 96) {
    return rank == 'SGT' ? 125 : 85;
  } else if (hits >= 94) {
    return rank == 'SGT' ? 118 : 80;
  } else if (hits >= 90) {
    return rank == 'SGT' ? 111 : 75;
  } else if (hits >= 89) {
    return rank == 'SGT' ? 104 : 70;
  } else if (hits >= 87) {
    return rank == 'SGT' ? 97 : 65;
  } else if (hits >= 85) {
    return rank == 'SGT' ? 90 : 60;
  } else if (hits >= 83) {
    return rank == 'SGT' ? 83 : 56;
  } else if (hits >= 81) {
    return rank == 'SGT' ? 76 : 52;
  } else if (hits >= 80) {
    return rank == 'SGT' ? 69 : 48;
  } else if (hits >= 79) {
    return rank == 'SGT' ? 62 : 44;
  } else if (hits >= 77) {
    return rank == 'SGT' ? 55 : 40;
  } else if (hits >= 75) {
    return rank == 'SGT' ? 48 : 36;
  } else if (hits >= 73) {
    return rank == 'SGT' ? 41 : 32;
  } else if (hits >= 70) {
    return rank == 'SGT' ? 33 : 28;
  } else {
    return 0;
  }
}

int formCidPts(String? rank, int hits) {
  if (hits == 300) {
    return rank == 'SGT' ? 160 : 110;
  } else if (hits >= 295) {
    return rank == 'SGT' ? 153 : 105;
  } else if (hits >= 290) {
    return rank == 'SGT' ? 146 : 100;
  } else if (hits >= 285) {
    return rank == 'SGT' ? 139 : 95;
  } else if (hits >= 280) {
    return rank == 'SGT' ? 132 : 90;
  } else if (hits >= 275) {
    return rank == 'SGT' ? 125 : 85;
  } else if (hits >= 270) {
    return rank == 'SGT' ? 118 : 80;
  } else if (hits >= 265) {
    return rank == 'SGT' ? 111 : 75;
  } else if (hits >= 260) {
    return rank == 'SGT' ? 104 : 70;
  } else if (hits >= 255) {
    return rank == 'SGT' ? 97 : 65;
  } else if (hits >= 250) {
    return rank == 'SGT' ? 90 : 60;
  } else if (hits >= 245) {
    return rank == 'SGT' ? 83 : 56;
  } else if (hits >= 240) {
    return rank == 'SGT' ? 76 : 52;
  } else if (hits >= 235) {
    return rank == 'SGT' ? 69 : 48;
  } else if (hits >= 230) {
    return rank == 'SGT' ? 62 : 44;
  } else if (hits >= 225) {
    return rank == 'SGT' ? 55 : 40;
  } else if (hits >= 220) {
    return rank == 'SGT' ? 48 : 36;
  } else if (hits >= 215) {
    return rank == 'SGT' ? 41 : 32;
  } else if (hits >= 210) {
    return rank == 'SGT' ? 33 : 28;
  } else {
    return 0;
  }
}
