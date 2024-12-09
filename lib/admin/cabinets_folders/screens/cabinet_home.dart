import 'package:flutter/material.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/cabinet_section.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/folder_section.dart';

class CabinetHome extends StatefulWidget {
  const CabinetHome({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CabinetHomeState createState() => _CabinetHomeState();
}

class _CabinetHomeState extends State<CabinetHome> {
  final List<Cabinet> cabinets = [
    Cabinet(id: 0, name: 'All Cabinets'),
    Cabinet(id: 1, name: 'Cabinet 1'),
    Cabinet(id: 2, name: 'Cabinet 2'),
    Cabinet(id: 3, name: 'Cabinet 3'),
  ];

  final List<Folder> folders = [
    Folder(id: 1, name: 'Folder A', cabinetId: 1),
    Folder(id: 2, name: 'Folder B', cabinetId: 1),
    Folder(id: 3, name: 'Folder C', cabinetId: 2),
    Folder(id: 4, name: 'Folder D', cabinetId: 3),
  ];

  int? selectedCabinetId = 0;
  String cabinetSearchQuery = '';
  String folderSearchQuery = '';
  int? selectedFolderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: CabinetSection(
              cabinets: cabinets
                  .where((cabinet) =>
                      cabinet.name.toLowerCase().contains(cabinetSearchQuery))
                  .toList(),
              selectedCabinetId: selectedCabinetId,
              onSelectCabinet: (id) {
                setState(() {
                  selectedCabinetId = id;
                  selectedFolderId = null; // Reset selected folder
                });
              },
              onSearch: (query) {
                setState(() {
                  cabinetSearchQuery = query.toLowerCase();
                });
              },
              onAddCabinet: (name) {
                setState(() {
                  cabinets.add(Cabinet(
                    id: cabinets.length,
                    name: name,
                  ));
                });
              },
              onEditCabinet: (id, name) {
                setState(() {
                  final index =
                      cabinets.indexWhere((cabinet) => cabinet.id == id);
                  if (index != -1) cabinets[index].name = name;
                });
              },
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: FolderSection(
              folders: folders
                  .where((folder) =>
                      (selectedCabinetId == 0 ||
                          folder.cabinetId == selectedCabinetId) &&
                      folder.name.toLowerCase().contains(folderSearchQuery))
                  .toList(),
              selectedCabinet: cabinets.firstWhere(
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
                  setState(() {
                    folders.add(Folder(
                      id: folders.length + 1,
                      name: name,
                      cabinetId: selectedCabinetId!,
                    ));
                  });
                }
              },
              onEditFolder: (id, name) {
                setState(() {
                  final index = folders.indexWhere((folder) => folder.id == id);
                  if (index != -1) folders[index].name = name;
                });
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
