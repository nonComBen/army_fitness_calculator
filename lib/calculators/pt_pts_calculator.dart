int acftPts(int score) {
  if (score < 360) {
    return 0;
  } else {
    return acftTable.firstWhere((element) => score >= element[0])[1];
  }
}

int apftPts(int score, String? rank) {
  int rankIndex = rank == 'SGT' ? 1 : 2;
  if (score < 180) {
    return 0;
  } else {
    return apftTable.firstWhere((element) => score >= element[0])[rankIndex];
  }
}

const List<List<int>> acftTable = [
  [600, 120],
  [595, 118],
  [590, 116],
  [585, 114],
  [580, 112],
  [575, 110],
  [570, 108],
  [565, 106],
  [560, 104],
  [555, 102],
  [550, 100],
  [545, 98],
  [540, 96],
  [535, 94],
  [530, 92],
  [525, 90],
  [520, 88],
  [515, 86],
  [510, 84],
  [505, 82],
  [500, 80],
  [495, 78],
  [490, 76],
  [485, 74],
  [480, 72],
  [475, 70],
  [470, 68],
  [465, 66],
  [460, 64],
  [455, 62],
  [450, 60],
  [445, 58],
  [440, 56],
  [435, 54],
  [430, 52],
  [425, 50],
  [420, 48],
  [415, 46],
  [410, 44],
  [405, 42],
  [400, 40],
  [395, 38],
  [390, 36],
  [385, 34],
  [380, 32],
  [375, 30],
  [370, 28],
  [365, 26],
  [360, 24],
];

const List<List<int>> apftTable = [
  [300, 180, 145],
  [299, 179, 144],
  [298, 178, 143],
  [297, 177, 142],
  [296, 176, 141],
  [295, 175, 140],
  [294, 174, 139],
  [293, 173, 138],
  [292, 172, 137],
  [291, 171, 136],
  [290, 170, 135],
  [289, 169, 134],
  [288, 168, 133],
  [287, 167, 132],
  [286, 166, 131],
  [285, 165, 130],
  [284, 164, 129],
  [283, 163, 128],
  [282, 162, 127],
  [281, 161, 126],
  [280, 160, 125],
  [279, 159, 124],
  [278, 158, 123],
  [277, 157, 122],
  [276, 156, 121],
  [275, 155, 120],
  [274, 154, 119],
  [273, 153, 118],
  [272, 152, 117],
  [271, 151, 116],
  [270, 150, 115],
  [269, 139, 89],
  [268, 138, 88],
  [267, 137, 87],
  [266, 166, 86],
  [265, 135, 85],
  [264, 144, 84],
  [263, 133, 83],
  [262, 132, 82],
  [261, 131, 81],
  [260, 130, 80],
  [259, 129, 79],
  [258, 128, 78],
  [257, 127, 77],
  [256, 126, 76],
  [255, 125, 75],
  [254, 124, 74],
  [253, 123, 73],
  [252, 122, 72],
  [251, 121, 71],
  [250, 120, 70],
  [249, 119, 69],
  [248, 118, 68],
  [247, 117, 67],
  [246, 116, 66],
  [245, 115, 65],
  [244, 114, 64],
  [243, 113, 63],
  [242, 112, 62],
  [241, 111, 61],
  [240, 110, 60],
  [239, 99, 44],
  [238, 98, 43],
  [237, 97, 42],
  [236, 96, 41],
  [235, 95, 41],
  [234, 94, 40],
  [233, 93, 40],
  [232, 92, 39],
  [231, 91, 39],
  [230, 90, 38],
  [229, 89, 38],
  [228, 88, 37],
  [227, 87, 37],
  [226, 86, 36],
  [225, 85, 36],
  [224, 84, 35],
  [223, 83, 35],
  [222, 82, 34],
  [221, 81, 34],
  [220, 80, 33],
  [219, 79, 33],
  [218, 78, 32],
  [217, 77, 32],
  [216, 76, 31],
  [215, 75, 31],
  [214, 74, 30],
  [213, 73, 30],
  [212, 72, 29],
  [211, 71, 29],
  [210, 70, 28],
  [209, 69, 28],
  [208, 68, 27],
  [207, 67, 27],
  [206, 66, 26],
  [205, 65, 26],
  [204, 64, 25],
  [203, 63, 25],
  [202, 62, 24],
  [201, 61, 24],
  [200, 60, 23],
  [199, 59, 23],
  [198, 58, 22],
  [197, 57, 22],
  [196, 56, 21],
  [195, 55, 21],
  [194, 54, 20],
  [193, 53, 20],
  [192, 52, 19],
  [191, 51, 19],
  [190, 50, 18],
  [189, 49, 18],
  [188, 48, 17],
  [187, 47, 17],
  [186, 46, 16],
  [185, 45, 16],
  [184, 44, 16],
  [183, 43, 15],
  [182, 42, 15],
  [181, 41, 15],
  [180, 40, 15],
];
