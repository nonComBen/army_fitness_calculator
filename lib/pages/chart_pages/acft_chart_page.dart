import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../sqlite/acft.dart';
import '../../widgets/line_chart.dart';
import '../../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class AcftChartPage extends StatefulWidget {
  AcftChartPage({this.acfts, this.soldier});
  final List<Acft>? acfts;
  final String? soldier;

  @override
  _AcftChartPageState createState() => _AcftChartPageState();
}

class _AcftChartPageState extends State<AcftChartPage> {
  bool mdl = false,
      spt = false,
      hrp = false,
      sdc = false,
      plk = false,
      run = false;
  late List<double> dates;

  @override
  void initState() {
    dates = widget.acfts!
        .map((e) => MyLineChart.convertDateToDouble(e.date!))
        .toList();
    dates.sort(((a, b) => a.compareTo(b)));
    super.initState();
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
                      'ACFT Progress for ${widget.soldier}',
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
                      minY: mdl || spt || hrp || sdc || plk || run ? 0 : 200,
                      maxY: 600,
                      dates: dates,
                      lineBarData: [
                        LineChartBarData(
                          color: getTextColor(context),
                          spots: widget.acfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.total)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.blue,
                          show: mdl,
                          spots: widget.acfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.mdlScore)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.green,
                          show: spt,
                          spots: widget.acfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.sptScore)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.yellow,
                          show: hrp,
                          spots: widget.acfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.hrpScore)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.orange,
                          show: sdc,
                          spots: widget.acfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.sdcScore)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.red,
                          show: plk,
                          spots: widget.acfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.plkScore)))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.purple,
                          show: run,
                          spots: widget.acfts!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  double.parse(e.runScore)))
                              .toList(),
                        )
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
                        title: Text(
                          'MDL',
                          style: TextStyle(color: Colors.blue),
                        ),
                        value: mdl,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            mdl = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            mdl = !mdl;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text(
                          'SPT',
                          style: TextStyle(color: Colors.green),
                        ),
                        value: spt,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            spt = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            spt = !spt;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text(
                          'HRP',
                          style: TextStyle(color: Colors.yellow),
                        ),
                        value: hrp,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            hrp = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            hrp = !hrp;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text(
                          'SDC',
                          style: TextStyle(color: Colors.orange),
                        ),
                        value: sdc,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            sdc = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            sdc = !sdc;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text(
                          'PLK',
                          style: TextStyle(color: Colors.red),
                        ),
                        value: plk,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            plk = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            plk = !plk;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text(
                          'Run',
                          style: TextStyle(color: Colors.purple),
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
