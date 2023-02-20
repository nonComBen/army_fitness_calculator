import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';
  List<charts.Series<PPW, DateTime>> _seriesBarData = [];
  List<PPW>? myData;

  _generateData(List<PPW> myData) {
    _seriesBarData.clear();
    _seriesBarData = [
      charts.Series(
          domainFn: (ppw, _) => DateTime.parse(ppw.date!),
          measureFn: (ppw, _) => ppw.total,
          data: myData,
          id: 'Total',
          colorFn: (bf, _) => charts.MaterialPalette.black),
    ];
    if (milTrain) {
      _seriesBarData.add(
        charts.Series(
          domainFn: (ppw, _) => DateTime.parse(ppw.date!),
          measureFn: (ppw, _) {
            int milTrainPts = ppw.ptTest + ppw.weapons;
            if (milTrainPts > ppw.milTrainMax) {
              milTrainPts = ppw.milTrainMax;
            }
            return milTrainPts;
          },
          data: myData,
          id: 'Mil Train',
          colorFn: (bf, _) => charts.MaterialPalette.blue.shadeDefault,
        )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
      );
    }
    if (awards) {
      _seriesBarData.add(
        charts.Series(
          domainFn: (ppw, _) => DateTime.parse(ppw.date!),
          measureFn: (ppw, _) {
            int awardsPts = ppw.awards + ppw.badges;
            if (awardsPts > ppw.awardsMax) {
              awardsPts = ppw.awardsMax;
            }
            return awardsPts + ppw.airborne;
          },
          data: myData,
          id: 'Awards',
          colorFn: (bf, _) => charts.MaterialPalette.green.shadeDefault,
        )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
      );
    }
    if (milEd) {
      _seriesBarData.add(
        charts.Series(
          domainFn: (ppw, _) => DateTime.parse(ppw.date!),
          measureFn: (ppw, _) {
            int milEdpts = ppw.ncoes + ppw.resident + ppw.wbc + ppw.tabs;
            if (milEdpts > ppw.milEdMax) {
              milEdpts = ppw.milEdMax;
            }
            return milEdpts;
          },
          data: myData,
          id: 'Mil Ed',
          colorFn: (bf, _) => charts.MaterialPalette.red.shadeDefault,
        )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
      );
    }
    if (civEd) {
      _seriesBarData.add(
        charts.Series(
          domainFn: (ppw, _) => DateTime.parse(ppw.date!),
          measureFn: (ppw, _) {
            int civEdPts =
                ppw.semesterHours + ppw.degree + ppw.certs + ppw.language;
            if (civEdPts > ppw.civEdMax) {
              civEdPts = ppw.civEdMax;
            }
            return civEdPts;
          },
          data: myData,
          id: 'Civ Ed',
          colorFn: (bf, _) => charts.MaterialPalette.yellow.shadeDefault,
        )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
      );
    }
  }

  Widget _buildChart() {
    final width = MediaQuery.of(context).size.width;
    _generateData(myData!);
    return SizedBox(
      width: width - 32,
      height: MediaQuery.of(context).size.height / 2,
      child: charts.TimeSeriesChart(
        _seriesBarData,
        defaultRenderer: new charts.LineRendererConfig(),
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          new charts.SeriesLegend(
            desiredMaxRows: 2,
            desiredMaxColumns: width < 600 ? 3 : 5,
            entryTextStyle: charts.TextStyleSpec(
              color: charts.Color(r: 0, g: 0, b: 0),
            ),
          ),
        ],
        primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec: new charts.BasicNumericTickProviderSpec(
            zeroBound: false,
            desiredTickCount: 3,
          ),
        ),
      ),
    );
  }

  // takeScreenshot() async {
  //   bool permissionGranted;
  //   if (Platform.isAndroid) {
  //     permissionGranted = await Permission.storage.request().isGranted;
  //   } else {
  //     permissionGranted = await Permission.photos.request().isGranted;
  //   }

  //   if (permissionGranted) {
  //     try {
  //       RenderRepaintBoundary boundary =
  //           previewContainer.currentContext.findRenderObject();
  //       ui.Image image = await boundary.toImage();
  //       ByteData byteData =
  //           await image.toByteData(format: ui.ImageByteFormat.png);
  //       Uint8List pngBytes = byteData.buffer.asUint8List();
  //       await PhotosSaver.saveFile(fileData: pngBytes);
  //       String location =
  //           Platform.isAndroid ? 'Gallery Album "Pictures"' : 'Photos';
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Image saved to $location'),
  //       ));
  //     } catch (e) {
  //       print('Error: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Failed to save image'),
  //       ));
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('You must allow permission to save screenshot'),
  //     ));
  //   }
  // }

  @override
  void initState() {
    myData = widget.ppws;
    super.initState();
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
                    _buildChart(),
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
