import 'package:acft_calculator/widgets/line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../methods/theme_methods.dart';
import '../../sqlite/ppw.dart';
import '../../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class PpwChartPage extends StatefulWidget {
  PpwChartPage({this.ppws, this.soldier});
  final List<PPW>? ppws;
  final String? soldier;

  @override
  _PpwChartPageState createState() => _PpwChartPageState();
}

class _PpwChartPageState extends State<PpwChartPage> {
  bool milTrain = false, awards = false, milEd = false, civEd = false;
  late List<double> dates;

  @override
  void initState() {
    super.initState();
    dates = widget.ppws!
        .map((e) => MyLineChart.convertDateToDouble(e.date!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                    Center(
                        child: Text(
                      'Promotion Point Progress for ${widget.soldier}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    const SizedBox(
                      height: 15.0,
                    ),
                    MyLineChart(
                      minY: milTrain || awards || milEd || civEd ? 0 : 50,
                      maxY: 800,
                      dates: dates,
                      lineBarData: [
                        LineChartBarData(
                          color: getTextColor(context),
                          spots: widget.ppws!
                              .map((e) => FlSpot(
                                  MyLineChart.convertDateToDouble(e.date!),
                                  e.total.toDouble()))
                              .toList(),
                        ),
                        LineChartBarData(
                          color: Colors.blue,
                          show: milTrain,
                          spots: widget.ppws!.map((e) {
                            int score = e.ptTest + e.weapons;
                            if (score > e.milTrainMax) {
                              score = e.milTrainMax;
                            }
                            return FlSpot(
                                MyLineChart.convertDateToDouble(e.date!),
                                score.toDouble());
                          }).toList(),
                        ),
                        LineChartBarData(
                          color: Colors.green,
                          show: awards,
                          spots: widget.ppws!.map((e) {
                            int score = e.awards + e.badges;
                            if (score > e.awardsMax) {
                              score = e.awardsMax;
                            }
                            return FlSpot(
                                MyLineChart.convertDateToDouble(e.date!),
                                score.toDouble());
                          }).toList(),
                        ),
                        LineChartBarData(
                          color: Colors.yellow,
                          show: milEd,
                          spots: widget.ppws!.map((e) {
                            int score = e.ncoes + e.resident + e.wbc + e.tabs;
                            if (score > e.milEdMax) {
                              score = e.milEdMax;
                            }
                            return FlSpot(
                                MyLineChart.convertDateToDouble(e.date!),
                                score.toDouble());
                          }).toList(),
                        ),
                        LineChartBarData(
                          color: Colors.orange,
                          show: civEd,
                          spots: widget.ppws!.map((e) {
                            int score = e.semesterHours +
                                e.degree +
                                e.certs +
                                e.language;
                            if (score > e.civEdMax) {
                              score = e.civEdMax;
                            }
                            return FlSpot(
                                MyLineChart.convertDateToDouble(e.date!),
                                score.toDouble());
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              GridView.count(
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
                        title: const Text('Mil Train'),
                        value: milTrain,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            milTrain = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            milTrain = !milTrain;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text('Awards'),
                        value: awards,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            awards = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            awards = !awards;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text('Mil Ed'),
                        value: milEd,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            milEd = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            milEd = !milEd;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: PlatformCheckboxListTile(
                        title: const Text('Civ Ed'),
                        value: civEd,
                        activeColor: getOnPrimaryColor(context),
                        onChanged: (value) {
                          setState(() {
                            civEd = value!;
                          });
                        },
                        onIosTap: () {
                          setState(() {
                            civEd = !civEd;
                          });
                        },
                      ),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
