import 'package:acft_calculator/widgets/download_acft_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../methods/delete_record.dart';
import '../saved_pages/saved_acfts_page.dart';
import '../../sqlite/db_helper.dart';
import '../../sqlite/acft.dart';

class AcftDetailsPage extends StatefulWidget {
  AcftDetailsPage({this.acft});
  final Acft acft;

  @override
  _AcftDetailsPageState createState() => _AcftDetailsPageState();
}

class _AcftDetailsPageState extends State<AcftDetailsPage> {
  RegExp regExp;
  DBHelper dbHelper;

  TextEditingController _mainNameController;
  TextEditingController _mainDateController;

  static GlobalKey previewContainer = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  _updateAcft(BuildContext context, Acft acft) {
    final _dateController = new TextEditingController(text: acft.date);
    final _rankController = TextEditingController(text: acft.rank ?? '');
    final _nameController = new TextEditingController(text: acft.name);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom == 0
                ? MediaQuery.of(ctx).padding.bottom
                : MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
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
                child: TextFormField(
                  controller: _dateController,
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      regExp.hasMatch(value) ? null : 'Use yyyyMMdd Format',
                  autofocus: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _rankController,
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
                child: TextFormField(
                  controller: _nameController,
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
                child: ElevatedButton(
                  child: Text('Update'),
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
      ),
    );
  }

  void _downloadPdf() {
    showModalBottomSheet(
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

    _mainDateController = new TextEditingController(text: widget.acft.date);
    _mainNameController = new TextEditingController(
        text: widget.acft.rank == ''
            ? widget.acft.name
            : '${widget.acft.rank} ${widget.acft.name}');

    regExp = new RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: const Text('ACFT Details'),
        actions: <Widget>[
          IconButton(
            onPressed: _downloadPdf,
            icon: Icon(Icons.picture_as_pdf),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          _updateAcft(context, widget.acft);
        },
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: RepaintBoundary(
            key: previewContainer,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Column(
                children: <Widget>[
                  GridView.count(
                    crossAxisCount: width > 700 ? 2 : 1,
                    childAspectRatio: width > 700 ? width / 200 : width / 100,
                    primary: false,
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          controller: _mainNameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
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
                        padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                        child: const Text(
                          'MDL',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.mdlRaw,
                          decoration: const InputDecoration(labelText: 'Raw'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.mdlScore,
                          decoration: const InputDecoration(labelText: 'Score'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                        child: const Text(
                          'SPT',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.sptRaw,
                          decoration: const InputDecoration(labelText: 'Raw'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.sptScore,
                          decoration: const InputDecoration(labelText: 'Score'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                        child: const Text(
                          'HRP',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.hrpRaw,
                          decoration: const InputDecoration(labelText: 'Raw'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.hrpScore,
                          decoration: const InputDecoration(labelText: 'Score'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                        child: const Text(
                          'SDC',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.sdcRaw,
                          decoration: const InputDecoration(labelText: 'Raw'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.sdcScore,
                          decoration: const InputDecoration(labelText: 'Score'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                        child: const Text(
                          'PLK',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.plkRaw,
                          decoration: const InputDecoration(labelText: 'Raw'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.plkScore,
                          decoration: const InputDecoration(labelText: 'Score'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                        child: Text(
                          widget.acft.runEvent,
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.runRaw,
                          decoration: const InputDecoration(labelText: 'Raw'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.runScore,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Text(
                          '',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.acft.total,
                          decoration: const InputDecoration(labelText: 'Score'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
