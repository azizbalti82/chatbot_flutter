import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFFB6E00),
      brightness: Brightness.light,
    ),
    cardColor: Color(0xFFF6E9DB),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
    ),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor:  Color(0xFF351C01),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Colors.black,
    cardColor:  Color(0xFF7C705D).withOpacity(0.1),
    primaryColor: Color(0xFF301900),
    appBarTheme: AppBarTheme(
      color: Colors.black,
    ),
    useMaterial3: true,
  );
}
