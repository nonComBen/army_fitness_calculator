import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../methods/delete_record.dart';
import '../../methods/theme_methods.dart';
import '../../widgets/my_toast.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_list_tile.dart';
import '../chart_pages/apft_chart_page.dart';
import '../detail_pages/apft_details_page.dart';
import '../../sqlite/apft.dart';
import '../../sqlite/db_helper.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class SavedApftsPage extends StatefulWidget {
  static const String routeName = 'savedApftsRoute';
  @override
  _SavedApftsPageState createState() => _SavedApftsPageState();
}

class _SavedApftsPageState extends State<SavedApftsPage> {
  Future<List<Apft>>? apfts;
  DBHelper dbHelper = DBHelper();
  Color? onPrimary, onError;

  refreshList() {
    setState(() {
      apfts = dbHelper.getApfts();
    });
  }

  Widget nameHeader(List<Apft> apftList, String? rank, String? name) {
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
              if (apftList.where((apft) => apft.name == name).toList().length >
                  1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApftChartPage(
                      apfts:
                          apftList.where((apft) => apft.name == name).toList(),
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

  ListView _list(List<Apft> apftList, double width) {
    List<Widget> widgets = [];
    String? name;
    for (int i = 0; i < apftList.length; i++) {
      bool pass = apftList[i].pass == 1;
      if (i == 0) {
        name = apftList[i].name;
        widgets.add(nameHeader(apftList, apftList[i].rank, apftList[i].name));
      } else if (apftList[i].name != name) {
        name = apftList[i].name;
        widgets.add(nameHeader(apftList, apftList[i].rank, apftList[i].name));
      }
      widgets.add(Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          color: apftList[i].pass == 1
              ? getPrimaryColor(context)
              : Theme.of(context).colorScheme.error,
          child: PlatformListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Date: ${apftList[i].date}',
                  style: TextStyle(color: pass ? onPrimary : onError)),
            ),
            subtitle: GridView.count(
              crossAxisCount: 2,
              primary: false,
              shrinkWrap: true,
              childAspectRatio: width / 100,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
              children: <Widget>[
                Text('PU: ${apftList[i].puScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('SU: ${apftList[i].suScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('${apftList[i].runEvent}: ${apftList[i].runScore}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
                Text('Total: ${apftList[i].total}',
                    style: TextStyle(color: pass ? onPrimary : onError)),
              ],
            ),
            trailing: PlatformIconButton(
              icon: Icon(
                Icons.delete,
                color: pass ? onPrimary : onError,
              ),
              onPressed: () {
                DeleteRecord.deleteRecord(
                  context: context,
                  onConfirm: () {
                    Navigator.pop(context);
                    dbHelper.deleteApft(apftList[i].id);
                    refreshList();
                  },
                );
              },
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApftDetailsPage(
                            apft: apftList[i],
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
    onPrimary = getOnPrimaryColor(context);
    onError = Theme.of(context).colorScheme.onError;
    return PlatformScaffold(
      title: 'Saved APFTs',
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: FutureBuilder<List<Apft>>(
          future: apfts,
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                'No APFTs Found',
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
