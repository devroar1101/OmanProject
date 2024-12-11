import 'package:flutter/material.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';

import '../model/folder_permission.dart';

class UserWisePermission extends StatefulWidget {
  const UserWisePermission(
      {super.key, required this.cabinets, required this.folders});

  final List<Cabinet> cabinets;
  final List<Folder> folders;
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

  List<Cabinet> cabinets = [];

  List<Folder> folders = [];

  final List<FolderPermission> permissions = [
    FolderPermission(id: 1, cabinetId: 1, folderId: 1, userId: 1),
    FolderPermission(id: 2, cabinetId: 1, folderId: 2, userId: 2),
  ];

  int? selectedUserId;
  String userSearchQuery = '';
  String cabinetSearchQuery = '';

  @override
  void initState() {
    super.initState();
    cabinets = widget.cabinets;
    folders = widget.folders;
  }

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
          const VerticalDivider(),
          // Second Pane: Cabinets and Folders
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
                if (selectedUserId == null)
                  const Center(
                    child: Text('Select a user to view cabinets and folders'),
                  )
                else
                  Expanded(
                    child: ListView(
                      children: cabinets
                          .where((cabinet) => cabinet.nameArabic
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
                              const SizedBox(width: 8),
                              Text(cabinet.nameArabic),
                            ],
                          ),
                          children: cabinetFolders.map((folder) {
                            final isFolderSelected =
                                hasFolderPermission(folder.id);

                            return CheckboxListTile(
                              title: Text(folder.nameArabic),
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
