import 'package:flutter/material.dart';
import 'package:lat_uas/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData? _themeData;
  ThemeData get themeData => _themeData!;

  String get mode {
    if (_themeData == lightMode) {
      return 'light';
    }
    if (_themeData == darkMode) {
      return 'dark';
    }
    return 'system';
  }

  void setLightMode() {
    _themeData = lightMode;
    notifyListeners();
  }

  void setDarkMode() {
    _themeData = darkMode;
    notifyListeners();
  }

  void setSystemMode() {
    _themeData = null;
    notifyListeners();
  }
}
