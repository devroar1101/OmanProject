import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_permission_repo.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';

import '../model/folder_permission.dart';

class UserWisePermission extends ConsumerStatefulWidget {
  const UserWisePermission(
      {super.key,
      required this.cabinets,
      required this.folders,
      required this.users,
      required this.folderPermission});

  final List<Cabinet> cabinets;
  final List<Folder> folders;
  final List<UserMaster> users;
  final List<FolderPermission> folderPermission;
  @override
  _UserWisePermissionState createState() => _UserWisePermissionState();
}

class _UserWisePermissionState extends ConsumerState<UserWisePermission> {
  List<UserMaster> users = [];

  List<Cabinet> cabinets = [];

  List<Folder> folders = [];

  List<FolderPermission> permissions = [];

  int? selectedUserId;
  String userSearchQuery = '';
  String cabinetSearchQuery = '';

  @override
  void initState() {
    super.initState();
    cabinets = widget.cabinets;
    folders = widget.folders;
    users = widget.users;
    permissions = widget.folderPermission;
  }

  void togglePermission(int folderId, int userId) {
    final permissionIndex = permissions.indexWhere((permission) =>
        permission.userId == selectedUserId && permission.folderId == folderId);
    print(permissionIndex);

    if (permissionIndex != -1) {
      ref
          .read(folderPermissionRepositoryProvider.notifier)
          .deleteFolderPermission(permissionIndex);
      permissions.removeAt(permissionIndex);
    } else {
      ref
          .read(folderPermissionRepositoryProvider.notifier)
          .addFolderPermission(folderId: folderId, userId: userId);
    }
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
                                togglePermission(folder.id, selectedUserId!);
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
