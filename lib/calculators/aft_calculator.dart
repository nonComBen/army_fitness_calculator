List<String> getAftMdlBenchmarks(int ageGroup, bool male) {
  // min, 80, max
  if (ageGroup < 1) {
    return male ? ['150', '250', '340'] : ['120', '150', '220'];
  } else if (ageGroup < 2) {
    return male ? ['150', '250', '350'] : ['120', '160', '230'];
  } else if (ageGroup < 3) {
    return male ? ['150', '250', '350'] : ['120', '160', '240'];
  } else if (ageGroup < 4) {
    return male ? ['140', '250', '350'] : ['120', '160', '230'];
  } else if (ageGroup < 5) {
    return male ? ['140', '250', '350'] : ['120', '150', '220'];
  } else if (ageGroup < 6) {
    return male ? ['140', '250', '350'] : ['120', '150', '210'];
  } else if (ageGroup < 7) {
    return male ? ['140', '240', '340'] : ['120', '150', '200'];
  } else if (ageGroup < 8) {
    return male ? ['140', '230', '330'] : ['120', '150', '190'];
  } else if (ageGroup < 9) {
    return male ? ['140', '170', '250'] : ['120', '140', '170'];
  } else {
    return male ? ['140', '160', '230'] : ['120', '140', '170'];
  }
}

List<String> getAftHrpBenchmarks(int ageGroup, bool male) {
  // min, 80, max
  if (ageGroup < 1) {
    return male ? ['15', '37', '58'] : ['11', '23', '53'];
  } else if (ageGroup < 2) {
    return male ? ['14', '37', '61'] : ['11', '23', '50'];
  } else if (ageGroup < 3) {
    return male ? ['14', '37', '62'] : ['11', '23', '48'];
  } else if (ageGroup < 4) {
    return male ? ['13', '36', '60'] : ['11', '23', '47'];
  } else if (ageGroup < 5) {
    return male ? ['12', '35', '59'] : ['10', '22', '43'];
  } else if (ageGroup < 6) {
    return male ? ['11', '34', '57'] : ['10', '21', '40'];
  } else if (ageGroup < 7) {
    return male ? ['11', '32', '55'] : ['10', '20', '38'];
  } else if (ageGroup < 8) {
    return male ? ['10', '30', '51'] : ['10', '19', '36'];
  } else if (ageGroup < 9) {
    return male ? ['10', '18', '46'] : ['10', '13', '24'];
  } else {
    return male ? ['10', '17', '43'] : ['10', '13', '24'];
  }
}

List<String> getAftSdcBenchmarks(int ageGroup, bool male) {
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
    return male ? ['2:45', '2:07', '1:40'] : ['3:42', '2:44', '2:09'];
  } else if (ageGroup < 7) {
    return male ? ['2:53', '2:14', '1:45'] : ['3:51', '2:50', '2:11'];
  } else if (ageGroup < 8) {
    return male ? ['3:00', '2:23', '1:52'] : ['4:03', '2:58', '2:18'];
  } else if (ageGroup < 9) {
    return male ? ['3:12', '2:29', '1:58'] : ['4:48', '3:07', '2:26'];
  } else {
    return male ? ['3:16', '2:32', '2:09'] : ['4:48', '3:07', '2:26'];
  }
}

List<String> getAftPlkBenchmarks(int ageGroup, bool male) {
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
    return male ? ['1:10', '2:15', '3:20'] : ['1:10', '2:15', '3:20'];
  } else if (ageGroup < 8) {
    return male ? ['1:10', '2:15', '3:20'] : ['1:10', '2:15', '3:20'];
  } else if (ageGroup < 9) {
    return male ? ['1:10', '2:15', '3:20'] : ['1:10', '2:15', '3:20'];
  } else {
    return male ? ['1:10', '2:15', '3:20'] : ['1:10', '2:15', '3:20'];
  }
}

List<String> getAft2mrBenchmarks(int ageGroup, bool male) {
  // min, 80, max
  if (ageGroup < 1) {
    return male ? ['19:57', '17:13', '13:22'] : ['22:55', '19:30', '16:00'];
  } else if (ageGroup < 2) {
    return male ? ['19:45', '17:08', '13:25'] : ['22:45', '19:25', '15:30'];
  } else if (ageGroup < 3) {
    return male ? ['19:45', '17:21', '13:25'] : ['22:45', '19:45', '15:30'];
  } else if (ageGroup < 4) {
    return male ? ['20:44', '17:16', '13:42'] : ['22:50', '19:53', '15:48'];
  } else if (ageGroup < 5) {
    return male ? ['20:44', '17:33', '13:42'] : ['22:59', '19:57', '15:51'];
  } else if (ageGroup < 6) {
    return male ? ['22:04', '17:47', '14:05'] : ['23:15', '20:10', '16:00'];
  } else if (ageGroup < 7) {
    return male ? ['22:04', '18:12', '14:30'] : ['23:30', '20:34', '16:30'];
  } else if (ageGroup < 8) {
    return male ? ['22:50', '19:00', '15:09'] : ['24:00', '21:19', '16:59'];
  } else if (ageGroup < 9) {
    return male ? ['23:36', '19:45', '15:28'] : ['24:48', '21:59', '17:18'];
  } else {
    return male ? ['23:36', '19:45', '15:28'] : ['25:00', '21:59', '17:18'];
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
