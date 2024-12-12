import 'package:flutter/material.dart';

class AppTheme {
  AppTheme();

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: const Color.fromARGB(255, 73, 0, 230)
  );
}