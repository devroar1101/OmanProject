import 'package:flutter/material.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';

import '../model/folder_permission.dart';

class BulkFolderWisePermission extends StatefulWidget {
  const BulkFolderWisePermission({super.key});
  @override
  _BulkFolderWisePermissionState createState() =>
      _BulkFolderWisePermissionState();
}

class _BulkFolderWisePermissionState extends State<BulkFolderWisePermission> {
  final List<Cabinet> cabinets = [
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

  final List<User> users = [
    User(id: 1, name: 'User 1'),
    User(id: 2, name: 'User 2'),
    User(id: 3, name: 'User 3'),
    User(id: 4, name: 'User 4'),
  ];

  final List<int> selectedFolderIds = [];
  final List<int> selectedUserIds = [];

  String folderSearchQuery = '';
  String userSearchQuery = '';
  String cabinetSearchQuery = '';

  void addPermissions() {
    if (selectedFolderIds.isEmpty || selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Select at least one folder and one user')),
      );
      return;
    }

    // Logic for adding permissions
    print('Adding permissions for folders: $selectedFolderIds');
    print('Adding permissions for users: $selectedUserIds');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Pane: Folders
          Expanded(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search Cabinets',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      cabinetSearchQuery = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search Folders',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      folderSearchQuery = value;
                    });
                  },
                ),
                Expanded(
                  child: ListView(
                    children: cabinets
                        .where(
                      (cabinet) => cabinet.name.toLowerCase().contains(
                            cabinetSearchQuery.toLowerCase(),
                          ),
                    )
                        .map((cabinet) {
                      final cabinetFolders = folders
                          .where((folder) =>
                              folder.cabinetId == cabinet.id &&
                              folder.name
                                  .toLowerCase()
                                  .contains(folderSearchQuery.toLowerCase()))
                          .toList();

                      return ExpansionTile(
                        title: Text(cabinet.name),
                        children: cabinetFolders.map((folder) {
                          final isSelected =
                              selectedFolderIds.contains(folder.id);

                          return CheckboxListTile(
                            title: Text(folder.name),
                            value: isSelected,
                            onChanged: (isChecked) {
                              setState(() {
                                if (isChecked ?? false) {
                                  selectedFolderIds.add(folder.id);
                                } else {
                                  selectedFolderIds.remove(folder.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          // Right Pane: Users
          Expanded(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search Users',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      userSearchQuery = value;
                    });
                  },
                ),
                Expanded(
                  child: ListView(
                    children: users
                        .where((user) => user.name
                            .toLowerCase()
                            .contains(userSearchQuery.toLowerCase()))
                        .map((user) {
                      final isSelected = selectedUserIds.contains(user.id);

                      return CheckboxListTile(
                        title: Text(user.name),
                        value: isSelected,
                        onChanged: (isChecked) {
                          setState(() {
                            if (isChecked ?? false) {
                              selectedUserIds.add(user.id);
                            } else {
                              selectedUserIds.remove(user.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Folders: ${selectedFolderIds.length}, '
                'Selected Users: ${selectedUserIds.length}',
              ),
              ElevatedButton(
                onPressed: addPermissions,
                child: const Text('Add Permissions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
