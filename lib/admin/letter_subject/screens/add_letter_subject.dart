import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subjecct.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subject_repo.dart';

class AddLetterSubject extends ConsumerWidget {
  AddLetterSubject({
    super.key,
    this.currentSubject,
  });

  final LetterSubjecct? currentSubject;

  final _formKey = GlobalKey<FormState>();

  String? _tenderNumber;
  String? _subject;

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        currentSubject == null ?
         await ref.read(LetterSubjectMasterRepositoryProvider.notifier).addLetterSubject
         (subjectName: _subject!, 
         tenderNumber: _tenderNumber!
         ) : await ref.read(LetterSubjectMasterRepositoryProvider.notifier).editLetterSubject(
          currentSubjectId: currentSubject!.subjectId,
          subjectName: _subject!,
          tenderNumber: _tenderNumber!,
         );


        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subject ${currentSubject == null ? "added" : "updated"} successfully!')),
        );
        Navigator.pop(context); // Close the modal
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save subject: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        width: 500.0, // Set a specific width for the dialog modal
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Makes the dialog height dynamic
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentSubject != null
                      ? 'Edit Letter Subject'
                      : 'Add Letter Subject',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0, // Reduced width for the field
                  child: TextFormField(
                    initialValue: currentSubject?.tenderNumber,
                    decoration: const InputDecoration(
                      labelText: 'Tender Number',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _tenderNumber = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the tender number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0, // Reduced width for the field
                  child: TextFormField(
                    initialValue: currentSubject?.subject,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _subject = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the subject';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _saveForm(context, ref),
                      child: const Text('Save'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the modal on cancel
                      },
                      child: const Text('Cancel'),
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
