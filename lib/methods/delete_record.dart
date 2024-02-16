import 'package:acft_calculator/methods/platform_show_modal_bottom_sheet.dart';
import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:flutter/material.dart';

import '../../widgets/platform_widgets/platform_button.dart';
import '../widgets/button_text.dart';

class DeleteRecord {
  static void deleteRecord({BuildContext? context, Function? onConfirm}) {
    showPlatformModalBottomSheet(
      context: context!,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          right: 8.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 8.0,
        ),
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
        color: getBackgroundColor(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Delete Record',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Are you sure you want to delete this record?'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: ButtonText(text: 'Cancel'),
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: ButtonText(text: 'Yes'),
                    onPressed: onConfirm as void Function(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
