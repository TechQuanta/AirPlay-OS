import 'package:flutter/material.dart';

class AppTheme {
  // --- Common Colors ---
  static const Color errorRed = Color(0xFFB00020);

  // --- CUSTOM COLOR PALETTE ---
  // 1. Dark Base/Surface Color
  static const Color customDarkGray = Color(0xFF292828); 
  // 2. White Color for high contrast text/on-colors
  static const Color contentWhite = Color(0xFFFFFFFF);
  // 3. Dark Theme Accent/Primary Color (Vibrant Blue)
  static const Color darkAccentBlue = Color(0xFF32B2FC); 
  // 4. Light Theme Primary Color (Purple/Indigo)
  static const Color lightPrimaryPurple = Color(0xFF7532FC); 
  // 5. Light Theme Secondary/Accent Color (Light Yellow/Green)
  static const Color lightAccentYellow = Color(0xFFEFFF9E);

  // --- Light Theme ---
  static final ThemeData lightTheme = ThemeData(
    // Base brightness setting
    brightness: Brightness.light,
    
    // Primary Color Scheme for light mode
    colorScheme: ColorScheme.fromSeed(
      seedColor: lightPrimaryPurple,
      brightness: Brightness.light,
      primary: lightPrimaryPurple, // Primary color: Purple/Indigo (#7532fc)
      secondary: lightAccentYellow, // Secondary color: Light Yellow/Green (#efff9e)
      error: errorRed,
      background: contentWhite, // Background: White (#ffffff)
      onBackground: Colors.black87,
      onPrimary: contentWhite,
    ),
    
    // Scaffolds and AppBars
    scaffoldBackgroundColor: contentWhite,
    appBarTheme: AppBarTheme(
      color: lightPrimaryPurple, // Purple AppBar
      foregroundColor: contentWhite,
      elevation: 0,
    ),

    // Text Theme
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.black),
    ),
  );

  // --- Dark Theme (UPDATED FOR CUSTOM GRAY MIX) ---
  static final ThemeData darkTheme = ThemeData(
    // Base brightness setting
    brightness: Brightness.dark,
    
    // Primary Color Scheme for dark mode
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkAccentBlue,
      brightness: Brightness.dark,
      primary: darkAccentBlue, // Primary: Vibrant Blue (#32b2fc) - for indicators/beat
      secondary: lightPrimaryPurple, // Secondary: Purple/Indigo
      error: errorRed,
      background: customDarkGray, // Background: Dark Gray (#292828)
      surface: customDarkGray, // Surface: Dark Gray (#292828)
      onBackground: contentWhite, // Text color: White (#ffffff)
      onSurface: contentWhite, // Text color: White (#ffffff)
      onPrimary: contentWhite,
    ),
    
    // Scaffolds and AppBars
    scaffoldBackgroundColor: customDarkGray, // Deepest base color
    appBarTheme: AppBarTheme(
      color: customDarkGray, // Unified Dark Gray for app bar
      foregroundColor: contentWhite,
      elevation: 0,
      iconTheme: const IconThemeData(color: darkAccentBlue),
    ),

    // Text Theme
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: contentWhite),
      bodyMedium: TextStyle(color: Color(0xBBFFFFFF)), // Slightly translucent white
      titleLarge: TextStyle(color: contentWhite),
    ),
  );
}
