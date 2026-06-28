import 'package:flutter/material.dart';

class ThemeSettings {
  static void toggleTheme(BuildContext context, bool isDarkModeEnabled) {
    // Implement theme toggle logic here
    final themeMode = isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light;
    }
}
