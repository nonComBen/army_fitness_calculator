import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../methods/theme_methods.dart';
import '../../sqlite/bodyfat.dart';
import '../../widgets/my_toast.dart';
import '../../widgets/platform_widgets/platform_text_button.dart';

class Download5501 {
  static Future<void> downloadPdf({
    BuildContext? context,
    required Bodyfat bf,
    required String firstNeck,
    required String secondNeck,
    required String thirdNeck,
    required String firstWaist,
    required String secondWaist,
    required String thirdWaist,
    required String firstHip,
    required String secondHip,
    required String thirdHip,
    required String preparedBy,
    required String preparedByGrade,
    required String approvedBy,
    required String approvedByGrade,
  }) async {
    late PdfDocument document;

    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status != PermissionStatus.granted) {
      return;
    }

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

    // String string = '';
    // for (int i = 0; i < form.fields.count; i++) {
    //   string = string + '$i, ${form.fields[i].name}, ${form.fields[i]}\n';
    //   debugPrint(string);
    // }

    PdfTextBoxField name = form.fields[34] as PdfTextBoxField;
    PdfTextBoxField rank = form.fields[12] as PdfTextBoxField;
    PdfTextBoxField height = form.fields[11] as PdfTextBoxField;
    PdfTextBoxField weight = form.fields[13] as PdfTextBoxField;
    PdfTextBoxField age = form.fields[14] as PdfTextBoxField;
    name.text = bf.name!;
    rank.text = bf.rank!;
    height.text = bf.heightDouble;
    weight.text = bf.weight;
    age.text = bf.age;

    PdfTextBoxField name2 = form.fields[35] as PdfTextBoxField;
    PdfTextBoxField rank2 = form.fields[57] as PdfTextBoxField;
    PdfTextBoxField height2 = form.fields[36] as PdfTextBoxField;
    PdfTextBoxField weight2 = form.fields[37] as PdfTextBoxField;
    PdfTextBoxField age2 = form.fields[38] as PdfTextBoxField;
    name2.text = bf.name!;
    rank2.text = bf.rank!;
    height2.text = bf.heightDouble;
    weight2.text = bf.weight;
    age2.text = bf.age;

    if (bf.is540Exempt == 0) {
      PdfTextBoxField waist1 = form.fields[6] as PdfTextBoxField;
      PdfTextBoxField waist2 = form.fields[5] as PdfTextBoxField;
      PdfTextBoxField waist3 = form.fields[4] as PdfTextBoxField;
      PdfTextBoxField waistAve = form.fields[15] as PdfTextBoxField;
      waist1.text = firstWaist;
      waist2.text = secondWaist;
      waist3.text = thirdWaist;
      waistAve.text = bf.waist;

      int weightNum = int.tryParse(bf.weight) ?? 0;
      int maxWeight = int.tryParse(bf.maxWeight) ?? 0;
      int bfPercent = int.tryParse(bf.bfPercent) ?? 0;
      int maxBf = int.tryParse(bf.maxPercent) ?? 0;

      String comments = 'Weight: ${bf.weight} lbs.\n'
          'Max Weight: ${bf.maxWeight} lbs.\n'
          'Over: ${weightNum - maxWeight} lbs.\n'
          'Bodyfat: ${bf.bfPercent}%\n'
          'Max Bodyfat: ${bf.maxPercent}%\n'
          'Over/Under: ${bfPercent - maxBf}%';
      if (bf.isNewVersion == 0) {
        PdfTextBoxField neck1 = form.fields[0] as PdfTextBoxField;
        PdfTextBoxField neck2 = form.fields[1] as PdfTextBoxField;
        PdfTextBoxField neck3 = form.fields[2] as PdfTextBoxField;
        PdfTextBoxField neckAve = form.fields[3] as PdfTextBoxField;
        PdfTextBoxField hip1 = form.fields[7] as PdfTextBoxField;
        PdfTextBoxField hip2 = form.fields[8] as PdfTextBoxField;
        PdfTextBoxField hip3 = form.fields[9] as PdfTextBoxField;
        PdfTextBoxField hipAve = form.fields[10] as PdfTextBoxField;
        neck1.text = firstNeck;
        neck2.text = secondNeck;
        neck3.text = thirdNeck;
        neckAve.text = bf.neck;
        hip1.text = firstHip;
        hip2.text = secondHip;
        hip3.text = thirdHip;
        hipAve.text = bf.hip;

        double neckNum = double.tryParse(bf.neck) ?? 0;
        double waistNum = double.tryParse(bf.waist) ?? 0;
        double hipNum = double.tryParse(bf.hip) ?? 0;

        PdfTextBoxField neckCirc = form.fields[19] as PdfTextBoxField;
        PdfTextBoxField waistCirc = form.fields[17] as PdfTextBoxField;
        PdfTextBoxField hipCirc = form.fields[18] as PdfTextBoxField;
        PdfTextBoxField waistPlusHip = form.fields[16] as PdfTextBoxField;
        PdfTextBoxField circValue = form.fields[20] as PdfTextBoxField;
        PdfTextBoxField heightTwo = form.fields[21] as PdfTextBoxField;
        neckCirc.text = bf.neck;
        waistCirc.text = bf.waist;
        hipCirc.text = bf.hip;
        waistPlusHip.text = (waistNum + hipNum).toString();
        circValue.text = (waistNum + hipNum - neckNum).toString();
        heightTwo.text = bf.heightDouble;

        PdfTextBoxField bodyFat = form.fields[22] as PdfTextBoxField;
        bodyFat.text = bf.bfPercent;

        PdfTextBoxField remarks = form.fields[33] as PdfTextBoxField;
        remarks.text = comments;

        PdfCheckBoxField go = form.fields[24] as PdfCheckBoxField;
        PdfCheckBoxField noGo = form.fields[23] as PdfCheckBoxField;
        go.isChecked = bf.bfPass == 1;
        noGo.isChecked = bf.bfPass == 0;
      } else {
        PdfTextBoxField bodyfat2 = form.fields[45] as PdfTextBoxField;
        bodyfat2.text = bf.bfPercent;

        PdfTextBoxField remarks2 = form.fields[62] as PdfTextBoxField;
        remarks2.text = comments;

        PdfCheckBoxField go2 = form.fields[60] as PdfCheckBoxField;
        PdfCheckBoxField noGo2 = form.fields[59] as PdfCheckBoxField;
        go2.isChecked = bf.bfPass == 1;
        noGo2.isChecked = bf.bfPass == 0;
      }

      PdfTextBoxField abdom1 = form.fields[39] as PdfTextBoxField;
      PdfTextBoxField abdom2 = form.fields[40] as PdfTextBoxField;
      PdfTextBoxField abdom3 = form.fields[41] as PdfTextBoxField;
      PdfTextBoxField abdomAve = form.fields[42] as PdfTextBoxField;
      abdom1.text = firstWaist;
      abdom2.text = secondWaist;
      abdom3.text = thirdWaist;
      abdomAve.text = bf.waist;

      PdfTextBoxField abdomCirc = form.fields[43] as PdfTextBoxField;
      PdfTextBoxField weightAve = form.fields[44] as PdfTextBoxField;
      abdomCirc.text = firstWaist;
      weightAve.text = bf.weight;
    }

    PdfTextBoxField preparedName = form.fields[29] as PdfTextBoxField;
    PdfTextBoxField preparedRank = form.fields[28] as PdfTextBoxField;
    PdfTextBoxField preparedDate = form.fields[25] as PdfTextBoxField;
    PdfTextBoxField approvedName = form.fields[30] as PdfTextBoxField;
    PdfTextBoxField approvedRank = form.fields[26] as PdfTextBoxField;
    PdfTextBoxField approvedDate = form.fields[27] as PdfTextBoxField;
    preparedName.text = preparedBy;
    preparedDate.text = bf.date!;
    preparedRank.text = preparedByGrade;
    approvedName.text = approvedBy;
    approvedRank.text = approvedByGrade;
    approvedDate.text = bf.date!;

    PdfTextBoxField preparedName2 = form.fields[52] as PdfTextBoxField;
    PdfTextBoxField preparedRank2 = form.fields[51] as PdfTextBoxField;
    PdfTextBoxField preparedDate2 = form.fields[49] as PdfTextBoxField;
    PdfTextBoxField approvedName2 = form.fields[53] as PdfTextBoxField;
    PdfTextBoxField approvedRank2 = form.fields[50] as PdfTextBoxField;
    PdfTextBoxField approvedDate2 = form.fields[61] as PdfTextBoxField;
    preparedName2.text = preparedBy;
    preparedDate2.text = bf.date!;
    preparedRank2.text = preparedByGrade;
    approvedName2.text = approvedBy;
    approvedRank2.text = approvedByGrade;
    approvedDate2.text = bf.date!;

    try {
      final dir = await getTemporaryDirectory();
      final fileName = '${dir.path}/${bf.rank}_${bf.name}_5501.pdf';
      var file = File(fileName);
      file.writeAsBytesSync(document.saveSync());
      FToast toast = FToast();
      toast.context = context;

      toast.showToast(
        toastDuration: Duration(seconds: 5),
        child: MyToast(
          contents: [
            Expanded(
              flex: 3,
              child: Text(
                'DA Form 5501 has been downloaded to a temporary folder. Open and save to a permanent folder.',
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
    } on Exception catch (e) {
      print('Error: $e');
    }

    document.dispose();
  }
}
