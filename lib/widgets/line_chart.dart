import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyLineChart extends StatelessWidget {
  const MyLineChart({
    super.key,
    this.minY = 0,
    required this.maxY,
    this.lineBarData = const [],
    this.dates = const [],
  });
  final double minY, maxY;
  final List<LineChartBarData> lineBarData;
  final List<double> dates;

  static double convertDateToDouble(String date) {
    DateTime dateTime = DateTime.parse(date);
    return dateTime.millisecondsSinceEpoch.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width - 32,
      height: width - 32,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          minX: dates.first,
          maxX: dates.last,
          lineTouchData: LineTouchData(enabled: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                reservedSize: 28,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(value.toInt().toString()),
                ),
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                reservedSize: 28,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(value.toInt().toString()),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (dates.last - dates.first) / 4,
                reservedSize: 82,
                getTitlesWidget: (value, meta) {
                  if (value != meta.max &&
                      (dates.last - value) < ((dates.last - dates.first) / 8)) {
                    return Text('');
                  }
                  DateTime dateTime =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  DateFormat format = DateFormat('d-MMM-yy');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        format.format(dateTime),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          lineBarsData: lineBarData,
        ),
      ),
    );
  }
}
