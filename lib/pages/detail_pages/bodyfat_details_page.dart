import 'dart:io';

import 'package:acft_calculator/methods/platform_show_modal_bottom_sheet.dart';
import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:acft_calculator/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../methods/delete_record.dart';
import '../../widgets/download_5501_widget.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../saved_pages/saved_bodyfats_page.dart';
import '../../sqlite/db_helper.dart';
import '../../sqlite/bodyfat.dart';
import '../../widgets/download_5500_widget.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class BodyfatDetailsPage extends StatefulWidget {
  BodyfatDetailsPage({required this.bf});
  final Bodyfat bf;

  @override
  _BodyfatDetailsPageState createState() => _BodyfatDetailsPageState();
}

class _BodyfatDetailsPageState extends State<BodyfatDetailsPage> {
  late RegExp regExp;
  late DBHelper dbHelper;

  TextEditingController _mainNameController = TextEditingController();
  TextEditingController _mainDateController = TextEditingController();

  static GlobalKey previewContainer = new GlobalKey();

  _updateBf(BuildContext context, Bodyfat bf) {
    final _dateController = new TextEditingController(text: bf.date);
    final _rankController = TextEditingController(text: bf.rank ?? '');
    final _nameController = new TextEditingController(text: bf.name);
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
        child: Material(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'Date, Rank, and Name are the only editable fields.'),
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
                    child: Text('Update Body Comp'),
                    onPressed: () {
                      setState(() {
                        _mainDateController.text = _dateController.text;
                        _mainNameController.text =
                            '${_rankController.text} ${_nameController.text}';
                      });
                      bf.date = _dateController.text;
                      bf.rank = _rankController.text;
                      bf.name = _nameController.text;
                      dbHelper.updateBodyfat(bf);
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

  // takeScreenshot() async {
  //   bool permissionGranted;
  //   if (Platform.isAndroid) {
  //     permissionGranted = await Permission.storage.request().isGranted;
  //   } else {
  //     permissionGranted = await Permission.photos.request().isGranted;
  //   }

  //   if (permissionGranted) {
  //     try {
  //       RenderRepaintBoundary boundary =
  //           previewContainer.currentContext.findRenderObject();
  //       ui.Image image = await boundary.toImage();
  //       ByteData byteData =
  //           await image.toByteData(format: ui.ImageByteFormat.png);
  //       Uint8List pngBytes = byteData.buffer.asUint8List();
  //       await PhotosSaver.saveFile(fileData: pngBytes);
  //       String location =
  //           Platform.isAndroid ? 'Gallery Album "Pictures"' : 'Photos';
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Image saved to $location'),
  //       ));
  //     } catch (e) {
  //       print('Error: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Failed to save image'),
  //       ));
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('You must allow permission to save screenshot'),
  //     ));
  //   }
  // }

  Widget measurements(double width) {
    return Column(
      children: <Widget>[
        Divider(
          color: Colors.blue,
        ),
        GridView.count(
          crossAxisCount: 3,
          childAspectRatio: width / 300,
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: PlatformTextField(
                label: 'Neck',
                enabled: false,
                controller:
                    TextEditingController(text: widget.bf.neck + ' in.'),
                decoration: const InputDecoration(labelText: 'Neck'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: PlatformTextField(
                label: 'Waist',
                enabled: false,
                controller:
                    TextEditingController(text: widget.bf.waist + ' in.'),
                decoration: const InputDecoration(labelText: 'Waist'),
              ),
            ),
            if (widget.bf.gender == 'Female')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: PlatformTextField(
                  label: 'Hip',
                  enabled: false,
                  controller:
                      TextEditingController(text: widget.bf.hip + ' in.'),
                  decoration: const InputDecoration(labelText: 'Hip'),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: PlatformTextField(
                label: 'BF %',
                enabled: false,
                controller:
                    TextEditingController(text: widget.bf.bfPercent + '%'),
                decoration: const InputDecoration(labelText: 'BF %'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: PlatformTextField(
                label: 'Max BF %',
                enabled: false,
                controller:
                    TextEditingController(text: widget.bf.maxPercent + '%'),
                decoration: const InputDecoration(labelText: 'Max BF %'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: PlatformTextField(
                label: 'Over/Under',
                enabled: false,
                controller:
                    TextEditingController(text: widget.bf.overUnder + '%'),
                decoration: const InputDecoration(labelText: 'Over/Under'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _downloadPdf() {
    if (widget.bf.bmiPass == 1) {
      FToast toast = FToast();
      toast.context = context;
      toast.showToast(
        child: MyToast(
          contents: [
            Text(
              'Soldier passed Height / Weight',
              style: TextStyle(color: getOnPrimaryColor(context)),
            ),
          ],
        ),
      );
      return;
    } else {
      if (widget.bf.gender == 'Male') {
        showPlatformModalBottomSheet(
          context: context,
          builder: (ctx) => Download5500Widget(widget.bf),
        );
      } else {
        showPlatformModalBottomSheet(
          context: context,
          builder: (ctx) => Download5501Widget(widget.bf),
        );
      }
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

    _mainDateController.text = widget.bf.date!;
    _mainNameController.text = widget.bf.rank! == ''
        ? widget.bf.name!
        : '${widget.bf.rank} ${widget.bf.name}';

    regExp = new RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return PlatformScaffold(
      title: 'Body Comp Details',
      actions: <Widget>[
        if (Platform.isIOS)
          PlatformIconButton(
            onPressed: () {
              _updateBf(context, widget.bf);
            },
            icon: Icon(
              Icons.edit,
              color: getOnPrimaryColor(context),
            ),
          ),
        PlatformIconButton(
          icon: Icon(
            Icons.picture_as_pdf,
            color: getOnPrimaryColor(context),
          ),
          onPressed: () {
            _downloadPdf();
          },
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
                Navigator.pop(context);
                dbHelper.deleteBodyfat(widget.bf.id);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SavedBodyfatsPage()));
              },
            );
          },
        )
      ],
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          _updateBf(context, widget.bf);
        },
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: RepaintBoundary(
          key: previewContainer,
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
                        label: 'Gender',
                        enabled: false,
                        controller:
                            TextEditingController(text: widget.bf.gender),
                        decoration: const InputDecoration(labelText: 'Gender'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: PlatformTextField(
                        label: 'Age',
                        enabled: false,
                        controller: TextEditingController(text: widget.bf.age),
                        decoration: const InputDecoration(labelText: 'Age'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: PlatformTextField(
                        label: 'Height',
                        enabled: false,
                        controller: TextEditingController(
                            text: widget.bf.heightDouble.toString() + ' in.'),
                        decoration: const InputDecoration(labelText: 'Height'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: PlatformTextField(
                        label: 'Weight',
                        enabled: false,
                        controller: TextEditingController(
                            text: widget.bf.weight + ' lbs.'),
                        decoration: const InputDecoration(labelText: 'Weight'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: PlatformTextField(
                        label: 'Max Weight',
                        enabled: false,
                        controller: TextEditingController(
                            text: widget.bf.maxWeight + ' lbs.'),
                        decoration:
                            const InputDecoration(labelText: 'Max Weight'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: PlatformTextField(
                        label: 'Over/Under',
                        enabled: false,
                        controller: TextEditingController(
                            text: (int.tryParse(widget.bf.weight)! -
                                        int.tryParse(widget.bf.maxWeight)!)
                                    .toString() +
                                ' lbs.'),
                        decoration:
                            const InputDecoration(labelText: 'Over/Under'),
                      ),
                    ),
                  ],
                ),
                if (widget.bf.bmiPass == 0) measurements(width),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
