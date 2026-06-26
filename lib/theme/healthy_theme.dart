import 'package:flutter/material.dart';

final ThemeData healthyTheme = ThemeData(
  useMaterial3: true,

  colorScheme: ColorScheme(
    brightness: Brightness.light,

    primary: const Color(0xFF2E7D32),   
    onPrimary: Colors.white,

    secondary: const Color(0xFF4FC3F7),
    onSecondary: Colors.white,

    error: const Color(0xFFD32F2F),
    onError: Colors.white,

    surface: const Color(0xFFF8FFF8),     
    onSurface: const Color(0xFF1B1B1B),
  ),

  scaffoldBackgroundColor: const Color(0xFFF5FAF5),

  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Color(0xFFF5FAF5),
    foregroundColor: Color(0xFF2E7D32),
    elevation: 0,
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2E7D32),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 14,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFF2E7D32),
    
  )
);

final ThemeData healthyDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFF66BB6A),
    onPrimary: Colors.black,

    secondary: Color(0xFF4FC3F7),
    onSecondary: Colors.black,

    error: Color(0xFFEF5350),
    onError: Colors.black,

    surface: Color(0xFF1B1F1B),
    onSurface: Color(0xFFF5F5F5),
  ),

  scaffoldBackgroundColor: const Color(0xFF121212),

  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Color(0xFF121212),
    foregroundColor: Color(0xFF66BB6A),
    elevation: 0,
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E1E),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF66BB6A),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 14,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF252525),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF66BB6A),
        width: 2,
      ),
    ),
    hintStyle: const TextStyle(
      color: Colors.white60,
    ),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: Color(0xFF66BB6A),
    unselectedItemColor: Colors.white54,
  ),

  dividerColor: Colors.white12,

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),

  iconTheme: const IconThemeData(
    color: Color(0xFF66BB6A),
  ),
);