// lib/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Define your color palette
  static const Color primaryColor = Color.fromARGB(255, 255, 255, 255);
  static const Color secondaryColor = Color(0xFF03DAC5); // Secondary color
  static const Color backgroundColor = Color(0x00f8f7f3);  // Light background color
  static const Color darkBackgroundColor = Color(0xFF303030); // Dark background color
  static const Color buttonColor = Color(0xd4b492); // Button color
  static const Color buttonTextColor = Color(0x222f47); // Button text color
  static const Color textColor = Color(0x000000);
  static const Color appBarColor = Color.fromARGB(255, 75, 81, 88); // AppBar color
  static const Color cardColor = Color.fromARGB(255, 163, 100, 100);
  static const Color icon = Color(0x131e3d); // Color for cards

 static final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.teal, // Button color
    foregroundColor: const Color.fromARGB(255, 10, 10, 10), // Text/icon color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12),
  ),
);

static ThemeData get themeData => ThemeData(
  elevatedButtonTheme: elevatedButtonTheme,  // Ensure this is applied globally
  primaryColor: Colors.teal,
  // You can add other theme properties as needed
);


  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 255, 255, 255),
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: Color(0xd0ddd6),  // Primary color
      secondary: secondaryColor,  // Secondary color
      background: backgroundColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: buttonColor, // Default button color
      textTheme: ButtonTextTheme.primary, // Button text color (white)
    ),
    
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      color: appBarColor, // AppBar background color
      iconTheme: IconThemeData(color: buttonTextColor), // AppBar icon color
      titleTextStyle: TextStyle(
        color: buttonTextColor, // AppBar title text color
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: cardColor, // Color for cards
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color.fromARGB(0, 248, 247, 243),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor, // Primary color
      secondary: secondaryColor, // Secondary color
      background: darkBackgroundColor, // Dark background color
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: buttonColor, // Default button color for dark theme
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // Elevated button color
        foregroundColor: const Color.fromARGB(255, 199, 77, 77), // Elevated button text color
      ),
    ),
    textTheme: _textTheme.apply(bodyColor: const Color.fromARGB(255, 0, 0, 0)),
    appBarTheme: const AppBarTheme(
      color: appBarColor, // AppBar color for dark theme
      iconTheme: IconThemeData(color: Color.fromARGB(255, 95, 71, 71)),
      titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 48, 45, 45),
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: darkBackgroundColor, // Dark background color for cards
  );

  // Text Styles
  static const TextTheme _textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: textColor),
    bodyLarge: TextStyle(fontSize: 16.0, color: textColor),
    labelLarge: TextStyle(fontSize: 14.0, color: buttonTextColor, fontWeight: FontWeight.bold),
    // Define other text styles as needed
  );
}
