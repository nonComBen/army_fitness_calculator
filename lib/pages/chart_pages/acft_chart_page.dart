import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../sqlite/acft.dart';
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
  List<charts.Series<Acft, DateTime>> _seriesBarData = [];
  List<Acft>? myData;

  static GlobalKey previewContainer = new GlobalKey();

  _generateData(List<Acft> myData) {
    _seriesBarData.clear();
    _seriesBarData.add(charts.Series(
        domainFn: (acft, _) => DateTime.parse(acft.date!),
        measureFn: (acft, _) => int.tryParse(acft.total),
        data: myData,
        id: 'Total',
        colorFn: (acft, _) => Theme.of(context).brightness == Brightness.light
            ? charts.Color.black
            : charts.Color.white));
    if (mdl) {
      _seriesBarData.add(charts.Series(
          domainFn: (acft, _) => DateTime.parse(acft.date!),
          measureFn: (acft, _) => int.tryParse(acft.mdlScore),
          data: myData,
          id: 'MDL',
          colorFn: (acft, _) => charts.MaterialPalette.blue.shadeDefault));
    }
    if (spt) {
      _seriesBarData.add(charts.Series(
          domainFn: (acft, _) => DateTime.parse(acft.date!),
          measureFn: (acft, _) => int.tryParse(acft.sptScore),
          data: myData,
          id: 'SPT',
          colorFn: (acft, _) => charts.MaterialPalette.green.shadeDefault));
    }
    if (hrp) {
      _seriesBarData.add(charts.Series(
          domainFn: (acft, _) => DateTime.parse(acft.date!),
          measureFn: (acft, _) => int.tryParse(acft.hrpScore),
          data: myData,
          id: 'HRP',
          colorFn: (acft, _) => charts.MaterialPalette.yellow.shadeDefault));
    }
    if (sdc) {
      _seriesBarData.add(charts.Series(
          domainFn: (acft, _) => DateTime.parse(acft.date!),
          measureFn: (acft, _) => int.tryParse(acft.sdcScore),
          data: myData,
          id: 'SDC',
          colorFn: (acft, _) =>
              charts.MaterialPalette.deepOrange.shadeDefault));
    }
    if (plk) {
      _seriesBarData.add(charts.Series(
          domainFn: (acft, _) => DateTime.parse(acft.date!),
          measureFn: (acft, _) => int.tryParse(acft.plkScore),
          data: myData,
          id: 'PLK',
          colorFn: (acft, _) => charts.MaterialPalette.red.shadeDefault));
    }
    if (run) {
      _seriesBarData.add(charts.Series(
          domainFn: (acft, _) => DateTime.parse(acft.date!),
          measureFn: (acft, _) => int.tryParse(acft.runScore),
          data: myData,
          id: 'Run',
          colorFn: (acft, _) => charts.MaterialPalette.purple.shadeDefault));
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
        defaultRenderer: new charts.LineRendererConfig(),
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          new charts.SeriesLegend(
            desiredMaxRows: 2,
            desiredMaxColumns: width < 600 ? 4 : 7,
          )
        ],
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec:
                new charts.BasicNumericTickProviderSpec(zeroBound: false)),
      ),
    );
  }

  @override
  void initState() {
    myData = widget.acfts;
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
        child: new Center(
          child: new ListView(
            children: <Widget>[
              RepaintBoundary(
                key: previewContainer,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor),
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
                  PlatformCheckboxListTile(
                    title: Text('MDL'),
                    value: mdl,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    onChanged: (value) {
                      setState(() {
                        mdl = value!;
                      });
                    },
                  ),
                  PlatformCheckboxListTile(
                    title: const Text('SPT'),
                    value: spt,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    onChanged: (value) {
                      setState(() {
                        spt = value!;
                      });
                    },
                  ),
                  PlatformCheckboxListTile(
                    title: const Text('HRP'),
                    value: hrp,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    onChanged: (value) {
                      setState(() {
                        hrp = value!;
                      });
                    },
                  ),
                  PlatformCheckboxListTile(
                    title: const Text('SDC'),
                    value: sdc,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    onChanged: (value) {
                      setState(() {
                        sdc = value!;
                      });
                    },
                  ),
                  PlatformCheckboxListTile(
                    title: const Text('PLK'),
                    value: plk,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    onChanged: (value) {
                      setState(() {
                        plk = value!;
                      });
                    },
                  ),
                  PlatformCheckboxListTile(
                    title: const Text('Run'),
                    value: run,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    onChanged: (value) {
                      setState(() {
                        run = value!;
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
