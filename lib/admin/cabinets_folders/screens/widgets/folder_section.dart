import 'package:flutter/material.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/cabinet_home.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class FolderSection extends StatelessWidget {
  final List<Folder> folders;
  final Cabinet selectedCabinet;
  final int? selectedFolderId;
  final Function(String) onSearch;
  final Function(String)? onAddFolder;
  final Function(int, String)? onEditFolder;
  final Function(int) onSelectFolder;

  const FolderSection({
    super.key,
    required this.folders,
    required this.selectedCabinet,
    required this.selectedFolderId,
    required this.onSearch,
    this.onAddFolder,
    this.onEditFolder,
    required this.onSelectFolder,
  });

  @override
  Widget build(BuildContext context) {
    final headers = ['Folder'];
    final dataKeys = ['name'];

    // Convert ListMasterItem list to map list with sno
    final details = Folder.foldersToListOfMaps(folders);
    return Stack(
      children: [
        Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Folders',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: onSearch,
            ),
            ListTile(
              title: Text(
                'Folders in "${selectedCabinet.name}"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: DisplayDetails(
                headers: headers,
                data: dataKeys,
                details: details,
                selectedNo: selectedFolderId,
                onTap: (index) {
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
                right: 8,
                child: ElevatedButton(
                  onPressed: selectedCabinet.id == 0
                      ? null
                      : () => showAddDialog(
                            context,
                            title: 'Add Folder',
                            onSave: onAddFolder!,
                          ),
                  child: const Icon(Icons.add),
                ),
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
