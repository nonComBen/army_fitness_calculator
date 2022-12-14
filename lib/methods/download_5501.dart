import 'dart:io';

import 'package:acft_calculator/sqlite/bodyfat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Download5501 {
  static Future<void> downloadPdf({
    BuildContext context,
    Bodyfat bf,
    String firstNeck,
    String secondNeck,
    String thirdNeck,
    String firstWaist,
    String secondWaist,
    String thirdWaist,
    String firstHip,
    String secondHip,
    String thirdHip,
    String preparedBy,
    String preparedByGrade,
    String approvedBy,
    String approvedByGrade,
  }) async {
    PdfDocument document;
    try {
      final byteData =
          await rootBundle.load('assets/documents/da_form_5501.pdf');
      document = PdfDocument(
          inputBytes: byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    } catch (e) {
      print('Error: $e');
    }
    var form = document.form;

    PdfTextBoxField name = form.fields[1];
    PdfTextBoxField rank = form.fields[3];
    PdfTextBoxField height = form.fields[2];
    PdfTextBoxField weight = form.fields[11];
    PdfTextBoxField age = form.fields[12];
    name.text = bf.name;
    rank.text = bf.rank;
    height.text = bf.heightDouble;
    weight.text = bf.weight;
    age.text = bf.age;

    PdfTextBoxField neck1 = form.fields[13];
    PdfTextBoxField neck2 = form.fields[14];
    PdfTextBoxField neck3 = form.fields[15];
    PdfTextBoxField neckAve = form.fields[16];
    PdfTextBoxField waist1 = form.fields[17];
    PdfTextBoxField waist2 = form.fields[22];
    PdfTextBoxField waist3 = form.fields[23];
    PdfTextBoxField waistAve = form.fields[24];
    PdfTextBoxField hip1 = form.fields[18];
    PdfTextBoxField hip2 = form.fields[19];
    PdfTextBoxField hip3 = form.fields[20];
    PdfTextBoxField hipAve = form.fields[21];
    neck1.text = firstNeck;
    neck2.text = secondNeck;
    neck3.text = thirdNeck;
    neckAve.text = bf.neck;
    waist1.text = firstWaist;
    waist2.text = secondWaist;
    waist3.text = thirdWaist;
    waistAve.text = bf.waist;
    hip1.text = firstHip;
    hip2.text = secondHip;
    hip3.text = thirdHip;
    hipAve.text = bf.hip;

    int weightNum = int.tryParse(bf.weight) ?? 0;
    int maxWeight = int.tryParse(bf.maxWeight) ?? 0;
    int bfPercent = int.tryParse(bf.bfPercent) ?? 0;
    int maxBf = int.tryParse(bf.maxPercent) ?? 0;
    double neckNum = double.tryParse(bf.neck) ?? 0;
    double waistNum = double.tryParse(bf.waist) ?? 0;
    double hipNum = double.tryParse(bf.hip) ?? 0;

    PdfTextBoxField neckCirc = form.fields[27];
    PdfTextBoxField waistCirc = form.fields[25];
    PdfTextBoxField hipCirc = form.fields[26];
    PdfTextBoxField waistPlusHip = form.fields[28];
    PdfTextBoxField circValue = form.fields[29];
    PdfTextBoxField heightTwo = form.fields[30];
    PdfTextBoxField bodyFat = form.fields[31];
    neckCirc.text = bf.neck;
    waistCirc.text = bf.waist;
    hipCirc.text = bf.hip;
    waistPlusHip.text = (waistNum + hipNum).toString();
    circValue.text = (waistNum + hipNum - neckNum).toString();
    heightTwo.text = bf.heightDouble;
    bodyFat.text = bf.bfPercent;

    PdfTextBoxField remarks = form.fields[0];
    String comments = 'Weight: ${bf.weight} lbs.\n'
        'Max Weight: ${bf.maxWeight} lbs.\n'
        'Over: ${weightNum - maxWeight} lbs.\n'
        'Bodyfat: ${bf.bfPercent}%\n'
        'Max Bodyfat: ${bf.maxPercent}%\n'
        'Over/Under: ${bfPercent - maxBf}%';
    remarks.text = comments;

    PdfCheckBoxField go = form.fields[32];
    PdfCheckBoxField noGo = form.fields[33];
    go.isChecked = bf.bfPass == 1;
    noGo.isChecked = bf.bfPass == 0;

    PdfTextBoxField preparedName = form.fields[4];
    PdfTextBoxField preparedRank = form.fields[5];
    PdfTextBoxField preparedDate = form.fields[8];
    PdfTextBoxField approvedName = form.fields[6];
    PdfTextBoxField approvedRank = form.fields[7];
    PdfTextBoxField approvedDate = form.fields[34];
    preparedName.text = preparedBy;
    preparedDate.text = bf.date;
    preparedRank.text = preparedByGrade;
    approvedName.text = approvedBy;
    approvedRank.text = approvedByGrade;
    approvedDate.text = bf.date;

    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status == PermissionStatus.granted) {
      try {
        final dir = await getTemporaryDirectory();
        // final fileName = '${dir.path}/705_fields.txt';
        final fileName = '${dir.path}/${bf.rank}_${bf.name}_5501.pdf';
        var file = File(fileName);
        file.writeAsBytesSync(document.saveSync());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'DA Form 5501 has been downloaded to a temporary folder. Open and save to a permanent folder.'),
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
