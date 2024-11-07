import 'package:flutter/material.dart';

class ListMasterSearchForm extends StatefulWidget {
  //final Function(String nameEnglish, String nameArabic) onSearch;

  ListMasterSearchForm({super.key});

  @override
  _ListMasterSearchFormState createState() => _ListMasterSearchFormState();
}

class _ListMasterSearchFormState extends State<ListMasterSearchForm> {
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
  }

  void _handleSearch() {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;

    //widget.onSearch(nameEnglish, nameArabic);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Name English Text Field
            Expanded(
              child: TextField(
                controller: _nameEnglishController,
                decoration: InputDecoration(
                  labelText: 'Name English',
                  //prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 8.0), // Spacing between fields
            
            // Name Arabic Text Field
            Expanded(
              child: TextField(
                controller: _nameArabicController,
                decoration: InputDecoration(
                  labelText: 'Name Arabic',
                  //prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 8.0), // Spacing between fields and icons
            
            // Search Icon Button
            Card(
              color: const Color.fromARGB(255, 238, 240, 241),
              shape: CircleBorder(),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: _handleSearch,
                tooltip: 'Search',
              ),
            ),
            
            // Reset Icon Button
            Card(
              color: const Color.fromARGB(255, 240, 234, 235),
              shape: CircleBorder(),
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _resetFields,
                tooltip: 'Reset',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
