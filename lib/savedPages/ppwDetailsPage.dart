import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './savedPpwPage.dart';
import '../sqlite/ppw.dart';
import '../sqlite/dbHelper.dart';

class PpwDetailsPage extends StatefulWidget {
  PpwDetailsPage({this.ppw});
  final PPW ppw;

  @override
  _PpwDetailsPageState createState() => _PpwDetailsPageState();
}

class _PpwDetailsPageState extends State<PpwDetailsPage> {
  RegExp regExp;
  DBHelper dbHelper;
  int milTrain, milTrainMax, awards, awardMax, milEd, milEdMax, civEd, civEdMax;

  TextEditingController _mainNameController;
  TextEditingController _mainDateController;

  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  _updatePpw(BuildContext context, PPW ppw) {
    final _dateController = new TextEditingController(text: ppw.date);
    final _nameController = new TextEditingController(text: ppw.name);
    final textStyle = TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.yellow
            : Colors.amber);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Material(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      const Text('Date and Name are the only editable fields.'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _dateController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        regExp.hasMatch(value) ? null : 'Use yyyy-MM-dd Format',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
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
        ),
      ),
    );
  }

  deleteRecord(PPW ppw) {
    final title = const Text('Delete Record');
    final textStyle = TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.yellow
            : Colors.amber);
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
                    child: Text('Cancel', style: textStyle),
                    onPressed: () {
                      Navigator.pop(context2);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Yes', style: textStyle),
                    onPressed: () {
                      Navigator.pop(context2);
                      dbHelper.deletePPW(ppw.id);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SavedPpwsPage()));
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
                  child: Text('Cancel', style: textStyle),
                  onPressed: () {
                    Navigator.pop(context2);
                  },
                ),
                TextButton(
                  child: Text('Yes', style: textStyle),
                  onPressed: () {
                    Navigator.pop(context2);
                    dbHelper.deletePPW(ppw.id);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SavedPpwsPage()));
                  },
                )
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    _mainNameController.dispose();
    _mainDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    dbHelper = new DBHelper();

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

    _mainDateController = new TextEditingController(text: widget.ppw.date);
    _mainNameController = new TextEditingController(text: widget.ppw.name);

    regExp = new RegExp(r'^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: const Text('PPW Details'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteRecord(widget.ppw);
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          _updatePpw(context, widget.ppw);
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
                    child: TextFormField(
                      enabled: false,
                      controller: _mainNameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: _mainDateController,
                      decoration: const InputDecoration(labelText: 'Date'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      initialValue: widget.ppw.rank.toString(),
                      decoration:
                          const InputDecoration(labelText: 'Promotion To'),
                    ),
                  ),
                ],
              ),
              Card(
                color: Theme.of(context).colorScheme.primary,
                child: ListTile(
                  title: Text(
                    'Military Training',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  trailing: Text(
                    '$milTrain/${widget.ppw.milTrainMax}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
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
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: Text(widget.ppw.version == 1
                                ? 'ACFT Points'
                                : 'APFT Points')),
                        enabled: false,
                        initialValue: widget.ppw.ptTest.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(label: Text('Weapon Points')),
                        enabled: false,
                        initialValue: widget.ppw.weapons.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child:
                    Divider(color: Theme.of(context).colorScheme.onSecondary),
              ),
              Card(
                color: Theme.of(context).colorScheme.primary,
                child: ListTile(
                  title: Text(
                    'Awards',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  trailing: Text(
                    '$awards/${widget.ppw.awardsMax}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
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
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Decoration Points')),
                        enabled: false,
                        initialValue: widget.ppw.awards.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(label: Text('Badge Points')),
                        enabled: false,
                        initialValue: widget.ppw.badges.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Airborne Advantage Points')),
                        enabled: false,
                        initialValue: widget.ppw.airborne.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child:
                    Divider(color: Theme.of(context).colorScheme.onSecondary),
              ),
              Card(
                color: Theme.of(context).colorScheme.primary,
                child: ListTile(
                  title: Text(
                    'Military Education',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  trailing: Text(
                    '$milEd/${widget.ppw.milEdMax}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
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
                      child: TextFormField(
                        decoration:
                            const InputDecoration(label: Text('NCOES Points')),
                        enabled: false,
                        initialValue: widget.ppw.ncoes.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Resident Courses Points')),
                        enabled: false,
                        initialValue: widget.ppw.resident.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Web-Based Courses Points')),
                        enabled: false,
                        initialValue: widget.ppw.wbc.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child:
                    Divider(color: Theme.of(context).colorScheme.onSecondary),
              ),
              Card(
                color: Theme.of(context).colorScheme.primary,
                child: ListTile(
                  title: Text(
                    'Civilian Education',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  trailing: Text(
                    '$civEd/${widget.ppw.civEdMax}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
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
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Semester Hour Points')),
                        enabled: false,
                        initialValue: widget.ppw.semesterHours.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Degree Completion Points')),
                        enabled: false,
                        initialValue: widget.ppw.degree.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Certification Points')),
                        enabled: false,
                        initialValue: widget.ppw.certs.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Foreign Language Points')),
                        enabled: false,
                        initialValue: widget.ppw.language.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child:
                    Divider(color: Theme.of(context).colorScheme.onSecondary),
              ),
              Card(
                color: Theme.of(context).colorScheme.primary,
                child: ListTile(
                  title: Text(
                    'Total Points',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  trailing: Text(
                    '${widget.ppw.total}/800',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
