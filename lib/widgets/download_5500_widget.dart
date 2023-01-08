import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../methods/download_5500.dart';
import '../sqlite/bodyfat.dart';

class Download5500Widget extends StatelessWidget {
  final Bodyfat? bf;
  Download5500Widget(this.bf, {Key? key}) : super(key: key);

  final _preparedByController = TextEditingController();
  final _preparedByRankController = TextEditingController();
  final _approvedByController = TextEditingController();
  final _approvedByRankController = TextEditingController();
  final _neck1Controller = TextEditingController();
  final _neck2Controller = TextEditingController();
  final _neck3Controller = TextEditingController();
  final _waist1Controller = TextEditingController();
  final _waist2Controller = TextEditingController();
  final _waist3Controller = TextEditingController();

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
              'Additional DA Form 5500 Data',
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
              controller: _preparedByController,
              decoration: const InputDecoration(labelText: 'Prepared By Name'),
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
              controller: _preparedByRankController,
              decoration: const InputDecoration(labelText: 'Prepared By Rank'),
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
              controller: _approvedByController,
              decoration: const InputDecoration(labelText: 'Approved By Name'),
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
              controller: _approvedByRankController,
              decoration: const InputDecoration(labelText: 'Approved By Rank'),
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
              controller: _neck1Controller,
              decoration: const InputDecoration(
                labelText: 'First Neck',
                hintText: 'Leave blank to use calculator value',
              ),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              ],
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _neck2Controller,
              decoration: const InputDecoration(
                labelText: 'Second Neck',
                hintText: 'Leave blank to use calculator value',
              ),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              ],
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _neck3Controller,
              decoration: const InputDecoration(
                labelText: 'Third Neck',
                hintText: 'Leave blank to use calculator value',
              ),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              ],
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _waist1Controller,
              decoration: const InputDecoration(
                labelText: 'First Waist',
                hintText: 'Leave blank to use calculator value',
              ),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              ],
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _waist2Controller,
              decoration: const InputDecoration(
                labelText: 'Second Waist',
                hintText: 'Leave blank to use calculator value',
              ),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              ],
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _waist3Controller,
              decoration: const InputDecoration(
                labelText: 'Third Waist',
                hintText: 'Leave blank to use calculator value',
              ),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              ],
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              child: Text('Download PDF'),
              onPressed: () {
                Navigator.of(context).pop();
                Download5500.downloadPdf(
                  context: context,
                  bf: bf!,
                  preparedName: _preparedByController.text,
                  preparedGrade: _preparedByRankController.text,
                  superName: _approvedByController.text,
                  superGrade: _approvedByRankController.text,
                  firstNeck: _neck1Controller.text == ''
                      ? bf!.neck
                      : _neck1Controller.text,
                  secondNeck: _neck2Controller.text == ''
                      ? bf!.neck
                      : _neck2Controller.text,
                  thirdNeck: _neck3Controller.text == ''
                      ? bf!.neck
                      : _neck3Controller.text,
                  firstWaist: _waist1Controller.text == ''
                      ? bf!.waist
                      : _waist1Controller.text,
                  secondWaist: _waist2Controller.text == ''
                      ? bf!.waist
                      : _waist2Controller.text,
                  thirdWaist: _waist3Controller.text == ''
                      ? bf!.waist
                      : _waist3Controller.text,
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
