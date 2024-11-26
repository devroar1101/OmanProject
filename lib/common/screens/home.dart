import 'package:flutter/material.dart';
import 'package:tenderboard/common/screens/widgets/app_bar.dart';
import 'package:tenderboard/common/screens/widgets/dashboard.dart';
import 'package:tenderboard/common/screens/widgets/sidebar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _currentWidget = const Dashboard();

  bool documentSearch = false;
  String side = 'Office';

  // Callback function to update the current widget based on the sidebar item clicked
  void _onNavigate(Widget widget, String screenName, String? side) {
    setState(() {
      _currentWidget = widget;
      if (screenName == 'Document Search') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget));
        _currentWidget = const Dashboard();
      }
      if (side != null) {
        this.side = side;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(side: side),
      body: Row(
        children: [
          CustomSidebar(onNavigate: _onNavigate), // Pass the callback function
          Expanded(child: _currentWidget), // Display the current widget
        ],
      ),
    );
  }
}
