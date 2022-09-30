import 'package:flutter/material.dart';

import '../methods/delete_record.dart';
import './acftChartPage.dart';
import './acftDetailsPage.dart';
import '../sqlite/acft.dart';
import '../sqlite/dbHelper.dart';

class SavedAcftsPage extends StatefulWidget {
  @override
  _SavedAcftsPageState createState() => _SavedAcftsPageState();
}

class _SavedAcftsPageState extends State<SavedAcftsPage> {
  // Future<List<Acft>> acfts;
  DBHelper dbHelper;
  Color onPrimary, onError;

  // refreshList() {
  //   setState(() {
  //     acfts = dbHelper.getAcfts();
  //   });
  // }

  Widget nameHeader(List<Acft> acftList, String rank, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            rank == '' ? name : '$rank $name',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AcftChartPage(
                            acfts: acftList
                                .where((acft) => acft.name == name)
                                .toList(),
                            soldier: rank == '' ? name : '$rank $name',
                          )));
            },
          )
        ],
      ),
    );
  }

  ListView _list(List<Acft> acftList, double width) {
    List<Widget> widgets = [];
    String name;
    for (int i = 0; i < acftList.length; i++) {
      bool pass = acftList[i].pass == 1;
      if (i == 0) {
        name = acftList[i].name;
        widgets.add(
            nameHeader(acftList, acftList[i].rank ?? '', acftList[i].name));
      } else if (acftList[i].name != name) {
        name = acftList[i].name;
        widgets.add(
            nameHeader(acftList, acftList[i].rank ?? '', acftList[i].name));
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
              child: Text('Date: ${acftList[i].date}',
                  style: TextStyle(color: pass ? onPrimary : onError)),
            ),
            subtitle: GridView.count(
              crossAxisCount: width > 650 ? 4 : 3,
              primary: false,
              shrinkWrap: true,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
              childAspectRatio: width > 650 ? width / 200 : width / 150,
              children: <Widget>[
                Text('MDL: ${acftList[i].mdlScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('SPT: ${acftList[i].sptScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('HRP: ${acftList[i].hrpScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('SDC: ${acftList[i].sdcScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('PLK: ${acftList[i].plkScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('${acftList[i].runEvent}: ${acftList[i].runScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('Total: ${acftList[i].total}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: pass ? onPrimary : onError),
              onPressed: () {
                DeleteRecord.deleteRecord(
                    context: context,
                    onConfirm: () {
                      Navigator.pop(context);
                      dbHelper.deleteAcft(acftList[i].id);
                      // refreshList();
                    });
              },
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AcftDetailsPage(
                            acft: acftList[i],
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
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    onPrimary = Theme.of(context).colorScheme.onPrimary;
    onError = Theme.of(context).colorScheme.onError;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved ACFTs'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: dbHelper.getAcfts().asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null || snapshot.data.length == 0) {
              return const Center(
                  child: Text(
                'No ACFTs Found',
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
