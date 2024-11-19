import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/screens/login.dart';
import 'package:tenderboard/common/screens/home.dart';
import 'package:tenderboard/common/screens/widgets/scanner.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';

void main() {
  runApp(ProviderScope(child: Scanner()));
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
      home: authState.isAuthenticated ? Home() : const LoginScreen(),
    );
  }
}
