import 'package:flutter/material.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';

class DecisionForm extends StatefulWidget {
  const DecisionForm({super.key, required this.onSearch});
  final Function (String, String, String, ) onSearch;

  @override
  _DecisionFormState createState() => _DecisionFormState();
}

class _DecisionFormState extends State<DecisionForm> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _documentType; // Default to null to avoid mismatch errors
  String _sortOrder = 'Descending'; // Default to a valid option

  void _resetFields() {
    _numberController.clear();
    _subjectController.clear();
    _dateController.clear();
    setState(() {
      _documentType = null; // Reset to null
      _sortOrder = 'Descending';
    });
  }

  void _handleSearch() {
    String number = _numberController.text;
    String subject = _subjectController.text;
    String date = _dateController.text;

    // Implement search logic here
    print('Search: Number=$number, Subject=$subject, Date=$date, DocumentType=$_documentType, SortOrder=$_sortOrder');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                children: [
                  // Number Field
                  Expanded(
                    child: TextField(
                      controller: _numberController,
                      decoration: InputDecoration(
                        labelText: getTranslation('Number'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),

                  // Subject Field
                  Expanded(
                    child: TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        labelText: getTranslation('Subject'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),

                  // Date Field
                  Expanded(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: getTranslation('Date'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),

                  // Document Type Dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _documentType,
                      decoration: InputDecoration(
                        labelText: getTranslation('DocumentType'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      items: ['Type1', 'Type2', 'Type3']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _documentType = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),

                  // Sort Order Dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sortOrder,
                      decoration: InputDecoration(
                        labelText: getTranslation('OrderBy'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      items: ['Ascending', 'Descending']
                          .map((order) => DropdownMenuItem(
                                value: order,
                                child: Text(order),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _sortOrder = value ?? 'Descending';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),

                  // Search Button
                  Card(
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: ColorPicker.formIconColor,
                      ),
                      onPressed: _handleSearch,
                      tooltip: getTranslation('Search'),
                    ),
                  ),

                  // Reset Button
                  Card(
                    color: const Color.fromARGB(255, 240, 234, 235),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: ColorPicker.formIconColor,
                      ),
                      onPressed: _resetFields,
                      tooltip: getTranslation('Reset'),
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
