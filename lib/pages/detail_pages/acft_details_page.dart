import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../methods/delete_record.dart';
import '../../methods/platform_show_modal_bottom_sheet.dart';
import '../../methods/theme_methods.dart';
import '../../sqlite/acft.dart';
import '../../sqlite/db_helper.dart';
import '../../widgets/button_text.dart';
import '../../widgets/download_acft_widget.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../saved_pages/saved_acfts_page.dart';

class AcftDetailsPage extends StatefulWidget {
  AcftDetailsPage({required this.acft});
  final Acft acft;

  @override
  _AcftDetailsPageState createState() => _AcftDetailsPageState();
}

class _AcftDetailsPageState extends State<AcftDetailsPage> {
  late RegExp regExp;
  late DBHelper dbHelper;

  TextEditingController _mainNameController = TextEditingController();
  TextEditingController _mainDateController = TextEditingController();

  _updateAcft(BuildContext context, Acft acft) {
    final _dateController = new TextEditingController(text: acft.date);
    final _rankController = TextEditingController(text: acft.rank ?? '');
    final _nameController = new TextEditingController(text: acft.name);
    showPlatformModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom == 0
                ? MediaQuery.of(ctx).padding.bottom
                : MediaQuery.of(ctx).viewInsets.bottom + 24),
        color: getBackgroundColor(context),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 2 / 3,
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                decoration: const InputDecoration(
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
              padding: EdgeInsets.all(8),
              child: PlatformButton(
                child: ButtonText(text: 'Update'),
                onPressed: () {
                  acft.date = _dateController.text;
                  acft.rank = _rankController.text;
                  acft.name = _nameController.text;
                  dbHelper.updateAcft(acft);
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
    showPlatformModalBottomSheet(
      context: context,
      builder: (ctx) => DownloadAcftWidget(widget.acft),
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
    super.initState();
    dbHelper = new DBHelper();

    _mainDateController.text = widget.acft.date!;
    _mainNameController.text = widget.acft.rank! == ''
        ? widget.acft.name!
        : '${widget.acft.rank} ${widget.acft.name}';

    regExp = new RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');
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
                    dbHelper.deleteAcft(widget.acft.id);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SavedAcftsPage()),
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
                _updateAcft(context, widget.acft);
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
                    dbHelper.deleteAcft(widget.acft.id);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SavedAcftsPage()),
                    );
                  });
            },
          ),
        ),
      );
      if (!isWideScreen) {
        actions.add(
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                onTap: () => _updateAcft(context, widget.acft),
                title: 'Update ACFT',
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
      title: 'ACFT Details',
      actions: actions(width),
      // <Widget>[
      //   if (Platform.isIOS)
      //     PlatformIconButton(
      //       onPressed: () {
      //         _updateAcft(context, widget.acft);
      //       },
      //       icon: Icon(
      //         Icons.edit,
      //         color: getOnPrimaryColor(context),
      //       ),
      //     ),
      //   PlatformIconButton(
      //     onPressed: _downloadPdf,
      //     icon: Icon(
      //       Icons.picture_as_pdf,
      //       color: getOnPrimaryColor(context),
      //     ),
      //   ),
      //   PlatformIconButton(
      //     icon: Icon(
      //       Icons.delete,
      //       color: getOnPrimaryColor(context),
      //     ),
      //     onPressed: () {
      //       DeleteRecord.deleteRecord(
      //           context: context,
      //           onConfirm: () {
      //             Navigator.pop(context);
      //             dbHelper.deleteAcft(widget.acft.id);
      //             Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(builder: (context) => SavedAcftsPage()),
      //             );
      //           });
      //     },
      //   ),
      // ],
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          _updateAcft(context, widget.acft);
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      label: 'Name',
                      enabled: false,
                      controller: _mainNameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                crossAxisCount: 3,
                childAspectRatio: width / 300,
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 24.0,
                    ),
                    child: const Text(
                      'MDL',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Raw',
                      controller:
                          TextEditingController(text: widget.acft.mdlRaw),
                      decoration: const InputDecoration(labelText: 'Raw'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Score',
                      controller:
                          TextEditingController(text: widget.acft.mdlScore),
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 24.0,
                    ),
                    child: const Text(
                      'SPT',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Raw',
                      controller:
                          TextEditingController(text: widget.acft.sptRaw),
                      decoration: const InputDecoration(labelText: 'Raw'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Score',
                      controller:
                          TextEditingController(text: widget.acft.sptScore),
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 24.0,
                    ),
                    child: const Text(
                      'HRP',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Raw',
                      controller:
                          TextEditingController(text: widget.acft.hrpRaw),
                      decoration: const InputDecoration(labelText: 'Raw'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Score',
                      controller:
                          TextEditingController(text: widget.acft.hrpScore),
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 24.0,
                    ),
                    child: const Text(
                      'SDC',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Raw',
                      controller:
                          TextEditingController(text: widget.acft.sdcRaw),
                      decoration: const InputDecoration(labelText: 'Raw'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Score',
                      controller:
                          TextEditingController(text: widget.acft.sdcScore),
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 24.0,
                    ),
                    child: const Text(
                      'PLK',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Raw',
                      controller:
                          TextEditingController(text: widget.acft.plkRaw),
                      decoration: const InputDecoration(labelText: 'Raw'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Score',
                      controller:
                          TextEditingController(text: widget.acft.plkScore),
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 24.0,
                    ),
                    child: Text(
                      widget.acft.runEvent,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Raw',
                      controller:
                          TextEditingController(text: widget.acft.runRaw),
                      decoration: const InputDecoration(labelText: 'Raw'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      label: 'Score',
                      controller:
                          TextEditingController(text: widget.acft.runScore),
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Total',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Text(
                      '',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformTextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: widget.acft.total),
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
