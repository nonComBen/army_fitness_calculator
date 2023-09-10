import 'package:acft_calculator/constants/mdl_setup_table.dart';
import 'package:acft_calculator/pages/mdl_setup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widget_under_test.dart';

void main() {
  group('Test MDL Setup Page', () {
    testWidgets(
      "Test all tiles load",
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(widget: MdlSetupPage()));
        await tester.pump();
        for (List<dynamic> list in mdlSetupTable) {
          print(list[0]);
          await tester.ensureVisible(find.text(list[0]));
          await tester.pumpAndSettle();
          expect(find.text(list[0], skipOffstage: false), findsOneWidget);
          expect(
            find.image(
              AssetImage('assets/mdl_images/${list[1]}.png'),
              skipOffstage: false,
            ),
            findsOneWidget,
          );
        }
      },
    );
  });
}
