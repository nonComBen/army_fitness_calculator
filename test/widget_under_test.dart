import 'package:acft_calculator/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget createWidgetUnderTest(
    {required Widget widget, SharedPreferences? sharedPreferences}) {
  return ProviderScope(
    overrides: [
      // override the previous value with the new object

      if (sharedPreferences != null)
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: MaterialApp(
      title: 'Army Fitness Calculator',
      home: widget,
    ),
  );
}
