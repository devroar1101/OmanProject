import 'package:flutter/material.dart';
import 'package:tenderboard/office/List_circular/screens/circular_form.dart';



class CircularListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Column Layout Example'),
      ),
      body: Column(
        children: [
          // The first widget
          Container(
            height: 100, // Define the height of your first widget
            color: Colors.blue,
            child:CircularForm(),
          ),
          // The empty space
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'Empty Space',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
