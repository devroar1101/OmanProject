import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define your color palette based on the eTendering website
  static const Color primaryColor = Color(0xFF004F95); // Blue
  static const Color secondaryColor = Color(0xFF004F95); // Same as primary
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light gray
  static const Color darkBackgroundColor = Color(0xFF2C3E50); // Dark blue-gray
  static const Color activeColor = Color.fromARGB(255, 252, 174, 30); // Green
  static const Color buttonColor =
      Color.fromARGB(255, 212, 180, 146); // Bright button color
  static const Color buttonTextColor =
      Color.fromARGB(255, 33, 37, 41); // Text color on button (blackish)
  static const Color textColor =
      Color.fromARGB(255, 33, 37, 41); // Black text color
  static const Color appBarColor = Color(0xFF004F95); // Matches primary color
  static const Color cardColor = Color(0xFFFFFFFF); // White for cards
  static const Color iconColor =
      Color.fromARGB(255, 237, 240, 241); // Consistent icon color
  static const Color borderColor = Color(0xFFCCCCCC); // Light gray for borders
  static const Color displayHeaderColor =
      Color.fromARGB(255, 142, 174, 155); // Same as primary
  static const Color dialogColor = Color.fromARGB(255, 237, 238, 240);
  // Common text theme using GoogleFonts for Kufam
  static final TextTheme _textTheme = TextTheme(
    headlineLarge: GoogleFonts.kufam(
      textStyle: const TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    ),
    bodyLarge: GoogleFonts.kufam(
      textStyle: const TextStyle(
        fontSize: 16.0,
        color: textColor,
      ),
    ),
    labelLarge: GoogleFonts.kufam(
      textStyle: const TextStyle(
        fontSize: 14.0,
        color: buttonTextColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // Global IconTheme Data for the entire project
  static const iconTheme = IconThemeData(
    color: iconColor, // Set the global icon color
  );

  // Method to get theme based on brightness
  static ThemeData getTheme({required bool isDarkMode}) {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0x00f8f9fa),
      colorScheme: ColorScheme(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: isDarkMode ? darkBackgroundColor : backgroundColor,
        error: Colors.red,
        onPrimary: buttonTextColor,
        onSecondary: buttonTextColor,
        onSurface: textColor,
        onError: Colors.white,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      iconTheme: iconTheme,
      textTheme: _textTheme, // Apply text theme with Kufam font
      appBarTheme: const AppBarTheme(
        color: appBarColor,
        iconTheme: IconThemeData(color: iconColor),
        titleTextStyle: TextStyle(
          color: buttonTextColor,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: dialogColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(textColor),
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        labelStyle: TextStyle(color: textColor),
        hintStyle: TextStyle(color: textColor),
      ),
      cardTheme: CardTheme(
        color: isDarkMode
            ? const Color.fromARGB(238, 238, 238, 255)
            : cardColor, // Light or dark mode
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Button background color
          foregroundColor: buttonTextColor, // Button text color
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
