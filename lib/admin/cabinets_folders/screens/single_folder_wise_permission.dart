import 'package:flutter/material.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/cabinet_section.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/folder_section.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/user_section.dart';

import '../model/folder_permission.dart';

class FolderWisePermission extends StatefulWidget {
  const FolderWisePermission({super.key});
  @override
  _FolderWisePermissionState createState() => _FolderWisePermissionState();
}

class _FolderWisePermissionState extends State<FolderWisePermission> {
  // Sample data
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

  final List<User> users = [
    User(id: 1, name: 'User 1'),
    User(id: 2, name: 'User 2'),
    User(id: 3, name: 'User 3'),
  ];

  final List<FolderPermission> permissions = [
    FolderPermission(id: 1, cabinetId: 1, folderId: 1, userId: 1),
    FolderPermission(id: 2, cabinetId: 1, folderId: 2, userId: 2),
  ];

  int selectedCabinetId = 0;
  int selectedFolderId = -1;
  int parentId = 0;
  String cabinetSearchQuery = '';
  String folderSearchQuery = '';
  String userSearchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // First Pane: Cabinets
          Expanded(
            child: CabinetSection(
              cabinets: cabinets
                  .where((cabinet) =>
                      cabinet.name.toLowerCase().contains(cabinetSearchQuery))
                  .toList(),
              selectedCabinetId: selectedCabinetId,
              onSearch: (query) {
                setState(() {
                  cabinetSearchQuery = query;
                });
              },
              onSelectCabinet: (id) {
                setState(() {
                  selectedCabinetId = id;
                  selectedFolderId = -1;
                });
              },
            ),
          ),
          const VerticalDivider(),
          // Second Pane: Folders
          Expanded(
            child: FolderSection(
              selectedCabinet: cabinets.firstWhere(
                  (cabinet) => cabinet.id == selectedCabinetId,
                  orElse: () => cabinets[0]),
              folders: folders
                  .where((folder) =>
                      (selectedCabinetId == 0 ||
                          folder.cabinetId == selectedCabinetId) &&
                      folder.name.toLowerCase().contains(folderSearchQuery))
                  .toList(),
              selectedFolderId: selectedFolderId,
              onSearch: (query) {
                setState(() {
                  folderSearchQuery = query;
                });
              },
              onSelectFolder: (id) {
                setState(() {
                  selectedFolderId = id;
                  parentId =
                      folders.firstWhere((folder) => folder.id == id).cabinetId;
                });
              },
            ),
          ),
          const VerticalDivider(),
          // Third Pane: Users
          Expanded(
            child: UserPane(
              users: users
                  .where((user) => user.name
                      .toLowerCase()
                      .contains(userSearchQuery.toLowerCase()))
                  .toList(),
              permissions: permissions,
              cabinetId: parentId,
              folderId: selectedFolderId,
              onSearch: (query) {
                setState(() {
                  userSearchQuery = query;
                });
              },
              onTogglePermission: (userId) {
                setState(() {
                  FolderPermission? existingPermission;

                  try {
                    existingPermission = permissions.firstWhere(
                      (permission) =>
                          permission.cabinetId == parentId &&
                          permission.folderId == selectedFolderId &&
                          permission.userId == userId,
                    );

                    // Remove permission if it exists
                    permissions.remove(existingPermission);
                  } catch (e) {
                    // Add permission if it doesn't exist
                    permissions.add(FolderPermission(
                      id: permissions.length,
                      cabinetId: parentId,
                      folderId: selectedFolderId,
                      userId: userId,
                    ));
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
