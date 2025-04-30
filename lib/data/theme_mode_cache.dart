import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class ThemeModeCache {
  static const String _boxName = 'themeBox';
  static const String _key = 'isDarkMode';

  // Initialize Hive box for theme
  static Future<void> initialize() async {
    await Hive.openBox(_boxName);
  }

  // Save the theme mode
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, mode == ThemeMode.dark);
  }

  // Load the theme mode
  static Future<ThemeMode> loadThemeMode() async {
    final box = await Hive.openBox(_boxName);
    final isDark = box.get(_key, defaultValue: false);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
