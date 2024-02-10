import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../methods/theme_methods.dart';
import '../../sqlite/bodyfat.dart';
import '../../widgets/my_toast.dart';
import '../../widgets/platform_widgets/platform_text_button.dart';

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

    PdfTextBoxField name = form.fields[20] as PdfTextBoxField;
    PdfTextBoxField rank = form.fields[21] as PdfTextBoxField;
    PdfTextBoxField height = form.fields[22] as PdfTextBoxField;
    PdfTextBoxField weight = form.fields[24] as PdfTextBoxField;
    PdfTextBoxField age = form.fields[23] as PdfTextBoxField;

    PdfTextBoxField name2 = form.fields[27] as PdfTextBoxField;
    PdfTextBoxField rank2 = form.fields[45] as PdfTextBoxField;
    PdfTextBoxField height3 = form.fields[43] as PdfTextBoxField;
    PdfTextBoxField weight2 = form.fields[51] as PdfTextBoxField;
    PdfTextBoxField age2 = form.fields[44] as PdfTextBoxField;
    name.text = bf.name!;
    rank.text = bf.rank!;
    height.text = bf.heightDouble;
    weight.text = bf.weight;
    age.text = bf.age;

    name2.text = bf.name!;
    rank2.text = bf.rank!;
    height3.text = bf.heightDouble;
    weight2.text = bf.weight;
    age2.text = bf.age;

    if (bf.is540Exempt == 0) {
      PdfTextBoxField waist1 = form.fields[6] as PdfTextBoxField;
      PdfTextBoxField waist2 = form.fields[7] as PdfTextBoxField;
      PdfTextBoxField waist3 = form.fields[8] as PdfTextBoxField;
      PdfTextBoxField waistAve = form.fields[9] as PdfTextBoxField;

      PdfTextBoxField abdom1 = form.fields[29] as PdfTextBoxField;
      PdfTextBoxField abdom2 = form.fields[30] as PdfTextBoxField;
      PdfTextBoxField abdom3 = form.fields[31] as PdfTextBoxField;

      waist1.text = firstWaist;
      waist2.text = secondWaist;
      waist3.text = thirdWaist;
      waistAve.text = bf.waist;

      abdom1.text = firstWaist;
      abdom2.text = secondWaist;
      abdom3.text = thirdWaist;

      PdfTextBoxField abdomAve = form.fields[32] as PdfTextBoxField;
      PdfTextBoxField abdomAveCir = form.fields[33] as PdfTextBoxField;
      PdfTextBoxField weightAve = form.fields[34] as PdfTextBoxField;
      abdomAve.text = bf.waist;
      abdomAveCir.text = bf.waist;
      weightAve.text = bf.weight;

      final overWeight = int.parse(bf.weight) - int.parse(bf.maxWeight);
      final remarks =
          'Weight: ${bf.weight} lbs.\nMax Weight: ${bf.maxWeight} lbs.\nOver: ${overWeight.toString()} lbs.\n'
          'Bodyfat Percentage: ${bf.bfPercent}%\nAllowed Percentage: ${bf.maxPercent}%\nOver/Under: ${bf.overUnder}%';

      if (bf.isNewVersion == 0) {
        PdfTextBoxField neck1 = form.fields[2] as PdfTextBoxField;
        PdfTextBoxField neck2 = form.fields[3] as PdfTextBoxField;
        PdfTextBoxField neck3 = form.fields[4] as PdfTextBoxField;
        neck1.text = firstNeck;
        neck2.text = secondNeck;
        neck3.text = thirdNeck;

        PdfTextBoxField neckAve = form.fields[5] as PdfTextBoxField;
        PdfTextBoxField neckAveCir = form.fields[10] as PdfTextBoxField;
        PdfTextBoxField waistAveCir = form.fields[11] as PdfTextBoxField;
        PdfTextBoxField circValue = form.fields[12] as PdfTextBoxField;
        PdfTextBoxField height2 = form.fields[28] as PdfTextBoxField;
        neckAve.text = bf.neck;
        neckAveCir.text = bf.neck;
        waistAveCir.text = bf.waist;
        circValue.text =
            (double.parse(bf.waist) - double.parse(bf.neck)).toString();
        height2.text = bf.heightDouble;

        PdfTextBoxField bfPercent = form.fields[13] as PdfTextBoxField;
        bfPercent.text = bf.bfPercent;

        PdfTextBoxField remarksField = form.fields[0] as PdfTextBoxField;
        remarksField.text = remarks;

        PdfCheckBoxField bfGo = form.fields[17] as PdfCheckBoxField;
        PdfCheckBoxField bfNoGo = form.fields[46] as PdfCheckBoxField;
        bfGo.isChecked = bf.bfPass == 1;
        bfNoGo.isChecked = bf.bfPass == 0;
      } else {
        PdfTextBoxField bfPercent2 = form.fields[35] as PdfTextBoxField;
        bfPercent2.text = bf.bfPercent;

        PdfTextBoxField remarksField2 = form.fields[1] as PdfTextBoxField;
        remarksField2.text = remarks;

        PdfCheckBoxField bfGo2 = form.fields[54] as PdfCheckBoxField;
        PdfCheckBoxField bfNoGo2 = form.fields[53] as PdfCheckBoxField;
        bfGo2.isChecked = bf.bfPass == 1;
        bfNoGo2.isChecked = bf.bfPass == 0;
      }
    }

    PdfTextBoxField preparedNameField = form.fields[19] as PdfTextBoxField;
    PdfTextBoxField preparedRank = form.fields[18] as PdfTextBoxField;
    PdfTextBoxField preparedDate = form.fields[14] as PdfTextBoxField;
    PdfTextBoxField superNameField = form.fields[50] as PdfTextBoxField;
    PdfTextBoxField superRank = form.fields[15] as PdfTextBoxField;
    PdfTextBoxField superDate = form.fields[16] as PdfTextBoxField;
    preparedNameField.text = preparedName;
    preparedRank.text = preparedGrade;
    preparedDate.text = bf.date!;
    superNameField.text = superName;
    superRank.text = superGrade;
    superDate.text = bf.date!;

    PdfTextBoxField preparedNameField2 = form.fields[55] as PdfTextBoxField;
    PdfTextBoxField preparedRank2 = form.fields[39] as PdfTextBoxField;
    PdfTextBoxField preparedDate2 = form.fields[47] as PdfTextBoxField;
    PdfTextBoxField superNameField2 = form.fields[56] as PdfTextBoxField;
    PdfTextBoxField superRank2 = form.fields[40] as PdfTextBoxField;
    PdfTextBoxField superDate2 = form.fields[41] as PdfTextBoxField;
    preparedNameField2.text = preparedName;
    preparedRank2.text = preparedGrade;
    preparedDate2.text = bf.date!;
    superNameField2.text = superName;
    superRank2.text = superGrade;
    superDate2.text = bf.date!;

    getApplicationDocumentsDirectory().then((dir) {
      final fileName = '${dir.path}/${bf.rank}_${bf.name}_5500.pdf';
      var file = File(fileName);
      final List<int> bytes = document.saveSync();
      file.writeAsBytesSync(bytes);
      document.dispose();

      FToast toast = FToast();
      toast.context = context;
      toast.showToast(
        toastDuration: Duration(seconds: 5),
        child: MyToast(
          contents: [
            Expanded(
              flex: 3,
              child: Text(
                'DA Form 5500 has been downloaded to a temporary folder. Open and save to a permanent folder.',
                style: TextStyle(
                  color: getOnPrimaryColor(context!),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: PlatformTextButton(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    'Open',
                    style: TextStyle(
                      color: getOnPrimaryColor(context),
                    ),
                  ),
                ),
                onPressed: () => OpenFile.open(fileName),
              ),
            ),
          ],
        ),
      );
    });
  }
}
