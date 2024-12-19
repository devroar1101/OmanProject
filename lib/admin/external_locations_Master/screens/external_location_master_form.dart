import 'package:flutter/material.dart';

class ExternalLocationMasterSearchForm extends StatefulWidget {
  const ExternalLocationMasterSearchForm({super.key, required this.onSearch});

  final Function(String, String) onSearch;

  @override
  _ExternalLocationMasterSearchFormState createState() =>
      _ExternalLocationMasterSearchFormState();
}

class _ExternalLocationMasterSearchFormState
    extends State<ExternalLocationMasterSearchForm> {
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _selectedType; // Variable to store selected dropdown value

  final List<String> _typeOptions = [
    'Government',
    'Others',
  ]; // Example options for the dropdown

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
    _codeController.clear();
    setState(() {
      _selectedType = null; // Reset the dropdown
    });
    widget.onSearch('', '');
  }

  void _handleSearch() {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;
    String code = _codeController.text;
    String? type = _selectedType;
    widget.onSearch(nameArabic, nameEnglish);

    // Perform search logic with the collected values
    print(
        'Code: $code, Name English: $nameEnglish, Name Arabic: $nameArabic, Type: $type');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                // Code Text Field
                // Expanded(
                //   child: TextField(
                //     controller: _codeController,
                //     decoration: InputDecoration(
                //       labelText: 'Code',
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 8.0), // Spacing between fields

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
                const SizedBox(width: 8.0), // Spacing between fields
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: _typeOptions.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                    width: 8.0), // Spacing between dropdown and buttons

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
          ],
        ),
      ),
    );
  }
}
