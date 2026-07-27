import 'package:acft_calculator/pages/chart_pages/whtr_chart_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../methods/delete_record.dart';
import '../../methods/theme_methods.dart';
import '../../sqlite/w_ht_ratio.dart';
import '../../widgets/my_toast.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_list_tile.dart';
import '../../sqlite/db_helper.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../detail_pages/whtr_details_page.dart';

class SavedWHtRsPage extends StatefulWidget {
  static const String routeName = 'savedWHtRsRoute';
  @override
  _SavedWHtRsPageState createState() => _SavedWHtRsPageState();
}

class _SavedWHtRsPageState extends State<SavedWHtRsPage> {
  Future<List<WHtR>>? wHtRs;
  DBHelper dbHelper = DBHelper();
  Color? onPrimary, onError;

  refreshList() {
    setState(() {
      wHtRs = dbHelper.getWHtR();
    });
  }

  Widget nameHeader(List<WHtR> whtrList, String? rank, String? name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            rank == '' ? name! : '$rank $name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          PlatformIconButton(
            icon: Icon(
              Icons.show_chart,
              color: getTextColor(context),
            ),
            onPressed: () {
              if (whtrList.where((bf) => bf.name == name).toList().length > 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WHtRChartPage(
                      wHtRs: whtrList.where((bf) => bf.name == name).toList(),
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

  ListView _list(List<WHtR> whtrList, double width) {
    List<Widget> widgets = [];
    String? name;
    for (int i = 0; i < whtrList.length; i++) {
      bool pass = whtrList[i].whtPass == 1 || whtrList[i].whtPass == 1;
      if (i == 0) {
        name = whtrList[i].name;
        widgets.add(nameHeader(whtrList, whtrList[i].rank, whtrList[i].name));
      } else if (whtrList[i].name != name) {
        name = whtrList[i].name;
        widgets.add(nameHeader(whtrList, whtrList[i].rank, whtrList[i].name));
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
              child: Text('Date: ${whtrList[i].date}',
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
                    Text('Height: ${whtrList[i].height}',
                        style: TextStyle(color: pass ? onPrimary : onError)),
                    Text('Waist: ${whtrList[i].waist}',
                        style: TextStyle(color: pass ? onPrimary : onError)),
                  ],
                ),
              ],
            ),
            trailing: PlatformIconButton(
              icon: Icon(Icons.delete, color: (pass ? onPrimary : onError)),
              onPressed: () {
                DeleteRecord.deleteRecord(
                  context: context,
                  onConfirm: () {
                    Navigator.pop(context);
                    dbHelper.deleteWHtR(whtrList[i].id);
                    refreshList();
                  },
                );
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WHtRDetailsPage(
                    wHtR: whtrList[i],
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
    dbHelper.initDb().then((value) {
      refreshList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    onPrimary = getOnPrimaryColor(context);
    onError = Theme.of(context).colorScheme.onError;
    return PlatformScaffold(
      title: 'Saved Waist Height Ratios',
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: FutureBuilder<List<WHtR>>(
          future: wHtRs,
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                'No Waist Height Ratios Found',
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
