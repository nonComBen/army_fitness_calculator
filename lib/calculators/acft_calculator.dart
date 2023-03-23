List<String> getMdlBenchmarks(int ageGroup, bool male) {
  // min, 80, max
  if (ageGroup < 1) {
    return male ? ['140', '240', '340'] : ['120', '160', '210'];
  } else if (ageGroup < 2) {
    return male ? ['140', '250', '340'] : ['120', '160', '230'];
  } else if (ageGroup < 3) {
    return male ? ['140', '250', '340'] : ['120', '160', '230'];
  } else if (ageGroup < 4) {
    return male ? ['140', '240', '340'] : ['120', '160', '230'];
  } else if (ageGroup < 5) {
    return male ? ['140', '220', '340'] : ['120', '160', '210'];
  } else if (ageGroup < 6) {
    return male ? ['140', '210', '340'] : ['120', '160', '210'];
  } else if (ageGroup < 7) {
    return male ? ['140', '230', '330'] : ['120', '160', '190'];
  } else if (ageGroup < 8) {
    return male ? ['140', '210', '290'] : ['120', '150', '190'];
  } else if (ageGroup < 9) {
    return male ? ['140', '180', '250'] : ['120', '150', '170'];
  } else {
    return male ? ['140', '170', '230'] : ['120', '150', '170'];
  }
}

List<String> getSptBenchmarks(int ageGroup, bool male) {
  // min, 80, max
  if (ageGroup < 1) {
    return male ? ['6.0', '9.3', '12.6'] : ['3.9', '5.8', '8.4'];
  } else if (ageGroup < 2) {
    return male ? ['6.3', '9.7', '13.0'] : ['4.0', '5.9', '8.5'];
  } else if (ageGroup < 3) {
    return male ? ['6.5', '9.8', '13.1'] : ['4.2', '6.1', '8.7'];
  } else if (ageGroup < 4) {
    return male ? ['6.5', '9.8', '12.9'] : ['4.1', '5.9', '8.6'];
  } else if (ageGroup < 5) {
    return male ? ['6.4', '9.6', '12.8'] : ['4.1', '5.7', '8.2'];
  } else if (ageGroup < 6) {
    return male ? ['6.2', '9.2', '12.3'] : ['3.9', '5.7', '8.1'];
  } else if (ageGroup < 7) {
    return male ? ['6.0', '9.7', '11.6'] : ['3.7', '6.0', '7.8'];
  } else if (ageGroup < 8) {
    return male ? ['5.7', '9.0', '10.6'] : ['3.5', '5.7', '7.4'];
  } else if (ageGroup < 9) {
    return male ? ['5.3', '8.5', '9.9'] : ['3.4', '5.5', '6.6'];
  } else {
    return male ? ['4.9', '8.0', '9.0'] : ['3.4', '5.5', '6.6'];
  }
}

List<String> getHrpBenchmarks(int ageGroup, bool male) {
  // min, 80, max
  if (ageGroup < 1) {
    return male ? ['10', '37', '57'] : ['10', '27', '53'];
  } else if (ageGroup < 2) {
    return male ? ['10', '35', '61'] : ['10', '24', '50'];
  } else if (ageGroup < 3) {
    return male ? ['10', '35', '62'] : ['10', '21', '48'];
  } else if (ageGroup < 4) {
    return male ? ['10', '33', '60'] : ['10', '19', '47'];
  } else if (ageGroup < 5) {
    return male ? ['10', '30', '59'] : ['10', '16', '41'];
  } else if (ageGroup < 6) {
    return male ? ['10', '28', '56'] : ['10', '20', '36'];
  } else if (ageGroup < 7) {
    return male ? ['10', '34', '55'] : ['10', '20', '35'];
  } else if (ageGroup < 8) {
    return male ? ['10', '31', '51'] : ['10', '17', '30'];
  } else if (ageGroup < 9) {
    return male ? ['10', '29', '46'] : ['10', '15', '24'];
  } else {
    return male ? ['10', '26', '43'] : ['10', '15', '24'];
  }
}

List<String> getSdcBenchmarks(int ageGroup, bool male) {
  // min, 80, max
  if (ageGroup < 1) {
    return male ? ['2:28', '1:53', '1:29'] : ['3:15', '2:28', '1:55'];
  } else if (ageGroup < 2) {
    return male ? ['2:31', '1:53', '1:30'] : ['3:15', '2:29', '1:55'];
  } else if (ageGroup < 3) {
    return male ? ['2:32', '1:55', '1:30'] : ['3:15', '2:29', '1:55'];
  } else if (ageGroup < 4) {
    return male ? ['2:36', '1:58', '1:33'] : ['3:22', '2:34', '1:59'];
  } else if (ageGroup < 5) {
    return male ? ['2:41', '2:02', '1:36'] : ['3:27', '2:38', '2:02'];
  } else if (ageGroup < 6) {
    return male ? ['2:45', '2:07', '1:40'] : ['3:42', '2:30', '2:09'];
  } else if (ageGroup < 7) {
    return male ? ['2:53', '2:02', '1:45'] : ['3:51', '2:37', '2:11'];
  } else if (ageGroup < 8) {
    return male ? ['3:00', '2:10', '1:52'] : ['4:03', '2:44', '2:18'];
  } else if (ageGroup < 9) {
    return male ? ['3:12', '2:17', '1:58'] : ['4:48', '2:54', '2:26'];
  } else {
    return male ? ['3:16', '2:16', '2:09'] : ['4:48', '2:54', '2:26'];
  }
}

List<String> getPlkBenchmarks(int ageGroup, bool male) {
  // min, 80, max
  if (ageGroup < 1) {
    return male ? ['1:30', '2:35', '3:40'] : ['1:30', '2:35', '3:40'];
  } else if (ageGroup < 2) {
    return male ? ['1:25', '2:30', '3:35'] : ['1:25', '2:30', '3:35'];
  } else if (ageGroup < 3) {
    return male ? ['1:20', '2:25', '3:30'] : ['1:20', '2:25', '3:30'];
  } else if (ageGroup < 4) {
    return male ? ['1:15', '2:20', '3:25'] : ['1:15', '2:20', '3:25'];
  } else if (ageGroup < 5) {
    return male ? ['1:10', '2:15', '3:20'] : ['1:10', '2:15', '3:20'];
  } else if (ageGroup < 6) {
    return male ? ['1:10', '2:15', '3:20'] : ['1:10', '2:15', '3:20'];
  } else if (ageGroup < 7) {
    return male ? ['1:10', '2:47', '3:20'] : ['1:10', '2:47', '3:20'];
  } else if (ageGroup < 8) {
    return male ? ['1:10', '2:47', '3:20'] : ['1:10', '2:47', '3:20'];
  } else if (ageGroup < 9) {
    return male ? ['1:10', '2:47', '3:20'] : ['1:10', '2:47', '3:20'];
  } else {
    return male ? ['1:10', '2:47', '3:20'] : ['1:10', '2:47', '3:20'];
  }
}

List<String> get2mrBenchmarks(int ageGroup, bool male) {
  // min, 80, max
  if (ageGroup < 1) {
    return male ? ['22:00', '16:57', '13:22'] : ['23:22', '19:17', '15:29'];
  } else if (ageGroup < 2) {
    return male ? ['22:00', '17:13', '13:27'] : ['23:15', '19:03', '15:00'];
  } else if (ageGroup < 3) {
    return male ? ['22:00', '17:14', '13:31'] : ['23:13', '19:00', '15:00'];
  } else if (ageGroup < 4) {
    return male ? ['22:00', '17:23', '13:42'] : ['23:19', '19:15', '15:18'];
  } else if (ageGroup < 5) {
    return male ? ['22:11', '17:38', '13:58'] : ['23:23', '19:22', '15:30'];
  } else if (ageGroup < 6) {
    return male ? ['22:32', '17:55', '14:05'] : ['23:42', '18:16', '15:49'];
  } else if (ageGroup < 7) {
    return male ? ['22:55', '16:57', '14:30'] : ['24:00', '18:24', '15:58'];
  } else if (ageGroup < 8) {
    return male ? ['23:20', '17:36', '15:09'] : ['24:24', '18:53', '16:29'];
  } else if (ageGroup < 9) {
    return male ? ['23:36', '18:17', '15:28'] : ['24:48', '18:59', '17:18'];
  } else {
    return male ? ['23:36', '18:17', '15:28'] : ['25:00', '18:59', '17:18'];
  }
}

List<String> getAltBenchmarks(int ageGroup, bool male) {
  // walk, bike, swim/row
  if (ageGroup < 1) {
    return male ? ['31:00', '26:25', '30:48'] : ['34:00', '28:58', '33:48'];
  } else if (ageGroup < 2) {
    return male ? ['30:45', '26:12', '30:30'] : ['33:30', '28:31', '33:18'];
  } else if (ageGroup < 3) {
    return male ? ['30:30', '26:00', '30:20'] : ['33:00', '28:07', '32:48'];
  } else if (ageGroup < 4) {
    return male ? ['30:45', '26:12', '30:30'] : ['33:30', '28:31', '33:18'];
  } else if (ageGroup < 5) {
    return male ? ['31:00', '26:25', '30:48'] : ['34:00', '28:58', '33:48'];
  } else if (ageGroup < 6) {
    return male ? ['31:00', '26:25', '30:48'] : ['34:00', '28:58', '33:48'];
  } else if (ageGroup < 7) {
    return male ? ['32:00', '27:16', '31:48'] : ['35:00', '29:50', '34:48'];
  } else if (ageGroup < 8) {
    return male ? ['32:00', '27:16', '31:48'] : ['35:00', '29:50', '34:48'];
  } else if (ageGroup < 9) {
    return male ? ['33:00', '28:07', '32:50'] : ['36:00', '30:41', '35:48'];
  } else {
    return male ? ['33:00', '28:07', '32:50'] : ['36:00', '30:41', '35:48'];
  }
}
