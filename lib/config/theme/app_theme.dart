import 'package:flutter/material.dart';

class AppTheme {
  AppTheme();

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: const Color(0xFF231345)
  );
}