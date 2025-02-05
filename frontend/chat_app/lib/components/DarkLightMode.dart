import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  fontFamily: 'SF Pro', // Ensure SF Pro is added to pubspec.yaml
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 34, height: 1.2),
    displaySmall: TextStyle(fontSize: 40),
    bodyMedium: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
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
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
  ),
);

final darkTheme = ThemeData(
  fontFamily: 'SF Pro',
  brightness: Brightness.dark,
  primaryColor: Color.fromARGB(255, 140, 145, 144),
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 34, height: 1.2),
    displaySmall: TextStyle(fontSize: 40),
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    hintStyle: TextStyle(color: Colors.grey),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 88, 88, 88),
      foregroundColor: Colors.black,
    ),
  ),
);
