import 'package:flutter/material.dart';

class ThemeManager {
  // The global variable that holds the current state (Light or Dark)
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  static void toggleTheme(bool isDark) {
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}