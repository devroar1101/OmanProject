import 'package:flutter/material.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';

class MeetingMinutesSearchForm extends StatefulWidget {
  const MeetingMinutesSearchForm({super.key, required this.onSearch});
  final Function(String, String, String, String, String) onSearch;

  @override
  _MeetingMinutesSearchFormState createState() => _MeetingMinutesSearchFormState();
}

class _MeetingMinutesSearchFormState extends State<MeetingMinutesSearchForm> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _meetingNumberController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _classificationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _resetFields() {
    _subjectController.clear();
    _meetingNumberController.clear();
    _priorityController.clear();
    _classificationController.clear();
    _dateController.clear();
    widget.onSearch('', '', '', '', '',);
  }

  void _handleSearch() {
    String subject = _subjectController.text;
    String meetingNumber = _meetingNumberController.text;
    String priority = _priorityController.text;
    String classification = _classificationController.text;
    String date = _dateController.text;
    widget.onSearch(subject, meetingNumber, priority,classification,date);
    // Implement search logic here
    print('Search: Subject=$subject, MeetingNumber=$meetingNumber, Priority=$priority, Classification=$classification, Date=$date');
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

                  // Meeting Number Field
                  Expanded(
                    child: TextField(
                      controller: _meetingNumberController,
                      decoration: InputDecoration(
                        labelText: getTranslation('MeetingNumber'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),

                  // Priority Field
                  Expanded(
                    child: TextField(
                      controller: _priorityController,
                      decoration: InputDecoration(
                        labelText: getTranslation('Priority'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),

                  // Classification Field
                  Expanded(
                    child: TextField(
                      controller: _classificationController,
                      decoration: InputDecoration(
                        labelText: getTranslation('Classification'),
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
