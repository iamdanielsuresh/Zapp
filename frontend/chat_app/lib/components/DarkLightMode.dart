import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    hintStyle: TextStyle(color: Colors.grey),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Button background for light theme
      foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Icon or text color for light theme
    ),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 140, 145, 144),
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    hintStyle: TextStyle(color: Colors.grey),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 88, 88, 88), // Button background for dark theme
      foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Icon or text color for dark theme
    ),
  ),
);
