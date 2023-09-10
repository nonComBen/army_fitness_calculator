// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_widget_under_test.dart';
import '../widget_under_test.dart';

void main() {
  testWidgets('Test ACFT Calculator', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(createWidgetUnderTest(
        widget: androidHomeWidgetUnderTest(0), sharedPreferences: prefs));
    await tester.pump();

    expect(find.byIcon(Icons.fitness_center), findsWidgets);
  });
}
