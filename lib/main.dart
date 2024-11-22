import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/screens/login.dart';
import 'package:tenderboard/common/screens/home.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final selectedLanguage = authState.selectedLanguage;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tenderboard App',
      theme: AppTheme.getTheme(isDarkMode: false), // Light theme
      darkTheme: AppTheme.getTheme(isDarkMode: true), // Dark theme
      themeMode: ThemeMode
          .system, // Automatically switch between light/dark based on system setting
      builder: (context, child) {
        // Apply directionality based on selected language (Arabic or English)
        return Directionality(
          textDirection: selectedLanguage == 'Arabic'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
      // If authenticated, go to the Home Screen; otherwise, stay on the Login Screen
      home: authState.isAuthenticated ? const Home() : const LoginScreen(),
    );
  }
}
