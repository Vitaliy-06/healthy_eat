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