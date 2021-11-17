import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      selectedItemColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.lightBlue,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white38,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.white),
      trackColor: MaterialStateProperty.all(Colors.black87),
    ),
  );

  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontSize: 22.0,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: 'Metropolis',
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

  static final appBarLightFlexibleSpace = Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.blue,
          Colors.blue.shade900,
        ],
      ),
    ),
  );

  static final appBarDarkFlexibleSpace = Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.black,
          Colors.grey.shade900,
        ],
      ),
    ),
  );

  static final bottomBarDecorationLight = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.blue.shade900],
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      tileMode: TileMode.clamp,
    ),
  );

  static final bottomBarDecorationDark = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.black, Colors.grey.shade900],
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      stops: const [0.0, 0.8],
      tileMode: TileMode.clamp,
    ),
  );
}
