import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet_repo.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_permission.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_permission_repo.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_repo.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/bulk_folder_wise_permission.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/single_folder_wise_permission.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/user_wise_permission.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';

class FolderPermissionHome extends ConsumerStatefulWidget {
  const FolderPermissionHome({super.key});

  @override
  _FolderPermissionHomeState createState() => _FolderPermissionHomeState();
}

class _FolderPermissionHomeState extends ConsumerState<FolderPermissionHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Cabinet> cabinets = [];
  late List<Folder> folders = [];
  late List<UserMaster> users = [];
  late List<FolderPermission> folderPermission = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    initialize();
  }

  Future<void> initialize() async {
    try {
      final results = await Future.wait([
        ref.read(UserMasterRepositoryProvider.notifier).fetchUsers(),
        ref
            .read(folderPermissionRepositoryProvider.notifier)
            .fetchFolderPermissions(),
      ]);
    } catch (e) {
      throw Exception('Error during initialization: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    folderPermission = ref.watch(folderPermissionRepositoryProvider);
    cabinets = ref.watch(cabinetRepositoryProvider);
    folders = ref.watch(folderRepositoryProvider);
    users = ref.watch(UserMasterRepositoryProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs at the top
          SizedBox(
            width: 500,
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8), // Rounded indicator
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Folder Wise'),
                Tab(text: 'Bulk Folder Wise'),
                Tab(text: 'User Wise'),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FolderWisePermission(
                  cabinets: cabinets,
                  folders: folders,
                  users: users,
                  folderPermission: folderPermission,
                ),
                BulkFolderWisePermission(
                  cabinets: cabinets,
                  folders: folders,
                  users: users,
                  folderPermission: folderPermission,
                ),
                UserWisePermission(
                  cabinets: cabinets,
                  folders: folders,
                  users: users,
                  folderPermission: folderPermission,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
