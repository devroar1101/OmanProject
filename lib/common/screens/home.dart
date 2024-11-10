import 'package:flutter/material.dart';
import 'package:tenderboard/common/screens/widgets/dashboard.dart';
import 'package:tenderboard/common/screens/widgets/sidebar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _currentWidget = Dashboard(); // Default widget to show

  // Callback function to update the current widget based on the sidebar item clicked
  void _onNavigate(Widget widget) {
    setState(() {
      _currentWidget = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the pop-back icon
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/gstb_logo.png',
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard,
                color: Colors.lightGreenAccent, size: 28.0),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.inbox, color: Colors.teal, size: 28.0),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.outbox,
                color: Colors.lightBlueAccent, size: 28.0),
            onPressed: () {},
          ),
          IconButton(
            icon:
                const Icon(Icons.search, color: Colors.pinkAccent, size: 28.0),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person,
                color: Colors.deepPurpleAccent, size: 28.0),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          CustomSidebar(onNavigate: _onNavigate), // Pass the callback function
          Expanded(child: _currentWidget), // Display the current widget
        ],
      ),
    );
  }
}
