import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tenderboard/admin/cabinets_folders/model/cabinet_repo.dart';

import 'package:tenderboard/admin/cabinets_folders/model/folder_repo.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/cabinet_section.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/folder_section.dart';

class CabinetHome extends ConsumerStatefulWidget {
  const CabinetHome({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CabinetHomeState createState() => _CabinetHomeState();
}

class _CabinetHomeState extends ConsumerState<CabinetHome> {
  int? selectedCabinetId = 1;
  String cabinetSearchQuery = '';
  String folderSearchQuery = '';
  int? selectedFolderId;

  @override
  void initState() {
    super.initState();
    ref.read(cabinetRepositoryProvider.notifier).fetchCabinets();
    ref.read(folderRepositoryProvider.notifier).fetchFolders();
  }

  @override
  Widget build(BuildContext context) {
    final cabinets = ref.watch(cabinetRepositoryProvider);
    final folders = ref.watch(folderRepositoryProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: CabinetSection(
                cabinets: cabinets
                    .where((cabinet) => cabinet.nameArabic
                        .toLowerCase()
                        .contains(cabinetSearchQuery))
                    .toList(),
                selectedCabinetId: selectedCabinetId,
                onSelectCabinet: (id) {
                  setState(() {
                    selectedCabinetId = id;
                    selectedFolderId = 0; // Reset selected folder
                  });
                },
                onSearch: (query) {
                  setState(() {
                    cabinetSearchQuery = query.toLowerCase();
                  });
                },
                onAddCabinet: (name) {
                  ref
                      .read(cabinetRepositoryProvider.notifier)
                      .addCabinet(nameEnglish: name, nameArabic: name);
                },
                onEditCabinet: (id, name) {
                  ref
                      .read(cabinetRepositoryProvider.notifier)
                      .editCabinet(id: id, nameEnglish: name, nameArabic: name);
                },
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: FolderSection(
                folders: folders
                    .where((folder) =>
                        (folder.cabinetId == selectedCabinetId) &&
                        folder.nameArabic
                            .toLowerCase()
                            .contains(folderSearchQuery))
                    .toList(),
                selectedCabinet: cabinets.isEmpty
                    ? null
                    : cabinets.firstWhere(
                        (cabinet) => cabinet.id == selectedCabinetId,
                        orElse: () => cabinets[0]),
                selectedFolderId: selectedFolderId,
                onSearch: (query) {
                  setState(() {
                    folderSearchQuery = query.toLowerCase();
                  });
                },
                onAddFolder: (name) {
                  if (selectedCabinetId != null && selectedCabinetId != 0) {
                    ref.read(folderRepositoryProvider.notifier).addFolder(
                        nameEnglish: name,
                        nameArabic: name,
                        cabinetId: selectedCabinetId!);
                  }
                },
                onEditFolder: (id, name) {
                  ref.read(folderRepositoryProvider.notifier).editFolder(
                      id: id,
                      nameEnglish: name,
                      nameArabic: name,
                      cabinetId: selectedCabinetId!);
                },
                onSelectFolder: (id) {
                  setState(() {
                    selectedFolderId = id;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAddDialog(BuildContext context,
    {required String title, required Function(String) onSave}) {
  String newName = '';
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        onChanged: (value) => newName = value,
        decoration: const InputDecoration(labelText: 'Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (newName.isNotEmpty) {
              onSave(newName);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

void showEditDialog(BuildContext context,
    {required String title,
    required String currentName,
    required Function(String) onSave}) {
  String newName = currentName;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        onChanged: (value) => newName = value,
        decoration: const InputDecoration(labelText: 'Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (newName.isNotEmpty) {
              onSave(newName);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
