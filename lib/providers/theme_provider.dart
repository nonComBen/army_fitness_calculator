import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './shared_preferences_provider.dart';

final themeStateNotifierProvider =
    StateNotifierProvider<ThemeStateNotifier, ThemeData>(
  (ref) => ThemeStateNotifier(
    ref.read(sharedPreferencesProvider),
  ),
);

enum ThemeState { lightTheme, darkTheme }

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey[800],
  dialogBackgroundColor: Colors.grey[700],
  colorScheme: ColorScheme.highContrastDark(
    brightness: Brightness.dark,
    primary: Colors.black87,
    primaryContainer: Colors.black,
    secondary: Colors.grey,
    secondaryContainer: Colors.grey[700],
    background: Colors.black45,
    onPrimary: Colors.yellow,
    onSecondary: Colors.yellow,
    onError: Colors.white,
    error: Colors.red,
  ),
);
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey[300],
  dialogBackgroundColor: Colors.grey[400],
  bottomNavigationBarTheme:
      BottomNavigationBarThemeData(backgroundColor: Colors.grey),
  colorScheme: ColorScheme.highContrastLight(
    brightness: Brightness.light,
    primary: Colors.black87,
    primaryContainer: Colors.black,
    secondary: Colors.grey,
    secondaryContainer: Colors.grey[700],
    background: Colors.black45,
    onPrimary: Colors.amber,
    onSecondary: Colors.amber,
    onError: Colors.white,
    error: Colors.red,
  ),
);

class ThemeStateNotifier extends StateNotifier<ThemeData> {
  ThemeStateNotifier(this.prefs)
      : super(prefs.getString('brightness') == null
            ? lightTheme
            : prefs.getString('brightness') == 'Light'
                ? lightTheme
                : darkTheme);
  final SharedPreferences prefs;

  void switchTheme(ThemeState newTheme) {
    print('New Theme: $newTheme');
    if (newTheme == ThemeState.lightTheme) {
      prefs.setString('brightness', 'Light');
      state = lightTheme;
    } else {
      prefs.setString('brightness', 'Dark');
      state = darkTheme;
    }
  }
}
