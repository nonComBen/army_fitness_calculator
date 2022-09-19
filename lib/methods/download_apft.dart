import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../sqlite/apft.dart';

class DownloadApft {
  static Future<void> downloadPdf({
    BuildContext context,
    Apft apft,
    String unitLoc,
    String mos,
    bool altPass,
    String oic,
    String oicGrade,
    String bmiDate = '',
    String height = '',
    String weight = '',
    bool bmiPass,
    String bf = '',
    bool bfPass,
    String comments = '',
  }) async {
    PdfDocument document;
    try {
      final byteData =
          await rootBundle.load('assets/documents/da_form_705.pdf');
      document = PdfDocument(
          inputBytes: byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    } catch (e) {
      print('Error: $e');
    }
    var form = document.form;
    // print(form.fields.count);
    // String string = '';
    // for (int i = 0; i < form.fields.count; i++) {
    //   string = string + '$i, ${form.fields[i].name}, ${form.fields[i]}\n';
    // }

    PdfTextBoxField name = form.fields[49];
    PdfTextBoxField unit = form.fields[90];
    PdfTextBoxField gender = form.fields[0];
    name.text = apft.name;
    unit.text = unitLoc;
    gender.text = apft.gender;
    PdfCheckBoxField bmiGo = form.fields[73];
    PdfCheckBoxField bmiNoGo = form.fields[74];
    PdfCheckBoxField bfGo = form.fields[78];
    PdfCheckBoxField bfNoGo = form.fields[77];
    if (bmiPass != null) {
      bmiGo.isChecked = bmiPass;
      bmiNoGo.isChecked = !bmiPass;
    }
    if (bfPass != null) {
      bfGo.isChecked = bfPass;
      bfNoGo.isChecked = !bfPass;
    }
    PdfTextBoxField bmiDateField = form.fields[52];
    PdfTextBoxField heightField = form.fields[24];
    PdfTextBoxField weightField = form.fields[27];
    PdfTextBoxField bfField = form.fields[28];
    PdfTextBoxField date = form.fields[91];
    PdfTextBoxField mosField = form.fields[1];
    PdfTextBoxField rank = form.fields[2];
    PdfTextBoxField age = form.fields[17];
    PdfTextBoxField puRaw = form.fields[70];
    PdfTextBoxField puScore = form.fields[67];
    PdfTextBoxField suRaw = form.fields[71];
    PdfTextBoxField suScore = form.fields[68];
    PdfTextBoxField runRaw = form.fields[72];
    PdfTextBoxField runScore = form.fields[69];
    PdfTextBoxField altRaw = form.fields[21];
    bmiDateField.text = bmiDate;
    heightField.text = height;
    weightField.text = weight;
    bfField.text = bf;
    date.text = apft.date;
    mosField.text = mos;
    rank.text = apft.rank;
    age.text = apft.age;
    puScore.text = apft.puScore;
    puRaw.text = apft.puRaw;
    suRaw.text = apft.suRaw;
    suScore.text = apft.suScore;
    runScore.text = apft.runScore;
    if (apft.runEvent == 'Run') {
      runRaw.text = apft.runRaw;
    } else {
      PdfCheckBoxField swim = form.fields[7];
      PdfCheckBoxField walk = form.fields[8];
      PdfCheckBoxField bike = form.fields[13];
      swim.isChecked = apft.runEvent == 'Swim';
      walk.isChecked = apft.runEvent == 'Walk';
      bike.isChecked = apft.runEvent == 'Bike';
      altRaw.text = apft.runRaw;
      PdfCheckBoxField altGo = form.fields[100];
      PdfCheckBoxField altNoGo = form.fields[16];
      altGo.isChecked = altPass;
      altNoGo.isChecked = !altPass;
    }

    PdfTextBoxField total = form.fields[105];
    PdfCheckBoxField go = form.fields[109];
    PdfCheckBoxField noGo = form.fields[108];
    total.text = apft.total;
    go.isChecked = apft.pass == 1;
    noGo.isChecked = apft.pass == 0;

    PdfTextBoxField smSigDate = form.fields[94];
    PdfTextBoxField oicField = form.fields[85];
    PdfTextBoxField oicGradeField = form.fields[18];
    PdfTextBoxField oicSigDate = form.fields[95];
    PdfTextBoxField commentsField = form.fields[33];
    smSigDate.text = apft.date;
    total.text = apft.total;
    oicField.text = oic;
    oicGradeField.text = oicGrade;
    oicSigDate.text = apft.date;
    commentsField.text = comments;

    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status == PermissionStatus.granted) {
      try {
        final dir = await getTemporaryDirectory();
        // final fileName = '${dir.path}/705_fields.txt';
        final fileName = '${dir.path}/${apft.rank}_${apft.name}_705.pdf';
        var file = File(fileName);
        file.writeAsBytesSync(document.saveSync());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'DA Form 705 has been downloaded to a temporary folder. Open and save to a permanent foldier.'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () => OpenFile.open(fileName),
            ),
          ),
        );
      } on Exception catch (e) {
        print('Error: $e');
      }
    }
    document.dispose();
  }
}
