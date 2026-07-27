import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../methods/delete_record.dart';
import '../../methods/platform_show_modal_bottom_sheet.dart';
import '../../methods/theme_methods.dart';
import '../../sqlite/db_helper.dart';
import '../../sqlite/w_ht_ratio.dart';
import '../../widgets/button_text.dart';
import '../../widgets/my_toast.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../saved_pages/saved_whtr_page.dart';

class WHtRDetailsPage extends StatefulWidget {
  WHtRDetailsPage({required this.wHtR});
  final WHtR wHtR;

  @override
  _WHtRDetailsPageState createState() => _WHtRDetailsPageState();
}

class _WHtRDetailsPageState extends State<WHtRDetailsPage> {
  late RegExp regExp;
  late DBHelper dbHelper;

  TextEditingController _mainNameController = TextEditingController();
  TextEditingController _mainDateController = TextEditingController();

  _updateWHtR(BuildContext context, WHtR whtr) {
    final _dateController = TextEditingController(text: whtr.date);
    final _rankController = TextEditingController(text: whtr.rank ?? '');
    final _nameController = TextEditingController(text: whtr.name);
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
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Date, Rank, and Name are the only editable fields.',
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
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    regExp.hasMatch(value!) ? null : 'Use yyyyMMdd Format',
                autofocus: true,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: _rankController,
                label: 'Rank',
                decoration: InputDecoration(labelText: 'Rank'),
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
                decoration: InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: PlatformButton(
                child: ButtonText(text: 'Update Waist Height Ratio'),
                onPressed: () {
                  setState(() {
                    _mainDateController.text = _dateController.text;
                    _mainNameController.text =
                        '${_rankController.text} ${_nameController.text}';
                  });
                  whtr.date = _dateController.text;
                  whtr.rank = _rankController.text;
                  whtr.name = _nameController.text;
                  dbHelper.updateWHtR(whtr);
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
            'Downloading PDF for new Waist Height Ratio (WHtR) form is not available yet.',
            style: TextStyle(color: getOnPrimaryColor(context)),
          ),
        ],
      ),
    );
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

    _mainDateController.text = widget.wHtR.date!;
    _mainNameController.text = widget.wHtR.rank! == ''
        ? widget.wHtR.name!
        : '${widget.wHtR.rank} ${widget.wHtR.name}';

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
                    dbHelper.deleteWHtR(widget.wHtR.id);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SavedWHtRsPage()),
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
                _updateWHtR(context, widget.wHtR);
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
                  dbHelper.deleteWHtR(widget.wHtR.id);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SavedWHtRsPage()),
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
                onTap: () => _updateWHtR(context, widget.wHtR),
                title: 'Update WHtR',
              ),
              PullDownMenuItem(
                  onTap: () => _downloadPdf(), title: 'Download DA 5500'),
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
    final width = MediaQuery.of(context).size.width;
    return PlatformScaffold(
      title: 'WHtR Details',
      actions: actions(width),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          _updateWHtR(context, widget.wHtR);
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
                      label: 'Name',
                      enabled: false,
                      controller: _mainNameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      label: 'Date',
                      enabled: false,
                      controller: _mainDateController,
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
                      label: 'Height',
                      enabled: false,
                      controller: TextEditingController(
                          text: widget.wHtR.height.toString() + ' in.'),
                      decoration: const InputDecoration(labelText: 'Height'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      label: 'Waist',
                      enabled: false,
                      controller: TextEditingController(
                          text: widget.wHtR.waist.toString() + ' in.'),
                      decoration: const InputDecoration(labelText: 'Waist'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      label: 'WHtR',
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.wHtR.wHtRatio),
                      decoration: const InputDecoration(labelText: 'WHtR'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
