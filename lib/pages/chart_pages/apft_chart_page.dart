import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  List<charts.Series<Apft, DateTime>> _seriesBarData = [];
  List<Apft>? myData;

  _generateData(List<Apft> myData) {
    _seriesBarData.clear();
    _seriesBarData.add(
      charts.Series(
          domainFn: (apft, _) => DateTime.parse(apft.date!),
          measureFn: (apft, _) => int.tryParse(apft.total),
          data: myData,
          id: 'Total',
          colorFn: (apft, _) => charts.MaterialPalette.black),
    );
    if (pu) {
      _seriesBarData.add(
        charts.Series(
            domainFn: (apft, _) => DateTime.parse(apft.date!),
            measureFn: (apft, _) => int.tryParse(apft.puScore),
            data: myData,
            id: 'PU',
            colorFn: (apft, _) => charts.MaterialPalette.blue.shadeDefault),
      );
    }
    if (su) {
      _seriesBarData.add(
        charts.Series(
            domainFn: (apft, _) => DateTime.parse(apft.date!),
            measureFn: (apft, _) => int.tryParse(apft.suScore),
            data: myData,
            id: 'SU',
            colorFn: (apft, _) => charts.MaterialPalette.green.shadeDefault),
      );
    }
    if (run) {
      _seriesBarData.add(
        charts.Series(
            domainFn: (apft, _) => DateTime.parse(apft.date!),
            measureFn: (apft, _) => int.tryParse(apft.runScore),
            data: myData,
            id: 'Run',
            colorFn: (apft, _) => charts.MaterialPalette.red.shadeDefault),
      );
    }
  }

  Widget _buildChart() {
    double width = MediaQuery.of(context).size.width;
    _generateData(myData!);
    return SizedBox(
      width: width - 32,
      height: MediaQuery.of(context).size.height / 2,
      child: charts.TimeSeriesChart(
        _seriesBarData,
        defaultRenderer: charts.LineRendererConfig(),
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          new charts.SeriesLegend(
            desiredMaxRows: 2,
            entryTextStyle: charts.TextStyleSpec(
              color: charts.Color(r: 0, g: 0, b: 0),
            ),
          )
        ],
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec:
                charts.BasicNumericTickProviderSpec(zeroBound: false)),
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
    myData = widget.apfts;
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
                    ? width / 240
                    : width > 400
                        ? width / 160
                        : width / 80,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: PlatformCheckboxListTile(
                      title: const Text('PU'),
                      value: pu,
                      activeColor: getOnPrimaryColor(context),
                      onChanged: (value) {
                        setState(() {
                          pu = value!;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: PlatformCheckboxListTile(
                      title: const Text('SU'),
                      value: su,
                      activeColor: getOnPrimaryColor(context),
                      onChanged: (value) {
                        setState(() {
                          su = value!;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: PlatformCheckboxListTile(
                      title: const Text('Run'),
                      value: run,
                      activeColor: getOnPrimaryColor(context),
                      onChanged: (value) {
                        setState(() {
                          run = value!;
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
