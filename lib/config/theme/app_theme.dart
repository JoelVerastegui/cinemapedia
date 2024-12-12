import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkActive;
  AppTheme({
    this.isDarkActive = false
  });

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: isDarkActive ? Brightness.dark : Brightness.light,
    colorSchemeSeed: const Color.fromARGB(0, 39, 40, 34)
  );

  AppTheme copyWith({
    bool isDarkActive = false
  }) => AppTheme(
    isDarkActive: isDarkActive
  );
}