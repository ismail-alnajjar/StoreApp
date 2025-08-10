import 'package:flutter/material.dart'; // ضروري

class ThemeController {
  static ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  static void toggleTheme(bool isDark) {
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
