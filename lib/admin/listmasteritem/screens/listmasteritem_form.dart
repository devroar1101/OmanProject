import 'package:flutter/material.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem_repo.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';

class ListMasterItemSearchForm extends StatefulWidget {
  // Optional: Callback to pass search results to parent
  final Function(List<ListMasterItem>)? onSearch;

  const ListMasterItemSearchForm({super.key, this.onSearch});

  @override
  _ListMasterItemSearchFormState createState() =>
      _ListMasterItemSearchFormState();
}

class _ListMasterItemSearchFormState extends State<ListMasterItemSearchForm> {
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final ListMasterItemRepository _repository = ListMasterItemRepository();

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
  }

  Future<void> _handleSearch() async {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;

    try {
      // Fetch filtered list of ListMasterItems
      List<ListMasterItem> results = await _repository.fetchListMasterItems(
        nameArabic: nameArabic,
        nameEnglish: nameEnglish,
      );

      // Optional: Pass results back to parent widget if a callback is provided
      if (widget.onSearch != null) {
        widget.onSearch!(results);
      }
    } catch (e) {
      // Handle errors if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred during search: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                icon: const Icon(Icons.search),
                onPressed: _handleSearch,
                tooltip: 'Search',
              ),
            ),

            // Reset Icon Button
            Card(
              color: const Color.fromARGB(255, 240, 234, 235),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.refresh),
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
