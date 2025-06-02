import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../methods/delete_record.dart';
import '../../methods/theme_methods.dart';
import '../../sqlite/aft.dart';
import '../../widgets/my_toast.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_list_tile.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../../sqlite/db_helper.dart';
import '../chart_pages/aft_chart_page.dart';
import '../detail_pages/aft_details_page.dart';

class SavedAftsPage extends StatefulWidget {
  static const String routeName = 'savedAftsRoute';
  @override
  _SavedAftsPageState createState() => _SavedAftsPageState();
}

class _SavedAftsPageState extends State<SavedAftsPage> {
  Future<List<Aft>>? afts;
  DBHelper dbHelper = DBHelper();
  Color? onPrimary, onError;

  refreshList() {
    setState(() {
      afts = dbHelper.getAfts();
    });
  }

  Widget nameHeader(List<Aft> aftList, String rank, String? name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            rank == '' ? name! : '$rank $name',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          PlatformIconButton(
            icon: Icon(
              Icons.show_chart,
              color: getTextColor(context),
            ),
            onPressed: () {
              if (aftList.where((acft) => acft.name == name).toList().length >
                  1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AftChartPage(
                      afts: aftList.where((aft) => aft.name == name).toList(),
                      soldier: rank == '' ? name : '$rank $name',
                    ),
                  ),
                );
              } else {
                FToast toast = FToast();
                toast.context = context;
                toast.showToast(
                  child: MyToast(
                    contents: [
                      Expanded(
                        child: Text(
                          'Must have more than one data point to chart progress.',
                          style: TextStyle(
                            color: getOnPrimaryColor(context),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  ListView _list(List<Aft> aftList, double width) {
    List<Widget> widgets = [];
    String? name;
    for (int i = 0; i < aftList.length; i++) {
      bool pass = aftList[i].pass == 1;
      if (i == 0) {
        name = aftList[i].name;
        widgets
            .add(nameHeader(aftList, aftList[i].rank ?? '', aftList[i].name));
      } else if (aftList[i].name != name) {
        name = aftList[i].name;
        widgets
            .add(nameHeader(aftList, aftList[i].rank ?? '', aftList[i].name));
      }
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: pass
              ? getPrimaryColor(context)
              : Theme.of(context).colorScheme.error,
          child: PlatformListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Date: ${aftList[i].date}',
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
                Text('MDL: ${aftList[i].mdlScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('HRP: ${aftList[i].hrpScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('SDC: ${aftList[i].sdcScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('PLK: ${aftList[i].plkScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('${aftList[i].runEvent}: ${aftList[i].runScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('Total: ${aftList[i].total}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
              ],
            ),
            trailing: PlatformIconButton(
              icon: Icon(Icons.delete, color: pass ? onPrimary : onError),
              onPressed: () {
                DeleteRecord.deleteRecord(
                    context: context,
                    onConfirm: () {
                      Navigator.pop(context);
                      dbHelper.deleteAcft(aftList[i].id);
                      refreshList();
                    });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AftDetailsPage(
                    aft: aftList[i],
                  ),
                ),
              );
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
    onPrimary = getOnPrimaryColor(context);
    onError = Theme.of(context).colorScheme.onError;
    return PlatformScaffold(
      title: 'Saved AFTs',
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: FutureBuilder<List<Aft>>(
          future: afts,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                'No AFTs Found',
                style: TextStyle(fontSize: 18.0),
              ));
            }

            if (snapshot.hasData) {
              return _list(snapshot.data!, width);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
