import 'package:acft_calculator/widgets/line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../methods/theme_methods.dart';
import '../../sqlite/bodyfat.dart';
import '../../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class BodyfatChartPage extends StatefulWidget {
  BodyfatChartPage({this.bodyfats, this.soldier});
  final List<Bodyfat>? bodyfats;
  final String? soldier;

  @override
  _BodyfatChartPageState createState() => _BodyfatChartPageState();
}

class _BodyfatChartPageState extends State<BodyfatChartPage> {
  bool bf = false;
  late List<double> dates;

  @override
  void initState() {
    super.initState();
    dates = widget.bodyfats!
        .map((e) => MyLineChart.convertDateToDouble(e.date!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      title: '${widget.soldier} Progress',
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: getContrastingBackgroundColor(context),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Body Comp Progress for ${widget.soldier}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    MyLineChart(
                      minY: bf ? 0 : 50,
                      maxY: 300,
                      dates: dates,
                      lineBarData: [
                        LineChartBarData(
                          color: getTextColor(context),
                          spots: widget.bodyfats!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.weight)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.blue,
                          show: bf,
                          spots: widget.bodyfats!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.bfPercent)))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: PlatformCheckboxListTile(
                  title: const Text(
                    'Bodyfat',
                    style: TextStyle(color: Colors.blue),
                  ),
                  value: bf,
                  activeColor: getOnPrimaryColor(context),
                  onChanged: (value) {
                    setState(() {
                      bf = value!;
                    });
                  },
                  onIosTap: () {
                    setState(() {
                      bf = !bf;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
