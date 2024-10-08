import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../methods/delete_record.dart';
import '../../methods/theme_methods.dart';
import '../../widgets/my_toast.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_list_tile.dart';
import '../chart_pages/bodyfat_chart_page.dart';
import '../detail_pages/bodyfat_details_page.dart';
import '../../sqlite/bodyfat.dart';
import '../../sqlite/db_helper.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class SavedBodyfatsPage extends StatefulWidget {
  static const String routeName = 'savedBodyfatsRoute';
  @override
  _SavedBodyfatsPageState createState() => _SavedBodyfatsPageState();
}

class _SavedBodyfatsPageState extends State<SavedBodyfatsPage> {
  Future<List<Bodyfat>>? bodyfats;
  DBHelper dbHelper = DBHelper();
  Color? onPrimary, onError;

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

  Widget nameHeader(List<Bodyfat> bfList, String? rank, String? name) {
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
              if (bfList.where((bf) => bf.name == name).toList().length > 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BodyfatChartPage(
                      bodyfats: bfList.where((bf) => bf.name == name).toList(),
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

  ListView _list(List<Bodyfat> bfList, double width) {
    List<Widget> widgets = [];
    String? name;
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
              ? getPrimaryColor(context)
              : Theme.of(context).colorScheme.error,
          child: PlatformListTile(
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
            trailing: PlatformIconButton(
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
      title: 'Saved Body Comps',
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: FutureBuilder<List<Bodyfat>>(
          future: bodyfats,
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                'No Body Compositions Found',
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
