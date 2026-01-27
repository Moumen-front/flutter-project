import 'package:flutter/material.dart';

abstract class Mainthemes {

  static final  ThemeData greenBackgroundTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 34, 75, 68),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 34, 75, 68),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: const Color.fromARGB(255, 34, 75, 68),
      onPrimary:  Colors.white,
      secondary: Colors.white,
      onSecondary: const Color.fromARGB(255, 34, 75, 68),
      error: Colors.pink,
      onError: Colors.red,
      surface: Colors.greenAccent,
      onSurface: Colors.white,
    ),
  );

  static final ThemeData whiteBackgroundTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color.fromARGB(255, 34, 75, 68),
      elevation: 0,
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.white,
      onPrimary:  Color.fromARGB(255, 34, 75, 68),
      secondary: const Color.fromARGB(255, 34, 75, 68),
      onSecondary: Colors.white,
      error: Colors.pink,
      onError: Colors.red,
      surface: Colors.white30,
      onSurface: Colors.greenAccent,
    ),
  );
}