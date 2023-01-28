import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../sqlite/apft.dart';

class ApftChartPage extends StatefulWidget {
  ApftChartPage({this.apfts, this.soldier});
  final List<Apft>? apfts;
  final String? soldier;

  @override
  _ApftChartPageState createState() => _ApftChartPageState();
}

class _ApftChartPageState extends State<ApftChartPage> {
  bool? pu, su, run;
  List<charts.Series<Apft, DateTime>> _seriesBarData = [];
  List<Apft>? myData;

  static GlobalKey previewContainer = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  _generateData(List<Apft> myData) {
    _seriesBarData.clear();
    _seriesBarData.add(charts.Series(
        domainFn: (apft, _) => DateTime.parse(apft.date!),
        measureFn: (apft, _) => int.tryParse(apft.total),
        data: myData,
        id: 'Total',
        colorFn: (apft, _) => Theme.of(context).brightness == Brightness.light
            ? charts.Color.black
            : charts.Color.white));
    if (pu!) {
      _seriesBarData.add(charts.Series(
          domainFn: (apft, _) => DateTime.parse(apft.date!),
          measureFn: (apft, _) => int.tryParse(apft.puScore),
          data: myData,
          id: 'PU',
          colorFn: (apft, _) => charts.MaterialPalette.blue.shadeDefault));
    }
    if (su!) {
      _seriesBarData.add(charts.Series(
          domainFn: (apft, _) => DateTime.parse(apft.date!),
          measureFn: (apft, _) => int.tryParse(apft.suScore),
          data: myData,
          id: 'SU',
          colorFn: (apft, _) => charts.MaterialPalette.green.shadeDefault));
    }
    if (run!) {
      _seriesBarData.add(charts.Series(
          domainFn: (apft, _) => DateTime.parse(apft.date!),
          measureFn: (apft, _) => int.tryParse(apft.runScore),
          data: myData,
          id: 'Run',
          colorFn: (apft, _) => charts.MaterialPalette.red.shadeDefault));
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
    pu = false;
    su = false;
    run = false;

    myData = widget.apfts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: new Text('${widget.soldier} Progress'),
        actions: <Widget>[
          // new IconButton(
          //     icon: new Icon(Icons.image),
          //     onPressed: () {
          //       takeScreenshot();
          //     })
        ],
      ),
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
              RepaintBoundary(
                key: previewContainer,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor),
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
                  CheckboxListTile(
                    title: const Text('PU'),
                    value: pu,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    onChanged: (value) {
                      setState(() {
                        pu = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('SU'),
                    value: su,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    onChanged: (value) {
                      setState(() {
                        su = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Run'),
                    value: run,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    onChanged: (value) {
                      setState(() {
                        run = value;
                      });
                    },
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
