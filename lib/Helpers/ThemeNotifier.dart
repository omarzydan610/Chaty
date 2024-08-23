import 'package:chaty/Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;
  ThemeData get themedata => _themeData;

  static const String themePreferenceKey = 'theme_preference';

  ThemeNotifier(this._themeData);

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeData == lightMode) {
      themeData = darkMode;
      prefs.setBool(themePreferenceKey, true); // Save dark mode preference
    } else {
      themeData = lightMode;
      prefs.setBool(themePreferenceKey, false); // Save light mode preference
    }
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool(themePreferenceKey) ?? false;
    _themeData = isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }
}
