import 'package:flutter/material.dart';

class AppTheme {
  // Define your color palette
  static const Color primaryColor = Color(0xFFD4B492);
  static const Color secondaryColor = Color(0xFF03DAC5); // Secondary color
  static const Color backgroundColor =
      Color.fromARGB(0, 212, 123, 49); // Light background color
  static const Color darkBackgroundColor =
      Color.fromARGB(255, 250, 249, 249); // Dark background color
  static const Color activeColor =
      Color.fromARGB(255, 6, 163, 129); // Active color for focus and selection
  static const Color buttonColor = Color(0xFFD4B492); // Button color
  static const Color buttonTextColor = Color(0xFF222F47); // Button text color
  static const Color textColor = Colors.black; // Set to black
  static const Color appBarColor = Color(0xFFFFFFFF); // AppBar color
  static const Color cardColor = Color.fromARGB(255, 163, 100, 100);
  static const Color iconColor = Color(0xFF0A1E3D); // Overall icon color
  static const Color borderColor = Color(0xFF95B3A1); // Field border color
  static const Color displayHeaderColor =
      Color(0xFF8EAE9B); // Display detail header color

  // Common elevated button theme
  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return activeColor; // Active color when pressed
        }
        return buttonColor; // Default button color
      }),
      foregroundColor: WidgetStateProperty.all(textColor),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 12),
      ),
    ),
  );

  // Common text theme
  static const TextTheme _textTheme = TextTheme(
    headlineLarge: TextStyle(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: textColor),
    bodyLarge: TextStyle(fontSize: 16.0, color: textColor),
    labelLarge: TextStyle(
        fontSize: 14.0, color: buttonTextColor, fontWeight: FontWeight.bold),
  );

//static const Color iconColor = Color(0xFF0A1E3D); // Overall icon color

// Global IconTheme Data for the entire project
  static const iconTheme = IconThemeData(
    color: iconColor, // Set the global icon color
  );

  // Method to get theme based on brightness
  static ThemeData getTheme({required bool isDarkMode}) {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor:
          isDarkMode ? const Color.fromARGB(255, 178, 180, 180) : backgroundColor,
      colorScheme: ColorScheme(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: isDarkMode ? darkBackgroundColor : backgroundColor,
        error: Colors.red,
        onPrimary: textColor,
        onSecondary: buttonTextColor,
        onSurface: textColor,
        onError: const Color.fromARGB(255, 180, 81, 81),
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      iconTheme: iconTheme,
      elevatedButtonTheme: elevatedButtonTheme, // Use the updated button theme
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(0, 187, 57, 57),
        iconTheme: IconThemeData(color: iconColor),
        titleTextStyle: TextStyle(
          color: buttonTextColor,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardColor: isDarkMode ? darkBackgroundColor : cardColor,
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
    );
  }
}
