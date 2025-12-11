import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // warna teks
      backgroundColor: Colors.black54, // warna background
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(textStyle: TextStyle(color: Colors.black)),
  ),
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.white60,
    secondary: Colors.white30,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.black54,
    textTheme: ButtonTextTheme.primary,
  ),
  fontFamily: "CaviarDreams",
  // primaryColor: Colors.black,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, // warna teks
      backgroundColor: Colors.white54, // warna background
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(textStyle: TextStyle(color: Colors.white)),
  ),

  buttonTheme: ButtonThemeData(
    buttonColor: Colors.white54,
    textTheme: ButtonTextTheme.primary,
  ),
  // primaryColor: Colors.white,
  colorScheme: ColorScheme.dark(
    surface: Colors.black87,
    primary: Colors.black54,
    secondary: Colors.black45,
  ),

  fontFamily: "CaviarDreams",
);
