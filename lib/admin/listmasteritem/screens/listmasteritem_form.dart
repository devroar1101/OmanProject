import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';

class ListMasterItemSearchForm extends ConsumerStatefulWidget {
  // Optional: Callback to pass search results to parent

  const ListMasterItemSearchForm({super.key, required this.onSearch});
  final Function(String, String) onSearch;

  @override
  _ListMasterItemSearchFormState createState() =>
      _ListMasterItemSearchFormState();
}

class _ListMasterItemSearchFormState
    extends ConsumerState<ListMasterItemSearchForm> {
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
    widget.onSearch('', '');
  }

  void _handleSearch() {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;

    widget.onSearch(nameArabic, nameEnglish);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            // Name English Text Field
            Expanded(
              child: TextField(
                controller: _nameEnglishController,
                decoration: InputDecoration(
                  labelText: 'Name English',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8.0), // Spacing between fields

            // Name Arabic Text Field
            Expanded(
              child: TextField(
                controller: _nameArabicController,
                decoration: InputDecoration(
                  labelText: 'Name Arabic',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8.0), // Spacing between fields and icons

            // Search Icon Button
            Card(
              color: const Color.fromARGB(255, 238, 240, 241),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: ColorPicker.formIconColor,
                ),
                onPressed: _handleSearch,
                tooltip: 'Search',
              ),
            ),

            // Reset Icon Button
            Card(
              color: const Color.fromARGB(255, 240, 234, 235),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: ColorPicker.formIconColor,
                ),
                onPressed: _resetFields,
                tooltip: 'Reset',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
