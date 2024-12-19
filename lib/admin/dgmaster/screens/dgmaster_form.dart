import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class DgMasterSearchForm extends StatefulWidget {
  const DgMasterSearchForm({super.key, required this.onSearch});

  final Function(String, String, String) onSearch;

  @override
  _DgMasterSearchFormState createState() => _DgMasterSearchFormState();
}

class _DgMasterSearchFormState extends State<DgMasterSearchForm> {
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
    _codeController.clear();
    widget.onSearch('', '', '');
  }

  void _handleSearch() {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;
    String code = _codeController.text;

    widget.onSearch(nameArabic, nameEnglish, code);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, 
      
      children: [
        Expanded(
          child: Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
           
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                children: [
                  // Code Text Field
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0), // Spacing between fields

                  // Name English Text Field
                  Expanded(
                    child: TextField(
                      controller: _nameEnglishController,
                      decoration: InputDecoration(
                        labelText: 'Name English',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0), // Spacing between fields

                  // Name Arabic Text Field
                  Expanded(
                    child: TextField(
                      controller: _nameArabicController,
                      decoration: InputDecoration(
                        labelText: 'Name Arabic',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0), // Spacing between fields and icons

                  // Search Icon Button
                  Card(
                    color: const Color.fromARGB(255, 238, 240, 241),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _handleSearch,
                      tooltip: 'Search',
                    ),
                  ),

                  // Reset Icon Button
                  Card(
                    color: const Color.fromARGB(255, 240, 234, 235),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _resetFields,
                      tooltip: 'Reset',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
