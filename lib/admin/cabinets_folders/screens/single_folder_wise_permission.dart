import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_permission_repo.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/cabinet_section.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/folder_section.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/widgets/user_section.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';

import '../model/folder_permission.dart';

class FolderWisePermission extends ConsumerStatefulWidget {
  const FolderWisePermission(
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
  _FolderWisePermissionState createState() => _FolderWisePermissionState();
}

class _FolderWisePermissionState extends ConsumerState<FolderWisePermission> {
  // Sample data
  List<Cabinet> cabinets = [];

  List<Folder> folders = [];

  List<UserMaster> users = [];

  List<FolderPermission> permissions = [];

  int? selectedCabinetId = 1;
  int? selectedFolderId = 1;
  int? parentId;
  String cabinetSearchQuery = '';
  String folderSearchQuery = '';
  String userSearchQuery = '';

  @override
  void initState() {
    super.initState();
    cabinets = widget.cabinets;
    folders = widget.folders;
    cabinets = widget.cabinets;
    folders = widget.folders;
    users = widget.users;
    permissions = widget.folderPermission;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // First Pane: Cabinets
          Expanded(
            child: CabinetSection(
              cabinets: cabinets
                  .where((cabinet) => cabinet.nameArabic
                      .toLowerCase()
                      .contains(cabinetSearchQuery))
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
                      folder.nameArabic
                          .toLowerCase()
                          .contains(folderSearchQuery))
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
              cabinetId: parentId ?? 0,
              folderId: selectedFolderId ?? 0,
              onSearch: (query) {
                setState(() {
                  userSearchQuery = query;
                });
              },
              onTogglePermission: (userId) {
                FolderPermission? existingPermission;

                try {
                  existingPermission = permissions.firstWhere(
                    (permission) =>
                        permission.folderId == selectedFolderId &&
                        permission.userId == userId,
                  );

                  ref
                      .read(folderPermissionRepositoryProvider.notifier)
                      .deleteFolderPermission(existingPermission.id);
                } catch (e) {
                  ref
                      .read(folderPermissionRepositoryProvider.notifier)
                      .addFolderPermission(
                          folderId: selectedFolderId!, userId: userId);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
