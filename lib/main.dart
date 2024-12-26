// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/screens/login.dart';
import 'package:tenderboard/common/screens/home.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';
import 'package:tenderboard/common/utilities/language_mannager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationManager().init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider); // Watch authState
    final selectedLanguage =
        authState.selectedLanguage; // Watch language provider

    return MaterialApp(
      key: ValueKey(selectedLanguage),

      debugShowCheckedModeBanner: false,
      title: LocalizationManager().getTranslation('TenderboardApp'),
      theme: AppTheme.getTheme(isDarkMode: false), // Light theme
      darkTheme: AppTheme.getTheme(isDarkMode: true), // Dark theme
      themeMode: ThemeMode
          .system, // Automatically switch between light/dark based on system setting
      builder: (context, child) {
        return Directionality(
          textDirection:
              selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: authState.isAuthenticated ? const Home() : const LoginScreen(),
    );
  }
}
