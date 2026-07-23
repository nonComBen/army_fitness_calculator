import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences_provider.dart';

enum ThemeState { lightTheme, darkTheme }

final themeStateNotifierProvider =
    NotifierProvider<ThemeStateNotifier, ThemeData>(() {
  return ThemeStateNotifier();
});

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey[800],
  dialogBackgroundColor: Colors.grey[700],
  colorScheme: ColorScheme.highContrastDark(
    brightness: Brightness.dark,
    primary: Colors.black87,
    primaryContainer: Colors.black,
    secondary: Colors.grey,
    secondaryContainer: Colors.grey[700],
    background: Colors.black87,
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
    background: Colors.grey[800]!,
    onPrimary: Colors.amber,
    onSecondary: Colors.amber,
    onError: Colors.white,
    error: Colors.red,
  ),
);

class ThemeStateNotifier extends Notifier<ThemeData> {
  ThemeStateNotifier();
  SharedPreferences? _prefs;
  @override
  ThemeData build() {
    _prefs = ref.read(sharedPreferencesProvider);
    _prefs!.getString('brightness') == 'Dark'
        ? state = darkTheme
        : state = lightTheme;
    return state;
  }

  void switchTheme(ThemeState newTheme) {
    print('New Theme: $newTheme');
    if (newTheme == ThemeState.lightTheme) {
      _prefs!.setString('brightness', 'Light');
      state = lightTheme;
    } else {
      _prefs!.setString('brightness', 'Dark');
      state = darkTheme;
    }
  }
}
