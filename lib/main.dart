import 'package:flutter/material.dart';
import 'package:tenderboard/admin/listmaster/screens/listmaster_home.dart';
import 'package:tenderboard/common/screens/home.dart';
import 'package:tenderboard/common/screens/login.dart';
//import 'package:tenderboard/admin/listmasteritem/screens/listmasteritem_home.dart';
// Import the ListMasterItemScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListMaster Item App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
