import 'package:flutter/material.dart';

import '../../widgets/platform_widgets/platform_button.dart';

class DeleteRecord {
  static void deleteRecord({BuildContext? context, Function? onConfirm}) {
    showModalBottomSheet(
      context: context!,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 4),
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          right: 8.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 8.0,
        ),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: Text('Yes'),
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
