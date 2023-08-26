import 'package:acft_calculator/widgets/line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../methods/theme_methods.dart';
import '../../sqlite/apft.dart';
import '../../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class ApftChartPage extends StatefulWidget {
  ApftChartPage({this.apfts, this.soldier});
  final List<Apft>? apfts;
  final String? soldier;

  @override
  _ApftChartPageState createState() => _ApftChartPageState();
}

class _ApftChartPageState extends State<ApftChartPage> {
  bool pu = false, su = false, run = false;
  late List<double> dates;

  @override
  void initState() {
    super.initState();
    dates = widget.apfts!
        .map((e) => MyLineChart.convertDateToDouble(e.date!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                      'APFT Progress for ${widget.soldier}',
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
                      minY: pu || su || run ? 0 : 100,
                      maxY: 300,
                      dates: dates,
                      lineBarData: [
                        LineChartBarData(
                          color: getTextColor(context),
                          spots: widget.apfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.total)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.blue,
                          show: pu,
                          spots: widget.apfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.puScore)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.green,
                          show: su,
                          spots: widget.apfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.suScore)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.yellow,
                          show: run,
                          spots: widget.apfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.runScore)))
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
              Card(
                color: getContrastingBackgroundColor(context),
                child: GridView.count(
                  crossAxisCount: width > 700
                      ? 3
                      : width > 400
                          ? 2
                          : 1,
                  primary: false,
                  shrinkWrap: true,
                  childAspectRatio: width > 700
                      ? width / 300
                      : width > 400
                          ? width / 200
                          : width / 100,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text(
                          'PU',
                          style: TextStyle(color: Colors.blue),
                        ),
                        value: pu,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            pu = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            pu = !pu;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text(
                          'SU',
                          style: TextStyle(color: Colors.green),
                        ),
                        value: su,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            su = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            su = !su;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text(
                          'Run',
                          style: TextStyle(color: Colors.yellow),
                        ),
                        value: run,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            run = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            run = !run;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
