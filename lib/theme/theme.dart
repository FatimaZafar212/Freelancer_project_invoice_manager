import 'package:flutter/material.dart';

// Vibrant Light Palette
const Color primaryColor = Color(0xFF6B48FF); // Vibrant Purple
const Color secondaryColor = Color(0xFFFF7A68); // Soft Coral
const Color surfaceColor = Colors.white;
const Color backgroundColor = Color(0xFFF8F9FE); // Very soft bluish-white
const Color errorColor = Color(0xFFE53935);
const Color textPrimaryColor = Color(0xFF1E1E2C);
const Color textSecondaryColor = Color(0xFF7A7A9D);

// Deep Indigo Dark Palette
const Color darkPrimaryColor = Color(0xFF8B6BFF); // Lighter purple for dark mode contrast
const Color darkSurfaceColor = Color(0xFF1E1E3F); // Elevated Indigo Card
const Color darkBackgroundColor = Color(0xFF13132B); // Deep Indigo Background
const Color darkTextPrimaryColor = Colors.white;
const Color darkTextSecondaryColor = Color(0xFF9E9EBC);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    secondary: secondaryColor,
    surface: surfaceColor,
    error: errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textPrimaryColor,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundColor,
    foregroundColor: textPrimaryColor,
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    color: surfaceColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: primaryColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surfaceColor,
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
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  ),
  dividerTheme: DividerThemeData(
    color: textPrimaryColor.withValues(alpha: 0.05),
    thickness: 1,
  ),
);

final ThemeData appDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: darkPrimaryColor,
    brightness: Brightness.dark,
    primary: darkPrimaryColor,
    secondary: secondaryColor,
    surface: darkSurfaceColor,
    error: const Color(0xFFCF6679),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: darkTextPrimaryColor,
    onError: Colors.black,
  ),
  scaffoldBackgroundColor: darkBackgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: darkBackgroundColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    color: darkSurfaceColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: darkPrimaryColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkSurfaceColor,
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
      borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.white.withValues(alpha: 0.05),
    thickness: 1,
  ),
);
