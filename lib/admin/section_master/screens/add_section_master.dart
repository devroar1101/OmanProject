import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart'; // Add department repo
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/section_master/model/section_master_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class AddSectionMaster extends ConsumerWidget {
  AddSectionMaster({
    super.key,
    this.currentSection,
  });

  final SectionMaster? currentSection;
  final _formKey = GlobalKey<FormState>();

  String? _sectionNameArabic;
  String? _sectionNameEnglish;
  String? _selectedDG;
  String? _selectedDepartment; // Add department selection

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.wait([
        ref.read(dgMasterRepositoryProvider.notifier).fetchDgMasters(),
        ref.read(departmentMasterRepositoryProvider.notifier).fetchDepartments(), // Fetch departments
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SizedBox(
              width: 500.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Error loading options',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    Text('${snapshot.error}'),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final dgOptions = (snapshot.data![0] as List)
            .map((dg) => SelectOption<String>(
                  displayName: dg.nameEglish,
                  key: dg.id.toString(),
                  value: dg.id.toString(),
                ))
            .toList();

        final departmentOptions = (snapshot.data![1] as List)
            .map((dept) => SelectOption<String>(
                  displayName: dept.departmentNameEnglish,
                  key: dept.id.toString(),
                  value: dept.id.toString(),
                ))
            .toList();

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
                      currentSection != null
                          ? 'Edit Section Master'
                          : 'Add Section Master',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 450.0,
                      child: TextFormField(
                        initialValue: currentSection?.sectionNameArabic,
                        decoration: const InputDecoration(
                          labelText: 'Name (Arabic)',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _sectionNameArabic = value;
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
                        initialValue: currentSection?.sectionNameEnglish,
                        decoration: const InputDecoration(
                          labelText: 'Name (English)',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _sectionNameEnglish = value;
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
                      child: SearchableDropdown<String>(
                        options: dgOptions,
                        onChanged: (key) {
                          _selectedDG = key;
                        },
                        hint: 'Select a DG',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 450.0,
                      child: SearchableDropdown<String>(
                        options: departmentOptions,
                        onChanged: (key) {
                          _selectedDepartment = key;
                        },
                        hint: 'Select a Department',
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
      },
    );
  }

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    try {
      if (currentSection == null) {
        await ref.read(SectionMasterRepositoryProvider.notifier).AddSectionMaster(
              nameArabic: _sectionNameArabic!,
              nameEnglish: _sectionNameEnglish!,
              dgId: int.parse(_selectedDG!),
              departmentId: int.parse(_selectedDepartment!), // Save department
            );
      } else {
        await ref.read(SectionMasterRepositoryProvider.notifier).editSeactionMaster(
              nameArabic: _sectionNameArabic!,
              nameEnglish: _sectionNameEnglish!,
              currentDgId: int.parse(_selectedDG!),
              currentDepartmentId: int.parse(_selectedDepartment!), // Save department
            );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Section master saved successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save section master: $e')),
      );
    }
  }
}
