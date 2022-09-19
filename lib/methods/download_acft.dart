import 'dart:io';

import 'package:acft_calculator/sqlite/acft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DownloadAcft {
  static Future<void> downloadPdf({
    BuildContext context,
    Acft acft,
    String unitLoc,
    String mos,
    String oic,
    String oicGrade,
    String bmiDate = '',
    String height = '',
    String weight = '',
    bool bmiPass,
    String bf = '',
    bool bfPass,
    bool altPass,
  }) async {
    PdfDocument document;
    try {
      final byteData =
          await rootBundle.load('assets/documents/da_form_705_acft.pdf');
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

    PdfTextBoxField name = form.fields[0];
    PdfTextBoxField unit = form.fields[29];
    name.text = acft.name;
    unit.text = unitLoc;
    PdfCheckBoxField female = form.fields[6];
    PdfCheckBoxField male = form.fields[5];
    PdfCheckBoxField bmiGo = form.fields[7];
    PdfCheckBoxField bmiNoGo = form.fields[15];
    PdfCheckBoxField bfGo = form.fields[8];
    PdfCheckBoxField bfNoGo = form.fields[9];
    PdfCheckBoxField mdlFirst = form.fields[12];
    PdfCheckBoxField sptFirst = form.fields[11];
    female.isChecked = acft.gender == 'Female';
    male.isChecked = acft.gender == 'Male';
    if (bmiPass != null) {
      bmiGo.isChecked = bmiPass;
      bmiNoGo.isChecked = !bmiPass;
    }
    if (bfPass != null) {
      bfGo.isChecked = bfPass;
      bfNoGo.isChecked = !bfPass;
    }
    // PdfTextBoxField bmiDateField = form.fields[5];
    PdfTextBoxField heightField = form.fields[10];
    PdfTextBoxField weightField = form.fields[48];
    PdfTextBoxField bfField = form.fields[49];
    PdfTextBoxField date = form.fields[1];
    PdfTextBoxField mosField = form.fields[2];
    PdfTextBoxField rank = form.fields[3];
    PdfTextBoxField age = form.fields[4];
    PdfTextBoxField mdlRaw1 = form.fields[30];
    PdfTextBoxField mdlRaw2 = form.fields[31];
    PdfTextBoxField mdlScore = form.fields[34];
    PdfTextBoxField sptRaw1 = form.fields[33];
    PdfTextBoxField sptRaw2 = form.fields[32];
    PdfTextBoxField sptScore = form.fields[35];
    PdfTextBoxField hrpRaw = form.fields[36];
    PdfTextBoxField hrpScore = form.fields[37];
    PdfTextBoxField sdcRaw = form.fields[39];
    PdfTextBoxField sdcScore = form.fields[38];
    PdfTextBoxField plkRaw = form.fields[40];
    PdfTextBoxField plkScore = form.fields[41];
    // bmiDateField.text = bmiDate;
    heightField.text = height;
    weightField.text = weight;
    bfField.text = bf;
    date.text = acft.date;
    mosField.text = mos;
    rank.text = acft.rank;
    age.text = acft.age;
    mdlScore.text = acft.mdlScore;
    mdlFirst.isChecked = true;
    mdlRaw1.text = acft.mdlRaw;
    mdlRaw2.text = acft.mdlRaw;
    sptFirst.isChecked = true;
    sptRaw1.text = acft.sptRaw;
    sptRaw2.text = acft.sptRaw;
    sptScore.text = acft.sptScore;
    hrpScore.text = acft.hrpScore;
    hrpRaw.text = acft.hrpRaw;
    sdcScore.text = acft.sdcScore;
    sdcRaw.text = acft.sdcRaw;
    plkScore.text = acft.plkScore;
    plkRaw.text = acft.plkRaw;
    if (acft.runEvent == 'Run') {
      PdfTextBoxField runRaw = form.fields[43];
      PdfTextBoxField runScore = form.fields[42];
      runScore.text = acft.runScore;
      runRaw.text = acft.runRaw;
    } else {
      PdfTextBoxField runEvent = form.fields[44];
      runEvent.text = acft.runEvent == 'Row'
          ? '5K ROW'
          : acft.runEvent == 'Swim'
              ? '1K SWIM'
              : acft.runEvent == 'Bike'
                  ? '12K BIKE'
                  : '2.5MI WALK';
      PdfTextBoxField runRaw = form.fields[46];
      PdfTextBoxField runScore = form.fields[45];
      runScore.text = acft.runScore;
      runRaw.text = acft.runRaw;
      PdfCheckBoxField altGo = form.fields[18];
      PdfCheckBoxField altNoGo = form.fields[19];
      altGo.isChecked = altPass;
      altNoGo.isChecked = !altPass;
    }
    PdfCheckBoxField go = form.fields[17];
    PdfCheckBoxField noGo = form.fields[16];
    go.isChecked = acft.pass == 1;
    noGo.isChecked = acft.pass == 0;
    PdfTextBoxField smSigDate = form.fields[47];
    PdfTextBoxField total = form.fields[52];
    PdfTextBoxField oicField = form.fields[50];
    PdfTextBoxField oicGradeField = form.fields[51];
    PdfTextBoxField oicSigDate = form.fields[53];
    smSigDate.text = acft.date;
    total.text = acft.total;
    oicField.text = oic;
    oicGradeField.text = oicGrade;
    oicSigDate.text = acft.date;

    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status == PermissionStatus.granted) {
      try {
        final dir = await getTemporaryDirectory();
        // final fileName = '${dir.path}/705_fields.txt';
        final fileName = '${dir.path}/${acft.rank}_${acft.name}_705.pdf';
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
