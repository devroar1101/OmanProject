import 'package:flutter/material.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/cabinet_home.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class CabinetSection extends StatelessWidget {
  final List<Cabinet> cabinets;
  final int? selectedCabinetId;
  final Function(int) onSelectCabinet;
  final Function(String) onSearch;
  final Function(String)? onAddCabinet;
  final Function(int, String)? onEditCabinet;

  const CabinetSection({
    super.key,
    required this.cabinets,
    required this.selectedCabinetId,
    required this.onSelectCabinet,
    required this.onSearch,
    this.onAddCabinet,
    this.onEditCabinet,
  });

  @override
  Widget build(BuildContext context) {
    final headers = ['Cabinets'];
    final dataKeys = ['name'];

    // Convert ListMasterItem list to map list with sno
    final details = Cabinet.cabinetsToListOfMaps(cabinets);

    return Stack(
      children: [
        Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Cabinets',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: onSearch,
            ),
            Expanded(
              child: DisplayDetails(
                headers: headers,
                data: dataKeys,
                details: details,
                expandable: true,
                selectedNo: selectedCabinetId,
                onTap: (index) {
                  onSelectCabinet(index);
                },
              ),
            ),
          ],
        ),
        onAddCabinet != null
            ? Positioned(
                top: 8,
                right: 8,
                child: ElevatedButton(
                  onPressed: () => showAddDialog(
                    context,
                    title: 'Add Cabinet',
                    onSave: onAddCabinet!,
                  ),
                  child: const Icon(Icons.add),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

void editCabinet(context, Cabinet cabinet, onEditCabinet) {
  showEditDialog(
    context,
    title: 'Edit Cabinet',
    currentName: cabinet.name,
    onSave: (name) => onEditCabinet(cabinet.id, name),
  );
}
