import 'package:flutter/material.dart';
import 'package:mobile_programming/shared/constants_shared.dart';

class SharedTheme {
  static ThemeData themeData = ThemeData(
    primaryColor: SharedConstants.primaryColor,
    secondaryHeaderColor: SharedConstants.secondaryColor,
    // visualDensity: VisualDensity.adaptivePlatformDensity,

    // Text Themes
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: SharedConstants.primaryTextColor,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        color: SharedConstants.secondaryTextColor,
      ),
      displaySmall: TextStyle(
        fontSize: 18,
        color: SharedConstants.secondaryTextColor,
      ),
    ),
  );
}
