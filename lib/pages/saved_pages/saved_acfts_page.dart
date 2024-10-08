import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../methods/delete_record.dart';
import '../../methods/theme_methods.dart';
import '../../widgets/my_toast.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_list_tile.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../chart_pages/acft_chart_page.dart';
import '../detail_pages/acft_details_page.dart';
import '../../sqlite/acft.dart';
import '../../sqlite/db_helper.dart';

class SavedAcftsPage extends StatefulWidget {
  static const String routeName = 'savedAcftsRoute';
  @override
  _SavedAcftsPageState createState() => _SavedAcftsPageState();
}

class _SavedAcftsPageState extends State<SavedAcftsPage> {
  Future<List<Acft>>? acfts;
  DBHelper dbHelper = DBHelper();
  Color? onPrimary, onError;

  refreshList() {
    setState(() {
      acfts = dbHelper.getAcfts();
    });
  }

  Widget nameHeader(List<Acft> acftList, String rank, String? name) {
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
              if (acftList.where((acft) => acft.name == name).toList().length >
                  1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AcftChartPage(
                      acfts:
                          acftList.where((acft) => acft.name == name).toList(),
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

  ListView _list(List<Acft> acftList, double width) {
    List<Widget> widgets = [];
    String? name;
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
              ? getPrimaryColor(context)
              : Theme.of(context).colorScheme.error,
          child: PlatformListTile(
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
            trailing: PlatformIconButton(
              icon: Icon(Icons.delete, color: pass ? onPrimary : onError),
              onPressed: () {
                DeleteRecord.deleteRecord(
                    context: context,
                    onConfirm: () {
                      Navigator.pop(context);
                      dbHelper.deleteAcft(acftList[i].id);
                      refreshList();
                    });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AcftDetailsPage(
                    acft: acftList[i],
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
      title: 'Saved ACFTs',
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: FutureBuilder<List<Acft>>(
          future: acfts,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                'No ACFTs Found',
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
