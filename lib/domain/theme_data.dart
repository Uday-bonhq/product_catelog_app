import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'theme_data.g.dart'; // Generated code for Hive

@HiveType(typeId: 6) // Unique typeId for CartItem
class ThemeModel {
  @HiveField(0)
  final ThemeMode themeMode; // Product ID

  ThemeModel({
    required this.themeMode,
  });
}
