import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFFAF4),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFFFFAF4),
      onPrimary: Colors.black,
      secondary: Color(0xFFE6CFB4),
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Color(0xFFE6CFB4),
      onSurface: Colors.black,
    ),
    highlightColor: const Color(0xFFFFDEB4),
    splashColor: const Color(0xFFFDF7C3),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 24.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      headlineLarge: TextStyle(
        fontSize: 18.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      headlineSmall: TextStyle(
        fontSize: 14.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 24.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 18.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      labelLarge: TextStyle(
        fontSize: 14.0,
        fontFamily: 'Kanit',
        color: Colors.black,
      ),
      labelMedium: TextStyle(
        fontSize: 12.0,
        fontFamily: 'Kanit',
        color: Colors.black,
      ),
      labelSmall: TextStyle(
        fontSize: 10.0,
        fontFamily: 'Kanit',
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 14.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 12.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 10.0,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ),
  );
}
