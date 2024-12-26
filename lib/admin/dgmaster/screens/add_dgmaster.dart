import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'package:tenderboard/common/widgets/custom_snackbar.dart';

class AddDGmasterScreen extends ConsumerWidget {
  AddDGmasterScreen(
      {super.key, this.editNameArabic, this.editNameEnglish, this.currentDGId});
  final String? editNameArabic;
  final String? editNameEnglish;
  final int? currentDGId;
  final _formKey = GlobalKey<FormState>();

  String? _dgNameArabic;
  String? _dgNameEnglish;

  Future<void> _saveForm(BuildContext context, WidgetRef ref,) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        currentDGId == null
            ? await ref.read(dgMasterRepositoryProvider.notifier).addDgMaster(
                  nameArabic: _dgNameArabic!,
                  nameEnglish: _dgNameEnglish!,
                )
            : await ref.read(dgMasterRepositoryProvider.notifier).editDGMaster(
                  currentDGId: currentDGId!,
                  editNameArabic: _dgNameArabic!,
                  editNameEnglish: _dgNameEnglish!,
                );
        // Navigate or display a success message
        CustomSnackbar.show(context: context, title: 'successfully', message: getTranslation(
          'Dgaddedsuccessfully!'
        ), typeId: 1, durationInSeconds: 3);
        Navigator.pop(context); // Close the modal after saving
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add DGmaster: $e $currentDGId -currentDGID')),
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
                Text( currentDGId != null?
                  'Edit DGmaster' : 'Add DGmaster',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0, // Reduced width for the field
                  child: TextFormField(
                    initialValue: editNameArabic,
                    decoration: const InputDecoration(
                      labelText: 'Name (Arabic)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _dgNameArabic = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the Arabic name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0, // Reduced width for the field
                  child: TextFormField(
                    initialValue: editNameEnglish,
                    decoration: const InputDecoration(
                      labelText: 'Name (English)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _dgNameEnglish = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the English name';
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
                      onPressed: () {
                        _saveForm(context, ref);
                      },
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
