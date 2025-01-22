import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:tenderboard/common/model/global_enum.dart';
import 'package:tenderboard/common/widgets/custom_snackbar.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_attachment.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_attachment_repo.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_content.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_content_repo.dart';
import 'package:tenderboard/office/createcircular_decision/model/cretae_circular_decision_repo.dart';

class CircularDecisionForm extends ConsumerStatefulWidget {
  final List<String>? scanDocuments;

  CircularDecisionForm({super.key, this.scanDocuments});

  @override
  _CircularDecisionFormState createState() => _CircularDecisionFormState();
}

class _CircularDecisionFormState extends ConsumerState<CircularDecisionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final List<Classification>? classifications = Classification.values;

  static const Uuid _uuid = Uuid();

  String _scanType = 'Circular';
  String _documentType = 'Internal';
  int selectedClassification = 1;

  List<String>? get scanDocuments => widget.scanDocuments;

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
  

  Future<void> onSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final objectId = _uuid.v4();
    final circularDecision = CircularDecision(
      circularNo: int.parse(_numberController.text),
      comment: _commentsController.text,
      documentType: _documentType,
      classificationId: selectedClassification,
      typeId: _scanType == 'Circular' ? 1 : 2,
      objectId: objectId,
      subject: _subjectController.text,
    );

    final circularAttachment = CircularDecisionAttachment(
      attachementType: 'ScanDocument',
      fileExtention: 'png',
      objectId: objectId,
    );

    final circularDecisionContent = scanDocuments
            ?.asMap()
            .entries
            .map(
              (entry) => CircularDecisionContent(
                content: entry.value,
                objectId: objectId,
                pageNumber: entry.key + 1,
              ),
            )
            .toList() ??
        [];

    final repo = ProviderContainer();

    try {
      await Future.wait([
        repo
            .read(circularDecisionRepositoryProvider)
            .createCircularDecision(circularDecision.toMap()),
        repo
            .read(circularDecisionAttachmentRepositoryProvider)
            .createAttachment(circularAttachment.toMap()),
        ...circularDecisionContent.map(
          (content) => repo
              .read(circularDecisionContentRepositoryProvider)
              .createContent(content.toMap()),
        ),
      ]);

      CustomSnackbar.show(
        context: context,
        durationInSeconds: 3,
        message: 'Letter saved successfully',
        title: 'Successful',
        typeId: 1,
        asset: 'assets/saving.gif',
      );
    } catch (e) {
      CustomSnackbar.show(
        context: context,
        durationInSeconds: 3,
        message: 'Failed to save the letter',
        title: 'Error',
        typeId: 2,
        asset: 'assets/error.gif',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: SingleChildScrollView(
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
                                  // Reset the classification when switching to Circular
                                  if (_scanType == 'Circular') {
                                    selectedClassification = 1;
                                  }
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
                      readOnly:
                          true, // Make the field read-only to prevent manual input
                      onTap: () async {
                        // Show the date picker
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000), // Minimum date
                          lastDate: DateTime(2100), // Maximum date
                        );

                        if (pickedDate != null) {
                          // Format the date and update the controller
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            _dateController.text = formattedDate;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16.0),

                    // Document Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Document Type'),
                        GestureDetector(
                          onTap: () => setState(() {
                            _documentType = _documentType == 'Internal'
                                ? 'External'
                                : 'Internal';
                          }),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color: _documentType == 'Internal'
                                ? Colors.blue.shade100
                                : Colors.blue.shade50,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _documentType == 'Internal'
                                        ? Icons.arrow_circle_left_outlined
                                        : Icons.arrow_circle_right_outlined,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _documentType,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

                    // Classification Field (Conditional)
                    if (_scanType == 'Decision') ...[
                      DropdownButtonFormField<int>(
                        value: selectedClassification,
                        key: ValueKey(selectedClassification),
                        decoration: InputDecoration(
                          labelText: 'Classification',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        items: classifications!.map((item) {
                          return DropdownMenuItem<int>(
                            value: item.id,
                            child: Text(item.getLabel(context)),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedClassification = newValue ?? 1;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],

                    // Save and Clear Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _clearFields,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => onSave(context),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
