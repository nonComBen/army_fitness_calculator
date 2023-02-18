import 'dart:io';

import 'package:acft_calculator/methods/platform_show_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../../methods/theme_methods.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_list_tile.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../saved_pages/saved_ppw_page.dart';
import '../../sqlite/ppw.dart';
import '../../sqlite/db_helper.dart';
import '../../methods/delete_record.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class PpwDetailsPage extends StatefulWidget {
  PpwDetailsPage({required this.ppw});
  final PPW ppw;

  @override
  _PpwDetailsPageState createState() => _PpwDetailsPageState();
}

class _PpwDetailsPageState extends State<PpwDetailsPage> {
  RegExp regExp =
      new RegExp(r'^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$');
  DBHelper dbHelper = DBHelper();
  int milTrain = 0, awards = 0, milEd = 0, civEd = 0;

  final _mainNameController = TextEditingController();
  final _mainDateController = TextEditingController();

  @override
  void dispose() {
    _mainNameController.dispose();
    _mainDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    milTrain = widget.ppw.ptTest + widget.ppw.weapons;
    awards = widget.ppw.awards + widget.ppw.badges;
    milEd = widget.ppw.ncoes +
        widget.ppw.wbc +
        widget.ppw.resident +
        widget.ppw.tabs;
    civEd = widget.ppw.semesterHours +
        widget.ppw.degree +
        widget.ppw.certs +
        widget.ppw.language;
    if (milTrain > widget.ppw.milTrainMax) {
      milTrain = widget.ppw.milTrainMax;
    }
    if (awards > widget.ppw.awardsMax) {
      awards = widget.ppw.awardsMax;
    }
    if (milEd > widget.ppw.milEdMax) {
      milEd = widget.ppw.milEdMax;
    }
    if (civEd > widget.ppw.civEdMax) {
      civEd = widget.ppw.civEdMax;
    }
    awards += widget.ppw.airborne;

    _mainDateController.text = widget.ppw.date!;
    _mainNameController.text = widget.ppw.name!;

    super.initState();
  }

  _updatePpw(BuildContext context, PPW ppw) {
    final _dateController = new TextEditingController(text: ppw.date);
    final _nameController = new TextEditingController(text: ppw.name);
    final textStyle = TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.yellow
            : Colors.amber);
    showPlatformModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(ctx).viewInsets.bottom == 0
              ? MediaQuery.of(ctx).padding.bottom
              : MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 2,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('Date and Name are the only editable fields.'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: _dateController,
                label: 'Date',
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Date',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    regExp.hasMatch(value!) ? null : 'Use yyyy-MM-dd Format',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: _nameController,
                label: 'Name',
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: PlatformButton(
                child: Text('Save', style: textStyle),
                onPressed: () {
                  setState(() {
                    _mainDateController.text = _dateController.text;
                    _mainNameController.text = _nameController.text;
                  });
                  ppw.date = _dateController.text;
                  ppw.name = _nameController.text;
                  dbHelper.updatePPW(ppw);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: getOnPrimaryColor(context),
    );
    final width = MediaQuery.of(context).size.width;
    return PlatformScaffold(
      title: 'PPW Details',
      actions: <Widget>[
        if (Platform.isIOS)
          PlatformIconButton(
            onPressed: () {
              _updatePpw(context, widget.ppw);
            },
            icon: Icon(
              Icons.edit,
              color: getOnPrimaryColor(context),
            ),
          ),
        PlatformIconButton(
          icon: Icon(
            Icons.delete,
            color: getOnPrimaryColor(context),
          ),
          onPressed: () {
            DeleteRecord.deleteRecord(
              context: context,
              onConfirm: () {
                dbHelper.deletePPW(widget.ppw.id);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedPpwsPage(),
                  ),
                );
              },
            );
          },
        )
      ],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          _updatePpw(context, widget.ppw);
        },
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: ListView(
          children: <Widget>[
            GridView.count(
              crossAxisCount: width > 700 ? 2 : 1,
              childAspectRatio: width > 700 ? width / 200 : width / 100,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              primary: false,
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformTextField(
                    label: 'Name',
                    enabled: false,
                    controller: _mainNameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformTextField(
                    label: 'Date',
                    enabled: false,
                    controller: _mainDateController,
                    decoration: const InputDecoration(labelText: 'Date'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformTextField(
                    label: 'Promotion To',
                    enabled: false,
                    controller: TextEditingController(
                      text: widget.ppw.rank.toString(),
                    ),
                    decoration:
                        const InputDecoration(labelText: 'Promotion To'),
                  ),
                ),
              ],
            ),
            Card(
              color: getPrimaryColor(context),
              child: PlatformListTile(
                title: Text('Military Training', style: headerTextStyle),
                trailing: Text(
                  '$milTrain/${widget.ppw.milTrainMax}',
                  style: headerTextStyle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: width / 200,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: widget.ppw.version == 1 ? 'ACFT' : 'APFT',
                      decoration: InputDecoration(
                        label: Text(widget.ppw.version == 1 ? 'ACFT' : 'APFT'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.ptTest.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Weapon',
                      decoration: const InputDecoration(label: Text('Weapon')),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.weapons.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                color: getOnPrimaryColor(context),
              ),
            ),
            Card(
              color: getPrimaryColor(context),
              child: PlatformListTile(
                title: Text(
                  'Awards',
                  style: headerTextStyle,
                ),
                trailing: Text(
                  '$awards/${widget.ppw.awardsMax}',
                  style: headerTextStyle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: width / 200,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Decoration',
                      decoration: const InputDecoration(
                        label: Text('Decoration'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.awards.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Badge',
                      decoration: const InputDecoration(
                        label: Text('Badge'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.badges.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Airborne',
                      decoration: const InputDecoration(
                        label: Text('Airborne'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.airborne.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                color: getOnPrimaryColor(context),
              ),
            ),
            Card(
              color: getPrimaryColor(context),
              child: PlatformListTile(
                title: Text(
                  'Military Education',
                  style: headerTextStyle,
                ),
                trailing: Text(
                  '$milEd/${widget.ppw.milEdMax}',
                  style: headerTextStyle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: width / 200,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'NCOES',
                      decoration: const InputDecoration(
                        label: Text('NCOES'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.ncoes.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Resident',
                      decoration: const InputDecoration(
                        label: Text('Resident'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.resident.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Web-Based',
                      decoration: const InputDecoration(
                        label: Text('Web-Based'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.wbc.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                color: getOnPrimaryColor(context),
              ),
            ),
            Card(
              color: getPrimaryColor(context),
              child: PlatformListTile(
                title: Text(
                  'Civilian Education',
                  style: headerTextStyle,
                ),
                trailing: Text(
                  '$civEd/${widget.ppw.civEdMax}',
                  style: headerTextStyle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: width / 200,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Semester Hour',
                      decoration: const InputDecoration(
                        label: Text('Semester Hour'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.semesterHours.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Degree',
                      decoration: const InputDecoration(
                        label: Text('Degree'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.degree.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Certification',
                      decoration: const InputDecoration(
                        label: Text('Certification'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.certs.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformTextField(
                      label: 'Language',
                      decoration: const InputDecoration(
                        label: Text('Language'),
                      ),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.ppw.language.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                color: getOnPrimaryColor(context),
              ),
            ),
            Card(
              color: getPrimaryColor(context),
              child: PlatformListTile(
                title: Text(
                  'Total Points',
                  style: headerTextStyle,
                ),
                trailing: Text(
                  '${widget.ppw.total}/800',
                  style: headerTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
