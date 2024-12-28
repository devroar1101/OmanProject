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
    final dataKeys = ['nameArabic'];
    final iconButtons = [
      {"button": Icons.edit, "function": (int id) => print("Edit $id")},
      {"button": Icons.delete, "function": (int id) => print("Delete $id")},
    ];

    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    // Convert ListMasterItem list to map list with sno
    final details = Cabinet.listToMap(cabinets);

    return Stack(
      children: [
        Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Cabinets',
                prefixIcon: isRtl ? null : const Icon(Icons.search),
                suffixIcon: isRtl ? const Icon(Icons.search) : null,
              ),
              onChanged: onSearch,
            ),
            Expanded(
              child: DisplayDetails(
                iconButtons: iconButtons,
                headers: headers,
                data: dataKeys,
                details: details,
                expandable: true,
                selected: selectedCabinetId.toString(),
                detailKey: 'id',
                onTap: (index, {objectId}) {
                  onSelectCabinet(index);
                },
              ),
            ),
          ],
        ),
        onAddCabinet != null
            ? Positioned(
                top: 8,
                right: isRtl ? null : 8,
                left: isRtl ? 8 : null,
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
    currentName: cabinet.nameArabic,
    onSave: (name) => onEditCabinet(cabinet.id, name),
  );
}
