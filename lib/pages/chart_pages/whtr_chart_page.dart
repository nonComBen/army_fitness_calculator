import 'package:acft_calculator/widgets/line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../methods/theme_methods.dart';
import '../../sqlite/w_ht_ratio.dart';
import '../../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class WHtRChartPage extends StatefulWidget {
  WHtRChartPage({this.wHtRs, this.soldier});
  final List<WHtR>? wHtRs;
  final String? soldier;

  @override
  _WHtRChartPageState createState() => _WHtRChartPageState();
}

class _WHtRChartPageState extends State<WHtRChartPage> {
  bool showWHtR = true, showWaist = false;
  late List<double> dates;

  @override
  void initState() {
    super.initState();
    dates = widget.wHtRs!
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
                      'Waist Height Ration Progress for ${widget.soldier}',
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
                      minY: showWHtR ? 0.25 : 20,
                      maxY: showWaist ? 50 : .75,
                      dates: dates,
                      lineBarData: [
                        LineChartBarData(
                          color: getTextColor(context),
                          show: showWaist,
                          spots: widget.wHtRs!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.waist)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.blue,
                          show: showWHtR,
                          spots: widget.wHtRs!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.wHtRatio)))
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
                    'WHtR',
                    style: TextStyle(color: Colors.blue),
                  ),
                  value: showWHtR,
                  activeColor: getOnPrimaryColor(context),
                  onChanged: (value) {
                    setState(() {
                      showWHtR = value!;
                    });
                  },
                  onIosTap: () {
                    setState(() {
                      showWHtR = !showWHtR;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: PlatformCheckboxListTile(
                  title: const Text(
                    'Waist',
                    style: TextStyle(color: Colors.blue),
                  ),
                  value: showWaist,
                  activeColor: getOnPrimaryColor(context),
                  onChanged: (value) {
                    setState(() {
                      showWaist = value!;
                    });
                  },
                  onIosTap: () {
                    setState(() {
                      showWaist = !showWaist;
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
