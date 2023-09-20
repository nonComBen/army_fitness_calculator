import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../methods/delete_record.dart';
import '../../methods/platform_show_modal_bottom_sheet.dart';
import '../../methods/theme_methods.dart';
import '../../sqlite/apft.dart';
import '../../sqlite/db_helper.dart';
import '../../widgets/my_toast.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../saved_pages/saved_apfts_page.dart';

class ApftDetailsPage extends StatefulWidget {
  ApftDetailsPage({required this.apft});
  final Apft apft;

  @override
  _ApftDetailsPageState createState() => _ApftDetailsPageState();
}

class _ApftDetailsPageState extends State<ApftDetailsPage> {
  late RegExp regExp;
  late DBHelper dbHelper;

  TextEditingController _mainNameController = TextEditingController();
  TextEditingController _mainDateController = TextEditingController();

  _updateApft(BuildContext context, Apft apft) {
    final _dateController = TextEditingController(text: apft.date);
    final _rankController = TextEditingController(text: apft.rank ?? '');
    final _nameController = TextEditingController(text: apft.name);
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
          maxHeight: MediaQuery.of(context).size.height * 2 / 3,
        ),
        color: getBackgroundColor(context),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Date and Name are the only editable fields.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: _dateController,
                label: 'Date',
                keyboardType: TextInputType.numberWithOptions(signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Date',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    regExp.hasMatch(value!) ? null : 'Use yyyyMMdd Format',
                autocorrect: false,
                autofocus: true,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: _rankController,
                label: 'Rank',
                decoration: const InputDecoration(labelText: 'Rank'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: _nameController,
                label: 'Name',
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: PlatformButton(
                child: Text('Update APFT'),
                onPressed: () {
                  setState(() {
                    _mainDateController.text = _dateController.text;
                    _mainNameController.text =
                        '${_rankController.text} ${_nameController.text}';
                  });
                  apft.date = _dateController.text;
                  apft.rank = _rankController.text;
                  apft.name = _nameController.text;
                  dbHelper.updateApft(apft);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _downloadPdf() {
    FToast toast = FToast();
    toast.context = context;
    toast.showToast(
      child: MyToast(
        contents: [
          Text(
            'PDF Download is temporarily unavailable. Sorry for the inconcenience.',
            style: TextStyle(color: getOnPrimaryColor(context)),
          )
        ],
      ),
    );
    // showPlatformModalBottomSheet(
    //   context: context,
    //   builder: (ctx) => DownloadApftWidget(widget.apft),
    // );
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

    _mainDateController.text = widget.apft.date!;
    _mainNameController.text = widget.apft.rank! == ''
        ? widget.apft.name!
        : '${widget.apft.rank} ${widget.apft.name}';

    regExp = new RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');

    super.initState();
  }

  List<Widget> actions(double width) {
    bool isWideScreen = width > 500;
    List<Widget> actions = [];
    if (Platform.isAndroid) {
      actions = [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: PlatformIconButton(
            onPressed: _downloadPdf,
            icon: Icon(
              Icons.picture_as_pdf,
              color: getOnPrimaryColor(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: PlatformIconButton(
            icon: Icon(
              Icons.delete,
              color: getOnPrimaryColor(context),
            ),
            onPressed: () {
              DeleteRecord.deleteRecord(
                  context: context,
                  onConfirm: () {
                    Navigator.pop(context);
                    dbHelper.deleteApft(widget.apft.id);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SavedApftsPage()),
                    );
                  });
            },
          ),
        ),
      ];
    } else {
      if (isWideScreen) {
        actions.add(
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: PlatformIconButton(
              onPressed: () {
                _updateApft(context, widget.apft);
              },
              icon: Icon(
                Icons.edit,
                color: getOnPrimaryColor(context),
              ),
            ),
          ),
        );
        actions.add(
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: PlatformIconButton(
              onPressed: _downloadPdf,
              icon: Icon(
                Icons.picture_as_pdf,
                color: getOnPrimaryColor(context),
              ),
            ),
          ),
        );
      }
      actions.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: PlatformIconButton(
            icon: Icon(
              Icons.delete,
              color: getOnPrimaryColor(context),
            ),
            onPressed: () {
              DeleteRecord.deleteRecord(
                context: context,
                onConfirm: () {
                  Navigator.pop(context);
                  dbHelper.deleteApft(widget.apft.id);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SavedApftsPage()),
                  );
                },
              );
            },
          ),
        ),
      );
      if (!isWideScreen) {
        actions.add(
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                onTap: () => _updateApft(context, widget.apft),
                title: 'Update APFT',
              ),
              PullDownMenuItem(
                onTap: () => _downloadPdf(),
                title: 'Download DA 705',
              ),
            ],
            buttonBuilder: (context, showMenu) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: PlatformIconButton(
                  icon: Icon(
                    CupertinoIcons.ellipsis_vertical_circle,
                    color: getOnPrimaryColor(context),
                  ),
                  onPressed: showMenu,
                ),
              );
            },
          ),
        );
      }
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return PlatformScaffold(
      title: 'APFT Details',
      actions: actions(width),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          _updateApft(context, widget.apft);
        },
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: getBackgroundColor(context),
          ),
          child: ListView(
            children: <Widget>[
              GridView.count(
                crossAxisCount: width > 700 ? 2 : 1,
                childAspectRatio: width > 700 ? width / 200 : width / 100,
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller: _mainNameController,
                      label: 'Name',
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller: _mainDateController,
                      label: 'Date',
                      decoration: const InputDecoration(labelText: 'Date'),
                    ),
                  ),
                ],
              ),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: width / 200,
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.apft.gender),
                      label: 'Gender',
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller: TextEditingController(text: widget.apft.age),
                      label: 'Age',
                      decoration: const InputDecoration(labelText: 'Age'),
                    ),
                  ),
                ],
              ),
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: width / 300,
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                    child: const Text(
                      'PU',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.apft.puRaw),
                      label: 'Raw',
                      decoration: const InputDecoration(labelText: 'Raw'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.apft.puScore),
                      label: 'Score',
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                    child: const Text(
                      'SU',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.apft.suRaw),
                      label: 'Raw',
                      decoration: const InputDecoration(labelText: 'Raw'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.apft.suScore),
                      label: 'Score',
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                    child: Text(
                      widget.apft.runEvent,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.apft.runRaw),
                      label: 'Raw',
                      decoration: const InputDecoration(labelText: 'Raw'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.apft.runScore),
                      label: 'Score',
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                    child: const Text(
                      'Total',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Text(
                      '',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.apft.total),
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
