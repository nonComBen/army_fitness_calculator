import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../sqlite/bodyfat.dart';

class BodyfatChartPage extends StatefulWidget {
  BodyfatChartPage({this.bodyfats, this.soldier});
  final List<Bodyfat> bodyfats;
  final String soldier;

  @override
  _BodyfatChartPageState createState() => _BodyfatChartPageState();
}

class _BodyfatChartPageState extends State<BodyfatChartPage> {
  bool bf;
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';
  List<charts.Series<Bodyfat, DateTime>> _seriesBarData = [];
  List<Bodyfat> myData;

  static GlobalKey previewContainer = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  _generateData(List<Bodyfat> myData) {
    _seriesBarData.clear();
    _seriesBarData = [
      charts.Series(
          domainFn: (bf, _) => DateTime.parse(bf.date),
          measureFn: (bf, _) => int.tryParse(bf.weight),
          data: myData,
          id: 'Total',
          colorFn: (bf, _) => Theme.of(context).brightness == Brightness.light
              ? charts.Color.black
              : charts.Color.white),
    ];
    if (bf) {
      _seriesBarData.add(charts.Series(
        domainFn: (bf, _) => DateTime.parse(bf.date),
        measureFn: (bf, _) => int.tryParse(bf.bfPercent),
        data: myData,
        id: 'Bodyfat',
        colorFn: (bf, _) => charts.MaterialPalette.blue.shadeDefault,
      )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId));
    }
  }

  Widget _buildChart() {
    final width = MediaQuery.of(context).size.width;
    _generateData(myData);
    return SizedBox(
      width: width - 32,
      height: MediaQuery.of(context).size.height / 2,
      child: charts.TimeSeriesChart(
        _seriesBarData,
        defaultRenderer: new charts.LineRendererConfig(),
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [new charts.SeriesLegend()],
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                zeroBound: false, desiredTickCount: 3)),
        secondaryMeasureAxis: bf
            ? new charts.NumericAxisSpec(
                tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                    zeroBound: false, desiredTickCount: 3))
            : null,
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
    bf = false;

    myData = widget.bodyfats;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('${widget.soldier} Progress'),
        actions: <Widget>[
          // new IconButton(
          //     icon: new Icon(Icons.image),
          //     onPressed: () {
          //       takeScreenshot();
          //     })
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
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
                      _buildChart(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              CheckboxListTile(
                title: const Text('Bodyfat'),
                value: bf,
                activeColor: Theme.of(context).colorScheme.onSecondary,
                onChanged: (value) {
                  setState(() {
                    bf = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
