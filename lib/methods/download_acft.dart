import 'dart:io';

import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:acft_calculator/widgets/platform_widgets/platform_text_button.dart';
import 'package:acft_calculator/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../sqlite/acft.dart';

class DownloadAcft {
  static Future<void> downloadPdf({
    BuildContext? context,
    required Acft acft,
    required String unitLoc,
    required String mos,
    required String oic,
    required String oicGrade,
    String bmiDate = '',
    String height = '',
    String weight = '',
    bool? bmiPass,
    String bf = '',
    bool? bfPass,
    bool? altPass,
  }) async {
    late PdfDocument document;
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

    PdfTextBoxField name = form.fields[0] as PdfTextBoxField;
    PdfTextBoxField unit = form.fields[29] as PdfTextBoxField;
    name.text = acft.name!;
    unit.text = unitLoc;
    PdfCheckBoxField female = form.fields[6] as PdfCheckBoxField;
    PdfCheckBoxField male = form.fields[5] as PdfCheckBoxField;
    PdfCheckBoxField bmiGo = form.fields[7] as PdfCheckBoxField;
    PdfCheckBoxField bmiNoGo = form.fields[15] as PdfCheckBoxField;
    PdfCheckBoxField bfGo = form.fields[8] as PdfCheckBoxField;
    PdfCheckBoxField bfNoGo = form.fields[9] as PdfCheckBoxField;
    PdfCheckBoxField mdlFirst = form.fields[12] as PdfCheckBoxField;
    PdfCheckBoxField sptFirst = form.fields[11] as PdfCheckBoxField;
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
    PdfTextBoxField heightField = form.fields[10] as PdfTextBoxField;
    PdfTextBoxField weightField = form.fields[48] as PdfTextBoxField;
    PdfTextBoxField bfField = form.fields[49] as PdfTextBoxField;
    PdfTextBoxField date = form.fields[1] as PdfTextBoxField;
    PdfTextBoxField mosField = form.fields[2] as PdfTextBoxField;
    PdfTextBoxField rank = form.fields[3] as PdfTextBoxField;
    PdfTextBoxField age = form.fields[4] as PdfTextBoxField;
    PdfTextBoxField mdlRaw1 = form.fields[30] as PdfTextBoxField;
    PdfTextBoxField mdlRaw2 = form.fields[31] as PdfTextBoxField;
    PdfTextBoxField mdlScore = form.fields[34] as PdfTextBoxField;
    PdfTextBoxField sptRaw1 = form.fields[33] as PdfTextBoxField;
    PdfTextBoxField sptRaw2 = form.fields[32] as PdfTextBoxField;
    PdfTextBoxField sptScore = form.fields[35] as PdfTextBoxField;
    PdfTextBoxField hrpRaw = form.fields[36] as PdfTextBoxField;
    PdfTextBoxField hrpScore = form.fields[37] as PdfTextBoxField;
    PdfTextBoxField sdcRaw = form.fields[39] as PdfTextBoxField;
    PdfTextBoxField sdcScore = form.fields[38] as PdfTextBoxField;
    PdfTextBoxField plkRaw = form.fields[40] as PdfTextBoxField;
    PdfTextBoxField plkScore = form.fields[41] as PdfTextBoxField;
    // bmiDateField.text = bmiDate;
    heightField.text = height;
    weightField.text = weight;
    bfField.text = bf;
    date.text = acft.date!;
    mosField.text = mos;
    rank.text = acft.rank!;
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
      PdfTextBoxField runRaw = form.fields[43] as PdfTextBoxField;
      PdfTextBoxField runScore = form.fields[42] as PdfTextBoxField;
      runScore.text = acft.runScore;
      runRaw.text = acft.runRaw;
    } else {
      PdfTextBoxField runEvent = form.fields[44] as PdfTextBoxField;
      runEvent.text = acft.runEvent == 'Row'
          ? '5K ROW'
          : acft.runEvent == 'Swim'
              ? '1K SWIM'
              : acft.runEvent == 'Bike'
                  ? '12K BIKE'
                  : '2.5MI WALK';
      PdfTextBoxField runRaw = form.fields[46] as PdfTextBoxField;
      PdfTextBoxField runScore = form.fields[45] as PdfTextBoxField;
      runScore.text = acft.runScore;
      runRaw.text = acft.runRaw;
      PdfCheckBoxField altGo = form.fields[18] as PdfCheckBoxField;
      PdfCheckBoxField altNoGo = form.fields[19] as PdfCheckBoxField;
      altGo.isChecked = altPass!;
      altNoGo.isChecked = !altPass;
    }
    PdfCheckBoxField go = form.fields[17] as PdfCheckBoxField;
    PdfCheckBoxField noGo = form.fields[16] as PdfCheckBoxField;
    go.isChecked = acft.pass == 1;
    noGo.isChecked = acft.pass == 0;
    PdfTextBoxField smSigDate = form.fields[47] as PdfTextBoxField;
    PdfTextBoxField total = form.fields[52] as PdfTextBoxField;
    PdfTextBoxField oicField = form.fields[50] as PdfTextBoxField;
    PdfTextBoxField oicGradeField = form.fields[51] as PdfTextBoxField;
    PdfTextBoxField oicSigDate = form.fields[53] as PdfTextBoxField;
    smSigDate.text = acft.date!;
    total.text = acft.total;
    oicField.text = oic;
    oicGradeField.text = oicGrade;
    oicSigDate.text = acft.date!;

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
        FToast toast = FToast();
        toast.context = context;

        toast.showToast(
          toastDuration: Duration(seconds: 5),
          child: MyToast(contents: [
            Expanded(
              flex: 3,
              child: Text(
                'DA Form 705 has been downloaded to a temporary folder. Open and save to a permanent foldier.',
                style: TextStyle(
                  color: getOnPrimaryColor(context!),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: PlatformTextButton(
                child: Text(
                  'Open',
                  style: TextStyle(
                    color: getOnPrimaryColor(context),
                  ),
                ),
                onPressed: () => OpenFile.open(fileName),
              ),
            ),
          ]),
        );
      } on Exception catch (e) {
        print('Error: $e');
      }
    }
    document.dispose();
  }
}
