double setWHtRBenchmarks(double height) {
  double max;

  max = (height * 0.55 * 10).floor() / 10;

  return max;
}

double getWHtR({
  required double height,
  required double waist,
}) {
  return (waist / height * 1000).floor() / 1000;
}
