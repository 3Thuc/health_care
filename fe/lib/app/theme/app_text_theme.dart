import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme lightTextTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: primaryText),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: primaryText),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: primaryText),
      bodyMedium: TextStyle(fontSize: 14, color: secondaryText),
      labelMedium: TextStyle(fontSize: 12, color: secondaryText),
    );
  }

  static TextTheme darkTextTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: primaryText),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: primaryText),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: primaryText),
      bodyMedium: TextStyle(fontSize: 14, color: secondaryText),
      labelMedium: TextStyle(fontSize: 12, color: secondaryText),
    );
  }
}
