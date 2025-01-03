import 'package:flutter/material.dart';

class CircularDecisionForm extends StatefulWidget {
  const CircularDecisionForm({super.key});

  @override
  _CircularDecisionFormState createState() => _CircularDecisionFormState();
}

class _CircularDecisionFormState extends State<CircularDecisionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  String _scanType = 'Circular';
  String _documentType = 'Internal';

  void _clearFields() {
    _numberController.clear();
    _dateController.clear();
    _subjectController.clear();
    _commentsController.clear();
    setState(() {
      _scanType = 'Circular';
      _documentType = 'Internal';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Circular and Decision'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scan Type Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Scan Type'),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Circular',
                            groupValue: _scanType,
                            onChanged: (value) {
                              setState(() {
                                _scanType = value!;
                              });
                            },
                          ),
                          const Text('Circular'),
                          Radio<String>(
                            value: 'Decision',
                            groupValue: _scanType,
                            onChanged: (value) {
                              setState(() {
                                _scanType = value!;
                              });
                            },
                          ),
                          const Text('Decision'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Number Field
                  TextFormField(
                    controller: _numberController,
                    decoration: InputDecoration(
                      labelText: 'Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Date Field
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Document Type Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Document Type'),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Internal',
                            groupValue: _documentType,
                            onChanged: (value) {
                              setState(() {
                                _documentType = value!;
                              });
                            },
                          ),
                          const Text('Internal'),
                          Radio<String>(
                            value: 'External',
                            groupValue: _documentType,
                            onChanged: (value) {
                              setState(() {
                                _documentType = value!;
                              });
                            },
                          ),
                          const Text('External'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Subject Field
                  TextFormField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Comments Field
                  TextFormField(
                    controller: _commentsController,
                    decoration: InputDecoration(
                      labelText: 'Comments',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16.0),

                  // Clear Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _clearFields,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
