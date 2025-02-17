import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';

import 'package:tenderboard/common/widgets/custom_snackbar.dart';

import 'package:tenderboard/common/widgets/select_field.dart';

class AddDepartment extends ConsumerWidget {
  AddDepartment({
    super.key,
    this.currentDepartment,
  });

  final Department? currentDepartment;
  final _formKey = GlobalKey<FormState>();

  String? _departmentNameArabic;
  String? _departmentNameEnglish;
  String? _selectedDG;
  String? _selectDGName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dgOptionAsyncvalue = ref.watch(dgOptionsProvider(false));

    final dgOptions = dgOptionAsyncvalue.asData?.value;
    print('current department - => $currentDepartment');

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        width: 500.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentDepartment != null
                      ? 'Edit Department '
                      : 'Add Department ',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0,
                  child: TextFormField(
                    initialValue: currentDepartment?.nameArabic,
                    decoration: const InputDecoration(
                      labelText: 'Name (Arabic)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _departmentNameArabic = value;
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
                  width: 450.0,
                  child: TextFormField(
                    initialValue: currentDepartment?.nameEnglish,
                    decoration: const InputDecoration(
                      labelText: 'Name (English)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _departmentNameEnglish = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the English name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0,
                  child: SelectField<Dg>(
                    label: 'DG',
                    options: dgOptions!,
                    initialValue: currentDepartment != null
                        ? dgOptions
                            .firstWhere((option) =>
                                option.key ==
                                currentDepartment!.dgId.toString())
                            .displayName
                        : null,
                    onChanged: (dG, selectedOption) {
                      _selectedDG = dG.id.toString();
                    },
                    hint: 'Select a DG',
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _saveForm(context, ref);
                        }
                      },
                      child: const Text('Save'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
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

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    print('en- $_departmentNameEnglish');
    print('ar- $_departmentNameArabic');
    print('dg- $_selectedDG');
    try {
      if (currentDepartment == null) {
        await ref.read(departmentRepositoryProvider.notifier).addDepartment(
              nameArabic: _departmentNameArabic!,
              nameEnglish: _departmentNameEnglish!,
              dgId: _selectedDG!,
            );
      } else {
        await ref.read(departmentRepositoryProvider.notifier).editDepartment(
              currentDepartmentId: currentDepartment!.id,
              nameArabic: _departmentNameArabic!,
              nameEnglish: _departmentNameEnglish!,
              dgId: int.parse(_selectedDG!),
            );
      }
      Navigator.pop(context);
      CustomSnackbar.show(
        context: context,
        title: 'successfully',
        durationInSeconds: 3,
        message: 'Department  saved successfully!',
        typeId: 1,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save department : $e')),
      );
    }
  }
}
