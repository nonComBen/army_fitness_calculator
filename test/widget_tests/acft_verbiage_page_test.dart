import 'package:acft_calculator/classes/verbiage.dart';
import 'package:acft_calculator/pages/verbiage_pages/acft_verbiage_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widget_under_test.dart';

void main() {
  setUp(() {});

  group('Test ACFT Verbiage Page', () {
    testWidgets(
      "Test tile function",
      (WidgetTester tester) async {
        await tester
            .pumpWidget(createWidgetUnderTest(widget: AcftVerbiagePage()));
        await tester.pump();
        for (Verbiage verbiage in verbiages) {
          print(verbiage.header);
          await tester.ensureVisible(find.text(verbiage.header));
          await tester.pumpAndSettle();
          expect(
            find.text(verbiage.header, skipOffstage: false),
            findsOneWidget,
          );
          expect(
              find.byWidget(verbiage.body, skipOffstage: false), findsNothing);
          await tester.tap(find.text(verbiage.header, skipOffstage: false));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byWidget(verbiage.body));
          await tester.pumpAndSettle();
          expect(
            find.byWidget(verbiage.body, skipOffstage: false),
            findsOneWidget,
          );
          await tester.ensureVisible(find.text(verbiage.header));
          await tester.pumpAndSettle();
          await tester.tap(find.text(verbiage.header, skipOffstage: false));
          await tester.pump();
        }
      },
    );
  });
}
