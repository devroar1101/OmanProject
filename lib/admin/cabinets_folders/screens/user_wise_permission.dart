import 'package:flutter/material.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';

import '../model/folder_permission.dart';

class UserWisePermission extends StatefulWidget {
  const UserWisePermission({super.key});
  @override
  _UserWisePermissionState createState() => _UserWisePermissionState();
}

class _UserWisePermissionState extends State<UserWisePermission> {
  final List<User> users = [
    User(id: 1, name: 'User 1'),
    User(id: 2, name: 'User 2'),
    User(id: 3, name: 'User 3'),
    User(id: 4, name: 'User 4'),
  ];

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

  final List<FolderPermission> permissions = [
    FolderPermission(id: 1, cabinetId: 1, folderId: 1, userId: 1),
    FolderPermission(id: 2, cabinetId: 1, folderId: 2, userId: 2),
  ];

  int? selectedUserId;
  String userSearchQuery = '';
  String cabinetSearchQuery = '';

  void togglePermission(int folderId, int cabinetId) {
    setState(() {
      final permissionIndex = permissions.indexWhere((permission) =>
          permission.userId == selectedUserId &&
          permission.cabinetId == cabinetId &&
          permission.folderId == folderId);

      if (permissionIndex != -1) {
        permissions.removeAt(permissionIndex);
      } else {
        permissions.add(FolderPermission(
            id: permissions.length + 1,
            cabinetId: cabinetId,
            folderId: folderId,
            userId: selectedUserId!));
      }
    });
  }

  bool hasFolderPermission(int folderId) {
    return permissions.any((permission) =>
        permission.userId == selectedUserId && permission.folderId == folderId);
  }

  bool hasCabinetPermission(int cabinetId) {
    final cabinetFolders =
        folders.where((folder) => folder.cabinetId == cabinetId);
    return cabinetFolders.any((folder) => permissions.any((permission) =>
        permission.userId == selectedUserId &&
        permission.folderId == folder.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // First Pane: Users
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
                      return ListTile(
                        title: Text(user.name),
                        selected: user.id == selectedUserId,
                        onTap: () {
                          setState(() {
                            selectedUserId = user.id;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(),
          // Second Pane: Cabinets and Folders
          Expanded(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Cabinets',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      cabinetSearchQuery = value;
                    });
                  },
                ),
                if (selectedUserId == null)
                  Center(
                    child: Text('Select a user to view cabinets and folders'),
                  )
                else
                  Expanded(
                    child: ListView(
                      children: cabinets
                          .where((cabinet) => cabinet.name
                              .toLowerCase()
                              .contains(cabinetSearchQuery.toLowerCase()))
                          .map((cabinet) {
                        final cabinetFolders = folders
                            .where((folder) => folder.cabinetId == cabinet.id)
                            .toList();
                        final isCabinetSelected =
                            hasCabinetPermission(cabinet.id);

                        return ExpansionTile(
                          title: Row(
                            children: [
                              Icon(
                                isCabinetSelected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: isCabinetSelected
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(cabinet.name),
                            ],
                          ),
                          children: cabinetFolders.map((folder) {
                            final isFolderSelected =
                                hasFolderPermission(folder.id);

                            return CheckboxListTile(
                              title: Text(folder.name),
                              value: isFolderSelected,
                              onChanged: (isChecked) {
                                togglePermission(folder.id, cabinet.id);
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
        ],
      ),
    );
  }
}
