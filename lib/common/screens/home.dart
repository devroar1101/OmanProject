import 'package:flutter/material.dart';
import 'package:tenderboard/common/screens/widgets/dashboard.dart';
import 'package:tenderboard/common/screens/widgets/sidebar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _currentWidget = const Dashboard(); // Default widget to show

  // Callback function to update the current widget based on the sidebar item clicked
  void _onNavigate(Widget widget) {
    setState(() {
      _currentWidget = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 1, // Spread radius
                blurRadius: 5, // Blur radius
                offset: const Offset(0, 3), // Offset in x and y direction
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false, // Removes the pop-back icon
            backgroundColor: Colors.transparent,
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
                icon: const Icon(Icons.dashboard),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.inbox),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.outbox),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
            ],
          ),
        ),
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
