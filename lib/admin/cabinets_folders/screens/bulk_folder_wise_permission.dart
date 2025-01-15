import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';

import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_permission_repo.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';

import 'package:tenderboard/common/themes/app_theme.dart';

import '../model/folder_permission.dart';

class BulkFolderWisePermission extends ConsumerStatefulWidget {
  const BulkFolderWisePermission(
      {super.key,
      required this.cabinets,
      required this.folders,
      required this.users,
      required this.folderPermission});

  final List<Cabinet> cabinets;
  final List<Folder> folders;
  final List<User> users;
  final List<FolderPermission> folderPermission;
  @override
  _BulkFolderWisePermissionState createState() =>
      _BulkFolderWisePermissionState();
}

class _BulkFolderWisePermissionState
    extends ConsumerState<BulkFolderWisePermission> {
  late List<Cabinet> cabinets;

  late List<Folder> folders;

  late List<User> users;

  final List<int> selectedFolderIds = [];
  final List<int> selectedUserIds = [];

  String folderSearchQuery = '';
  String userSearchQuery = '';
  String cabinetSearchQuery = '';

  @override
  void initState() {
    super.initState();
    cabinets = widget.cabinets;
    folders = widget.folders;
    cabinets = widget.cabinets;
    folders = widget.folders;
    users = widget.users;
  }

  void addPermissions() {
    if (selectedFolderIds.isEmpty || selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Select at least one folder and one user')),
      );

      return;
    } else {
      for (int userId in selectedUserIds) {
        for (int folderId in selectedFolderIds) {
          ref
              .read(folderPermissionRepositoryProvider.notifier)
              .addFolderPermission(folderId: folderId, userId: userId);
        }
      }
      ref.refresh(folderPermissionRepositoryProvider);
    }
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
                      (cabinet) => cabinet.nameArabic.toLowerCase().contains(
                            cabinetSearchQuery.toLowerCase(),
                          ),
                    )
                        .map((cabinet) {
                      final cabinetFolders = folders
                          .where((folder) =>
                              folder.cabinetId == cabinet.id &&
                              folder.nameArabic
                                  .toLowerCase()
                                  .contains(folderSearchQuery.toLowerCase()))
                          .toList();

                      return ExpansionTile(
                        title: Text(cabinet.nameArabic),
                        children: cabinetFolders.map((folder) {
                          final isSelected =
                              selectedFolderIds.contains(folder.id);

                          return CheckboxListTile(
                            title: Text(folder.nameArabic),
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
        color: AppTheme.cardColor,
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
