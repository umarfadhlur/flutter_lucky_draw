import 'package:flutter/material.dart';

class KansaiColors {
  static const Color red = Color(0xFFC21328);
  static const Color blue = Color(0xFF0580B8);
  static const Color white = Color(0xFFE4E4E4);
  static const Color navy = Color(0xFF071E54);
}

MaterialColor createMaterialColor(Color color) {
  Map<int, Color> colorSwatch = {
    50: color.withOpacity(0.1),
    100: color.withOpacity(0.2),
    200: color.withOpacity(0.3),
    300: color.withOpacity(0.4),
    400: color.withOpacity(0.5),
    500: color.withOpacity(0.6),
    600: color.withOpacity(0.7),
    700: color.withOpacity(0.8),
    800: color.withOpacity(0.9),
    900: color.withOpacity(1.0),
  };

  return MaterialColor(color.value, colorSwatch);
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: KansaiColors.blue,
  accentColor: KansaiColors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.black),
    bodyText2: TextStyle(color: Colors.black),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: KansaiColors.blue,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: KansaiColors.blue,
  accentColor: KansaiColors.blue,
  scaffoldBackgroundColor: Colors.grey[900],
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.white),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: KansaiColors.blue,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white),
  ),
);
