import 'package:flutter/material.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/cabinet_home.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class FolderSection extends StatelessWidget {
  final List<Folder> folders;
  final Cabinet? selectedCabinet;
  final int? selectedFolderId;
  final Function(String) onSearch;
  final Function(String)? onAddFolder;
  final Function(int, String)? onEditFolder;
  final Function(int) onSelectFolder;

  const FolderSection({
    super.key,
    required this.folders,
    this.selectedCabinet,
    required this.selectedFolderId,
    required this.onSearch,
    this.onAddFolder,
    this.onEditFolder,
    required this.onSelectFolder,
  });

  @override
  Widget build(BuildContext context) {
    final headers = ['Folder'];
    final dataKeys = ['nameArabic'];
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    print('displayfolder${folders[0].nameArabic}${folders[0].id}');

    // Convert ListMasterItem list to map list with sno
    final details = Folder.listToMap(folders);
    return Stack(
      children: [
        Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Folders',
                prefixIcon: isRtl ? null : const Icon(Icons.search),
                suffix: isRtl ? const Icon(Icons.search) : null,
              ),
              onChanged: onSearch,
            ),
            if (selectedCabinet != null)
              ListTile(
                title: Text(
                  'Folders in "${selectedCabinet!.nameArabic}"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: DisplayDetails(
                headers: headers,
                data: dataKeys,
                details: details,
                selected: selectedFolderId.toString(),
                detailKey: 'cabinetFolderId',
                onTap: (index, {objectId}) {
                  onSelectFolder(index);
                },
                expandable: true,
              ),
            ),
          ],
        ),
        onAddFolder != null
            ? Positioned(
                top: 8,
                right: isRtl ? null : 8,
                left: isRtl ? 8 : null,
                child: selectedCabinet != null
                    ? ElevatedButton(
                        onPressed: selectedCabinet!.id == 0
                            ? null
                            : () => showAddDialog(
                                  context,
                                  title: 'Add Folder',
                                  onSave: onAddFolder!,
                                ),
                        child: const Icon(Icons.add),
                      )
                    : const SizedBox.shrink(),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

void editFolder(context, folder, onEditFolder) {
  showEditDialog(
    context,
    title: 'Edit Folder',
    currentName: folder.name,
    onSave: (name) => onEditFolder(folder.id, name),
  );
}
