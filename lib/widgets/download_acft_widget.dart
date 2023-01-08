import 'package:acft_calculator/sqlite/acft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../methods/download_acft.dart';

class DownloadAcftWidget extends StatefulWidget {
  final Acft acft;
  const DownloadAcftWidget(this.acft, {Key? key}) : super(key: key);

  @override
  State<DownloadAcftWidget> createState() => _DownloadAcftWidgetState();
}

class _DownloadAcftWidgetState extends State<DownloadAcftWidget> {
  final _unitController = TextEditingController();
  final _mosController = TextEditingController();
  final _oicController = TextEditingController();
  final _oicGradeController = TextEditingController();
  // final _bmiDateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bfController = TextEditingController();

  final _bmiDateFocus = FocusNode();
  final _bfFocus = FocusNode();

  bool? bodyComp = false, bmiPass = true, bfPass = true, altPass = true;

  @override
  void dispose() {
    super.dispose();

    _unitController.dispose();
    _mosController.dispose();
    _oicController.dispose();
    _oicGradeController.dispose();
    // _bmiDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bfController.dispose();

    _bmiDateFocus.dispose();
    _bfFocus.dispose();
  }

  @override
  void initState() {
    super.initState();

    altPass = widget.acft.altPass == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom == 0
              ? MediaQuery.of(context).padding.bottom
              : MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Additional DA Form 705 Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _unitController,
              decoration: const InputDecoration(labelText: 'Unit / Location'),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _mosController,
              decoration: const InputDecoration(labelText: 'MOS'),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _oicController,
              decoration: const InputDecoration(labelText: 'OIC / NCOIC'),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _oicGradeController,
              decoration: const InputDecoration(labelText: 'OIC / NCOIC Grade'),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
            ),
          ),
          if (widget.acft.runEvent != 'Run' && widget.acft.pass == 0)
            CheckboxListTile(
              value: altPass,
              onChanged: (value) {
                setState(() {
                  altPass = value;
                });
              },
              title: Text('Aerobic Event Go'),
            ),
          CheckboxListTile(
            value: bodyComp,
            onChanged: (value) {
              setState(() {
                bodyComp = value;
                if (value!) {
                  _bmiDateFocus.requestFocus();
                } else {
                  FocusScope.of(context).unfocus();
                }
              });
            },
            title: Text('Add Height/Weight Data'),
          ),
          if (bodyComp!)
            Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 8.0),
                //   child: TextFormField(
                //     controller: _bmiDateController,
                //     focusNode: _bmiDateFocus,
                //     decoration:
                //         const InputDecoration(labelText: 'Body Comp Date'),
                //     keyboardType: TextInputType.numberWithOptions(signed: true),
                //     inputFormatters: [
                //       FilteringTextInputFormatter.digitsOnly,
                //     ],
                //     autocorrect: false,
                //     textInputAction: TextInputAction.next,
                //     onEditingComplete: () => FocusScope.of(context).nextFocus(),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(labelText: 'Height'),
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: 'Weight'),
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                ),
                CheckboxListTile(
                  value: bmiPass,
                  onChanged: (value) {
                    setState(() {
                      bmiPass = value;
                      if (value!) {
                        FocusScope.of(context).unfocus();
                      } else {
                        _bfFocus.requestFocus();
                      }
                    });
                  },
                  title: Text('Height/Weight Pass'),
                ),
                if (!bmiPass!)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: _bfController,
                      focusNode: _bfFocus,
                      decoration: const InputDecoration(labelText: 'BodyFat %'),
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      autocorrect: false,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                  ),
                if (!bmiPass!)
                  CheckboxListTile(
                    value: bfPass,
                    onChanged: (value) {
                      setState(() {
                        bfPass = value;
                      });
                    },
                    title: Text('Bodyfat % Pass'),
                  ),
              ],
            ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              child: Text('Download PDF'),
              onPressed: () {
                Navigator.of(context).pop();
                DownloadAcft.downloadPdf(
                  context: context,
                  acft: widget.acft,
                  unitLoc: _unitController.text,
                  mos: _mosController.text,
                  oic: _oicController.text,
                  oicGrade: _oicGradeController.text,
                  // bmiDate: bodyComp ? _bmiDateController.text : '',
                  height: bodyComp! ? _heightController.text : '',
                  weight: bodyComp! ? _weightController.text : '',
                  bf: bodyComp! ? _bfController.text : '',
                  bmiPass: bodyComp! ? bmiPass : null,
                  bfPass: bodyComp! && !bmiPass! ? bfPass : null,
                  altPass: altPass,
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
