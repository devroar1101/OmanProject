import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tenderboard/common/model/global_enum.dart';
// Replace with correct provider package if needed
import 'package:tenderboard/common/widgets/custom_snackbar.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_attachment.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_attachment_repo.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_content.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_content_repo.dart';
import 'package:tenderboard/office/createcircular_decision/model/cretae_circular_decision_repo.dart';
import 'package:uuid/uuid.dart';

class MeetingMinutesForm extends ConsumerStatefulWidget {
  final List<String>? scanDocuments;
  MeetingMinutesForm({super.key, this.scanDocuments});

  @override
  _MeetingMinutesFormState createState() => _MeetingMinutesFormState();
}

class _MeetingMinutesFormState extends ConsumerState<MeetingMinutesForm> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = Uuid();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final List<Classification>? classifications = Classification.values;
  final List<Priority>? prioritys = Priority.values;
  final _subjectController = TextEditingController();
  String? _documentType;
  String? _scanType;
  int? selectedClassification = 1;
  int? SelectedPriority = 1;
  List<String>? scanDocuments;

  Future<void> onSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final objectId = _uuid.v4();
    final circularDecision = CircularDecision(
      priorityId: SelectedPriority,
      meetingNumber: _numberController.text,
      comment: _commentsController.text,
      documentType: _documentType,
      classificationId: selectedClassification,
      typeId: 3,
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

    final repo =
        ProviderContainer(); // Replace with correct initialization for your app

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
    return 
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextFormField(
                  //   controller: _numberController,
                  //   decoration: InputDecoration(
                  //     labelText: 'File Name & Code',
                  //     suffixIcon: IconButton(
                  //       icon: const Icon(Icons.lock),
                  //       onPressed: () {},
                  //     ),
                  //     border: const OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  TextFormField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                      labelText: 'Meeting Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: SelectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: prioritys!.map((item){
                      return DropdownMenuItem<int>(
                        value: item.id,
                        child:Text(item.getLabel(context)) 
                        );
                    }).toList(),
                    onChanged: (int? newvalue) {
                      setState(() {
                        SelectedPriority = newvalue ?? 1;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _subjectController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _commentsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => onSave(context),
                      icon: const Icon(Icons.save),
                      label: const Text('SAVE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    
  }
}
