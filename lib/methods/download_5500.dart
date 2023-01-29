import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../sqlite/bodyfat.dart';

class Download5500 {
  static Future<void> downloadPdf({
    BuildContext? context,
    required Bodyfat bf,
    required String firstNeck,
    required String secondNeck,
    required String thirdNeck,
    required String firstWaist,
    required String secondWaist,
    required String thirdWaist,
    required String preparedName,
    required String preparedGrade,
    required String superName,
    required String superGrade,
  }) async {
    late PdfDocument document;
    try {
      final byteData =
          await rootBundle.load('assets/documents/da_form_5500.pdf');
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

    PdfTextBoxField name = form.fields[1] as PdfTextBoxField;
    PdfTextBoxField rank = form.fields[3] as PdfTextBoxField;
    PdfTextBoxField height = form.fields[2] as PdfTextBoxField;
    PdfTextBoxField weight = form.fields[4] as PdfTextBoxField;
    PdfTextBoxField age = form.fields[5] as PdfTextBoxField;
    name.text = bf.name!;
    rank.text = bf.rank!;
    height.text = bf.heightDouble;
    weight.text = bf.weight;
    age.text = bf.age;
    PdfTextBoxField neck1 = form.fields[6] as PdfTextBoxField;
    PdfTextBoxField waist1 = form.fields[9] as PdfTextBoxField;
    PdfTextBoxField neck2 = form.fields[7] as PdfTextBoxField;
    PdfTextBoxField waist2 = form.fields[10] as PdfTextBoxField;
    PdfTextBoxField neck3 = form.fields[8] as PdfTextBoxField;
    PdfTextBoxField waist3 = form.fields[11] as PdfTextBoxField;
    neck1.text = firstNeck;
    waist1.text = firstWaist;
    neck2.text = secondNeck;
    waist2.text = secondWaist;
    neck3.text = thirdNeck;
    waist3.text = thirdWaist;
    PdfTextBoxField neckAve = form.fields[12] as PdfTextBoxField;
    PdfTextBoxField waistAve = form.fields[13] as PdfTextBoxField;
    PdfTextBoxField neckAveCir = form.fields[14] as PdfTextBoxField;
    PdfTextBoxField waistAveCir = form.fields[15] as PdfTextBoxField;
    PdfTextBoxField circValue = form.fields[16] as PdfTextBoxField;
    PdfTextBoxField height2 = form.fields[17] as PdfTextBoxField;
    PdfTextBoxField bfPercent = form.fields[18] as PdfTextBoxField;
    neckAve.text = bf.neck;
    waistAve.text = bf.waist;
    neckAveCir.text = bf.neck;
    waistAveCir.text = bf.waist;
    circValue.text =
        (double.parse(bf.waist) - double.parse(bf.neck)).toString();
    height2.text = bf.heightDouble;
    bfPercent.text = bf.bfPercent;

    final overWeight = int.parse(bf.weight) - int.parse(bf.maxWeight);
    //String overUnder = bf.bfPass == 1 ? 'Under' : 'Over';
    final remarks =
        'Weight: ${bf.weight} lbs.\nMax Weight: ${bf.maxWeight} lbs.\nOver: ${overWeight.toString()} lbs.\n'
        'Bodyfat Percentage: ${bf.bfPercent}%\nAllowed Percentage: ${bf.maxPercent}%\nOver/Under: ${bf.overUnder}%';
    PdfTextBoxField remarksField = form.fields[0] as PdfTextBoxField;
    remarksField.text = remarks;

    PdfCheckBoxField bfGo = form.fields[21] as PdfCheckBoxField;
    PdfCheckBoxField bfNoGo = form.fields[20] as PdfCheckBoxField;
    bfGo.isChecked = bf.bfPass == 1;
    bfNoGo.isChecked = bf.bfPass == 0;
    PdfTextBoxField preparedNameField = form.fields[22] as PdfTextBoxField;
    PdfTextBoxField preparedRank = form.fields[24] as PdfTextBoxField;
    PdfTextBoxField preparedDate = form.fields[25] as PdfTextBoxField;
    PdfTextBoxField superNameField = form.fields[19] as PdfTextBoxField;
    PdfTextBoxField superRank = form.fields[23] as PdfTextBoxField;
    PdfTextBoxField superDate = form.fields[26] as PdfTextBoxField;
    preparedNameField.text = preparedName;
    preparedRank.text = preparedGrade;
    preparedDate.text = bf.date!;
    superNameField.text = superName;
    superRank.text = superGrade;
    superDate.text = bf.date!;

    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status == PermissionStatus.granted) {
      try {
        final dir = await getTemporaryDirectory();
        // final fileName = '${dir.path}/5500_fields.txt';
        final fileName = '${dir.path}/${bf.rank}_${bf.name}_5500.pdf';
        var file = File(fileName);
        file.writeAsBytesSync(document.saveSync());

        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            content: Text(
                'DA Form 5500 has been downloaded to a temporary folder. Open and save to a permanent folder.'),
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
