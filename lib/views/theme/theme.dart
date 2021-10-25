import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
  );

  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontSize: 22.0,
  );

  static const TextStyle waitingTime = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontSize: 16.0,
  );

  static const TextStyle waitingTimeSecondary = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    fontSize: 16.0,
  );

  static const TextStyle errorMessage = TextStyle(
    fontSize: 18.0,
  );

  static const TextStyle lineNumber = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
}
