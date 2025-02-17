import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem_repo.dart';

class AddListMasterItemScreen extends ConsumerWidget {
  final ListMasterItem? currentListMasterItem;
  final int currentListMasterId;

  AddListMasterItemScreen(
      {super.key,
      this.currentListMasterItem,
      required this.currentListMasterId});

  final _formKey = GlobalKey<FormState>();
  String? _nameArabic;
  String? _nameEnglish;

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (currentListMasterItem == null) {
          await ref
              .read(listMasterItemRepositoryProvider.notifier)
              .addListMasterItem(
                listMasterId: currentListMasterId,
                nameArabic: _nameArabic!,
                nameEnglish: _nameEnglish!,
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('ListMaster Item added successfully!')),
          );
        } else {
          print('edit current list master id ==> $currentListMasterId');
          await ref
              .read(listMasterItemRepositoryProvider.notifier)
              .editListMasterItem(
                listMasterId: currentListMasterId,
                listMasterItemId: currentListMasterItem!.id,
                nameArabic: _nameArabic!,
                nameEnglish: _nameEnglish!,
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('ListMaster Item edited successfully!')),
          );
        }
        Navigator.pop(context); // Close the modal after saving
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save ListMaster Item: $e')),
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
                  currentListMasterItem == null
                      ? 'Add ListMasterItem'
                      : 'Edit ListMasterItem',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: currentListMasterItem?.nameArabic ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Name (Arabic)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _nameArabic = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the Arabic name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: currentListMasterItem?.nameEnglish ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Name (English)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _nameEnglish = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the English name';
                    }
                    return null;
                  },
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
                      onPressed: () => Navigator.pop(context),
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
