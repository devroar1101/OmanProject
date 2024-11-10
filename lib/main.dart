import 'package:flutter/material.dart';
import 'package:tenderboard/office/document_search/screens/document_search_home.dart';
//import 'package:tenderboard/admin/listmaster/screens/listmaster_home.dart';
//import 'package:tenderboard/admin/listmasteritem/screens/listmasteritem_home.dart';
//import 'package:tenderboard/office/inbox/screens/inbox_home.dart';
//import 'package:tenderboard/office/outbox/screens/outbox_screen.dart';
// Import the ListMasterItemScreen

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DocumentSearchHome() // Your main screen
    );
  }
}
