import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster_repo.dart';

// ignore: must_be_immutable
class AddListmasterScreen extends ConsumerWidget {
   AddListmasterScreen({super.key,this.currentListMaster});

  final ListMaster? currentListMaster;
 

  final _formKey = GlobalKey<FormState>();

  String? _listmasterNameArabic ;

  String? _listmasterNameEnglish;

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    try {
      currentListMaster == null? await ref.read(listMasterRepositoryProvider.notifier).addListMaster(
        nameEnglish: _listmasterNameEnglish!,
        nameArabic: _listmasterNameArabic!,
      ):await ref.read(listMasterRepositoryProvider.notifier).editListMaster(
        id: currentListMaster!.id,
        nameEnglish: _listmasterNameEnglish!,
        nameArabic: _listmasterNameArabic!,
      ) ;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          currentListMaster != null?
          'Listmaster edit successfully!': 'Listmaster added successfully!')),
      );

      Navigator.pop(context); // Close the modal after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add Listmaster: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context,WidgetRef ref) {
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
                  currentListMaster == null ?
                  'Add Listmaster': 'Edit Listmaster',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0, // Reduced width for the field
                  child: TextFormField(
                    initialValue: currentListMaster != null ? currentListMaster!.nameArabic:'',
                    decoration: const InputDecoration(
                      labelText: 'Name (Arabic)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _listmasterNameArabic = value;
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
                    initialValue: currentListMaster != null ? currentListMaster!.nameEnglish:'',
                    decoration: const InputDecoration(
                      labelText: 'Name (English)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _listmasterNameEnglish = value;
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
                      onPressed: (){
                        _saveForm(context,ref);
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
