import 'package:acft_calculator/pages/verbiage_pages/bodyfat_verbiage_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widget_under_test.dart';

void main() {
  setUp(() {});

  group('Test Bodyfat Verbiage Page', () {
    testWidgets(
      "Test tile function",
      (WidgetTester tester) async {
        await tester
            .pumpWidget(createWidgetUnderTest(widget: BodyfatVerbiagePage()));
        await tester.pump();
        for (Verbiage verbiage in verbiages) {
          print(verbiage.header);
          expect(
            find.text(verbiage.header, skipOffstage: false),
            findsOneWidget,
          );
          expect(find.byWidget(verbiage.body), findsNothing);
          await tester.tap(find.text(verbiage.header, skipOffstage: false));
          await tester.pump();
          expect(
            find.byWidget(verbiage.body, skipOffstage: false),
            findsOneWidget,
          );
          await tester.tap(find.text(verbiage.header, skipOffstage: false));
          await tester.pump();
        }
      },
    );
  });
}
