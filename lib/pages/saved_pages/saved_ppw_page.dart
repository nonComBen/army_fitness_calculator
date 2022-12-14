import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chart_pages/ppw_charts_page.dart';
import '../detail_pages/ppw_details_page.dart';
import '../../sqlite/ppw.dart';
import '../../sqlite/db_helper.dart';

class SavedPpwsPage extends StatefulWidget {
  @override
  _SavedPpwsPageState createState() => _SavedPpwsPageState();
}

class _SavedPpwsPageState extends State<SavedPpwsPage> {
  Future<List<PPW>> ppws;
  DBHelper dbHelper;
  Color onPrimary, onError;

  refreshList() {
    setState(() {
      ppws = dbHelper.getPPWs();
    });
  }

  deleteRecord(PPW ppw) {
    final title = const Text('Delete Record');
    final content = Container(
      padding: const EdgeInsets.all(8.0),
      child: const Text('Are you sure you want to delete this record?'),
    );
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context2) => CupertinoAlertDialog(
                title: title,
                content: content,
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context2);
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.pop(context2);
                      dbHelper.deletePPW(ppw.id);
                      refreshList();
                    },
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context2) {
            return AlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context2);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.pop(context2);
                    dbHelper.deletePPW(ppw.id);
                    refreshList();
                  },
                )
              ],
            );
          });
    }
  }

  Widget nameHeader(List<PPW> ppwList, String name) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
          IconButton(
            icon: const Icon(Icons.show_chart),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PpwChartPage(
                            ppws: ppwList
                                .where((ppw) => ppw.name == name)
                                .toList(),
                            soldier: name,
                          )));
            },
          )
        ],
      ),
    );
  }

  ListView _list(List<PPW> ppwList, double width) {
    List<Widget> widgets = [];
    String name;
    for (int i = 0; i < ppwList.length; i++) {
      int milTrain = ppwList[i].ptTest + ppwList[i].weapons;
      int awards = ppwList[i].awards + ppwList[i].badges;
      int milEd = ppwList[i].ncoes +
          ppwList[i].wbc +
          ppwList[i].resident +
          ppwList[i].tabs;
      int civEd = ppwList[i].semesterHours +
          ppwList[i].degree +
          ppwList[i].certs +
          ppwList[i].language;
      if (milTrain > ppwList[i].milTrainMax) {
        milTrain = ppwList[i].milTrainMax;
      }
      if (awards > ppwList[i].awardsMax) {
        awards = ppwList[i].awardsMax;
      }
      if (milEd > ppwList[i].milEdMax) {
        milEd = ppwList[i].milEdMax;
      }
      if (civEd > ppwList[i].civEdMax) {
        civEd = ppwList[i].civEdMax;
      }
      awards += ppwList[i].airborne;
      if (i == 0) {
        name = ppwList[i].name;
        widgets.add(nameHeader(ppwList, ppwList[i].name));
      } else if (ppwList[i].name != name) {
        name = ppwList[i].name;
        widgets.add(nameHeader(ppwList, ppwList[i].name));
      }
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Date: ${ppwList[i].date}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${ppwList[i].total.toString()} / 800',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
                )
              ],
            ),
            subtitle: GridView.count(
              crossAxisCount: width > 1000
                  ? 4
                  : width > 650
                      ? 3
                      : 2,
              primary: false,
              shrinkWrap: true,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
              childAspectRatio: width > 1000
                  ? 120
                  : width > 650
                      ? width / 90
                      : width / 60,
              children: <Widget>[
                Text(
                  'MilTrain: $milTrain / ${ppwList[i].milTrainMax}',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                Text(
                  'Awards: $awards / ${ppwList[i].awardsMax}',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                Text(
                  'MilEd: $milEd / ${ppwList[i].milEdMax}',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                Text(
                  'CivEd: $civEd / ${ppwList[i].civEdMax}',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
            trailing: SizedBox(
              width: 30,
              child: IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  deleteRecord(ppwList[i]);
                },
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PpwDetailsPage(
                            ppw: ppwList[i],
                          )));
            },
          ),
        ),
      ));
    }

    return ListView(
      children: widgets,
    );
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // onPrimary = Theme.of(context).colorScheme.onPrimary;
    // onError = Theme.of(context).colorScheme.onError;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved PPWs'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: ppws,
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data.length == 0) {
              return Center(
                  child: Text(
                'No PPWs Found',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.onPrimary),
              ));
            }

            if (snapshot.hasData) {
              return _list(snapshot.data, width);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
