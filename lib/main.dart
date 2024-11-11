import 'package:flutter/material.dart';
import 'package:tenderboard/common/screens/login.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListMaster Item App',
      theme: AppTheme.themeData,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: const LoginScreen(),
    );
  }
}
