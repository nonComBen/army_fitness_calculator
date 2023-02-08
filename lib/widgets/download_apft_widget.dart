import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../methods/download_apft.dart';
import '../sqlite/apft.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import 'platform_widgets/platform_text_field.dart';

class DownloadApftWidget extends StatefulWidget {
  final Apft apft;
  const DownloadApftWidget(this.apft, {Key? key}) : super(key: key);

  @override
  State<DownloadApftWidget> createState() => _DownloadApftWidgetState();
}

class _DownloadApftWidgetState extends State<DownloadApftWidget> {
  final _unitController = TextEditingController();
  final _mosController = TextEditingController();
  final _oicController = TextEditingController();
  final _oicGradeController = TextEditingController();
  final _bmiDateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bfController = TextEditingController();
  final _commentController = TextEditingController();

  final _bmiDateFocus = FocusNode();
  final _bfFocus = FocusNode();
  final _commentFocus = FocusNode();

  bool? bodyComp = false,
      bmiPass = true,
      bfPass = true,
      altPass = true,
      maxlines = false;

  @override
  void dispose() {
    super.dispose();

    _unitController.dispose();
    _mosController.dispose();
    _oicController.dispose();
    _oicGradeController.dispose();
    _bmiDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bfController.dispose();
    _commentController.dispose();

    _bmiDateFocus.dispose();
    _bfFocus.dispose();
    _commentFocus.dispose();
  }

  @override
  void initState() {
    super.initState();

    altPass = widget.apft.altPass == 1;
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
            child: PlatformTextField(
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
            child: PlatformTextField(
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
            child: PlatformTextField(
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
            child: PlatformTextField(
              controller: _oicGradeController,
              decoration: const InputDecoration(labelText: 'OIC / NCOIC Grade'),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
            ),
          ),
          if (widget.apft.runEvent != 'Run' && widget.apft.pass == 0)
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: PlatformTextField(
                    controller: _bmiDateController,
                    focusNode: _bmiDateFocus,
                    decoration:
                        const InputDecoration(labelText: 'Body Comp Date'),
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
                  child: PlatformTextField(
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
                  child: PlatformTextField(
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
                    child: PlatformTextField(
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
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: PlatformTextField(
              controller: _commentController,
              focusNode: _commentFocus,
              decoration: const InputDecoration(labelText: 'Comments'),
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              autocorrect: false,
              textInputAction:
                  maxlines! ? TextInputAction.done : TextInputAction.newline,
              onChanged: (value) {
                final span = _commentController.buildTextSpan(
                    context: context, style: TextStyle(), withComposing: false);
                final tp = TextPainter(text: span);
                tp.textDirection = TextDirection.ltr;
                tp.layout(maxWidth: MediaQuery.of(context).size.width);

                int lines = tp.computeLineMetrics().length;
                setState(() {
                  if (lines >= 4) {
                    maxlines = true;
                  } else {
                    maxlines = false;
                  }
                });
              },
              onEditingComplete: () => FocusScope.of(context).unfocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: PlatformButton(
              child: Text('Download PDF'),
              onPressed: () {
                Navigator.of(context).pop();
                DownloadApft.downloadPdf(
                  context: context,
                  apft: widget.apft,
                  unitLoc: _unitController.text,
                  mos: _mosController.text,
                  altPass: altPass,
                  oic: _oicController.text,
                  oicGrade: _oicGradeController.text,
                  bmiDate: bodyComp! ? _bmiDateController.text : '',
                  height: bodyComp! ? _heightController.text : '',
                  weight: bodyComp! ? _weightController.text : '',
                  bf: bodyComp! ? _bfController.text : '',
                  bmiPass: bodyComp! ? bmiPass : null,
                  bfPass: bodyComp! && !bmiPass! ? bfPass : null,
                  comments: _commentController.text,
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
