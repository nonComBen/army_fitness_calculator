import 'package:flutter/material.dart';

import '../../methods/delete_record.dart';
import '../chart_pages/bodyfat_chart_page.dart';
import '../detail_pages/bodyfat_details_page.dart';
import '../../sqlite/bodyfat.dart';
import '../../sqlite/db_helper.dart';

class SavedBodyfatsPage extends StatefulWidget {
  @override
  _SavedBodyfatsPageState createState() => _SavedBodyfatsPageState();
}

class _SavedBodyfatsPageState extends State<SavedBodyfatsPage> {
  Future<List<Bodyfat>> bodyfats;
  DBHelper dbHelper;
  Color onPrimary, onError;

  refreshList() {
    setState(() {
      bodyfats = dbHelper.getBodyfats();
    });
  }

  List<Widget> _tapes(Bodyfat bf, bool pass) {
    if (bf.gender == 'Male') {
      return [
        Text('Neck: ${bf.neck}',
            style: TextStyle(color: pass ? onPrimary : onError)),
        Text('Waist: ${bf.waist}',
            style: TextStyle(color: pass ? onPrimary : onError))
      ];
    } else {
      return [
        Text('Neck: ${bf.neck}',
            style: TextStyle(color: pass ? onPrimary : onError)),
        Text('Waist: ${bf.waist}',
            style: TextStyle(color: pass ? onPrimary : onError)),
        Text(
          'Hip: ${bf.hip}',
          style: TextStyle(color: pass ? onPrimary : onError),
        )
      ];
    }
  }

  Widget nameHeader(List<Bodyfat> bfList, String rank, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            rank == '' ? name : '$rank $name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BodyfatChartPage(
                            bodyfats:
                                bfList.where((bf) => bf.name == name).toList(),
                            soldier: rank == '' ? name : '$rank $name',
                          )));
            },
          )
        ],
      ),
    );
  }

  ListView _list(List<Bodyfat> bfList, double width) {
    List<Widget> widgets = [];
    String name;
    for (int i = 0; i < bfList.length; i++) {
      bool pass = bfList[i].bfPass == 1 || bfList[i].bmiPass == 1;
      if (i == 0) {
        name = bfList[i].name;
        widgets.add(nameHeader(bfList, bfList[i].rank, bfList[i].name));
      } else if (bfList[i].name != name) {
        name = bfList[i].name;
        widgets.add(nameHeader(bfList, bfList[i].rank, bfList[i].name));
      }
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: pass
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Date: ${bfList[i].date}',
                  style: TextStyle(color: pass ? onPrimary : onError)),
            ),
            subtitle: Column(
              children: <Widget>[
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: width / 100,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  primary: false,
                  shrinkWrap: true,
                  children: <Widget>[
                    Text('Height: ${bfList[i].height}',
                        style: TextStyle(color: pass ? onPrimary : onError)),
                    Text('Weight: ${bfList[i].weight}',
                        style: TextStyle(color: pass ? onPrimary : onError)),
                  ],
                ),
                bfList[i].bmiPass == 1
                    ? SizedBox()
                    : GridView.count(
                        crossAxisCount: bfList[i].gender == 'Male' ? 2 : 3,
                        childAspectRatio: bfList[i].gender == 'Male'
                            ? width / 100
                            : width / 150,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0,
                        primary: false,
                        shrinkWrap: true,
                        children: _tapes(bfList[i], pass))
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: (pass ? onPrimary : onError)),
              onPressed: () {
                DeleteRecord.deleteRecord(
                  context: context,
                  onConfirm: () {
                    Navigator.pop(context);
                    dbHelper.deleteBodyfat(bfList[i].id);
                    refreshList();
                  },
                );
              },
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BodyfatDetailsPage(
                            bf: bfList[i],
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
    onPrimary = Theme.of(context).colorScheme.onPrimary;
    onError = Theme.of(context).colorScheme.onError;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Body Comps'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: bodyfats,
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data.length == 0) {
              return const Center(
                  child: Text(
                'No Body Compositions Found',
                style: TextStyle(fontSize: 18.0),
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
