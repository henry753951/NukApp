import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    highlightColor: Colors.black,
    splashColor: Colors.transparent,
    backgroundColor: Colors.white,
    primaryColor: Color(0xFF5F3EEF),
    primaryColorDark: Color(0xFF160755),
    primaryColorLight: Colors.white,
    hintColor: Colors.grey[400],
    scaffoldBackgroundColor: Color(0xFFF2F6FF),
    colorScheme: ColorScheme.light(),
    appBarTheme: AppBarTheme(),
  );

  static ThemeData darkTheme = ThemeData(
    highlightColor: Colors.white,
    splashColor: Colors.transparent,
    backgroundColor: Color(0xFF2A2631),
    primaryColor: Color(0xFF5F3EEF),
    primaryColorDark: Color(0xFFEDE9FD),
    primaryColorLight: Color(0xFF353535),
    scaffoldBackgroundColor: Colors.black,
    hintColor: Colors.grey,
    colorScheme: ColorScheme.dark(),
    appBarTheme: AppBarTheme(),
  );
}
