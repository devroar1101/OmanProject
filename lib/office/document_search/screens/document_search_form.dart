import 'package:flutter/material.dart';

class DocumentSearchForm extends StatefulWidget {
  const DocumentSearchForm({Key? key}) : super(key: key);

  @override
  _DocumentSearchFormState createState() => _DocumentSearchFormState();
}

class _DocumentSearchFormState extends State<DocumentSearchForm> {
  final _formKey = GlobalKey<FormState>(); // Form key to manage form state
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _tenderNumberController = TextEditingController();
  final TextEditingController _letterDateFromController =
      TextEditingController();
  final TextEditingController _letterDateToController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _receivedFromController = TextEditingController();
  final TextEditingController _receivedToController = TextEditingController();

  String _scanType = 'Type 1';
  String _direction = 'All';
  String _tenderStatus = 'Active';
  String _year = '2024';

  void _resetFields() {
    _subjectController.clear();
    _tenderNumberController.clear();
    _letterDateFromController.clear();
    _letterDateToController.clear();
    _locationController.clear();
    _referenceController.clear();
    _receivedFromController.clear();
    _receivedToController.clear();
    setState(() {
      _scanType = 'Type 1';
      _direction = 'All';
      _tenderStatus = 'Active';
      _year = '2024';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Attach formKey to manage form state
            child: Column(
              children: [
                // First Row: Scan Type, Letter Date From
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Scan Type Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _scanType,
                        decoration: InputDecoration(
                          labelText: 'Scan Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        items: ['Type 1', 'Type 2'].map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _scanType = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a scan type';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Letter Date From
                    Expanded(
                      child: TextFormField(
                        controller: _letterDateFromController,
                        decoration: InputDecoration(
                          labelText: 'Letter Date From',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Second Row: Subject, Letter Date To
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Subject
                    Expanded(
                      child: TextFormField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a subject';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Letter Date To
                    Expanded(
                      child: TextFormField(
                        controller: _letterDateToController,
                        decoration: InputDecoration(
                          labelText: 'Letter Date To',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Third Row: Year, Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Year Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _year,
                        decoration: InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        items: ['2024', '2023', '2022'].map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _year = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a year';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Location
                    Expanded(
                      child: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Fourth Row: Tender Status, Reference #
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tender Status Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _tenderStatus,
                        decoration: InputDecoration(
                          labelText: 'Tender Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        items: ['Active', 'Closed'].map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _tenderStatus = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select tender status';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Reference #
                    Expanded(
                      child: TextFormField(
                        controller: _referenceController,
                        decoration: InputDecoration(
                          labelText: 'Reference #',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter reference #';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Fifth Row: Received From, Received To
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Received From
                    Expanded(
                      child: TextFormField(
                        controller: _receivedFromController,
                        decoration: InputDecoration(
                          labelText: 'Received From',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter received from date';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Received To
                    Expanded(
                      child: TextFormField(
                        controller: _receivedToController,
                        decoration: InputDecoration(
                          labelText: 'Received To',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter received to date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Sixth Row: Tender Number, Direction (Radio)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tender Number
                    Expanded(
                      child: TextFormField(
                        controller: _tenderNumberController,
                        decoration: InputDecoration(
                          labelText: 'Tender Number',
                          
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter tender number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Direction Radio Buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Direction'),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Incoming',
                              groupValue: _direction,
                              onChanged: (value) {
                                setState(() {
                                  _direction = value!;
                                });
                              },
                            ),
                            const Text('Incoming'),
                            Radio<String>(
                              value: 'Outgoing',
                              groupValue: _direction,
                              onChanged: (value) {
                                setState(() {
                                  _direction = value!;
                                });
                              },
                            ),
                            const Text('Outgoing'),
                            Radio<String>(
                              value: 'All',
                              groupValue: _direction,
                              onChanged: (value) {
                                setState(() {
                                  _direction = value!;
                                });
                              },
                            ),
                            const Text('All'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Submit and Reset Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        //   // Process form data
                        // }
                      },
                      child: const Text('Submit'),
                    ),
                    ElevatedButton(
                      onPressed: _resetFields,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
