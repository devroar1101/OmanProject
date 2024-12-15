import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet_repo.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_repo.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/bulk_folder_wise_permission.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/single_folder_wise_permission.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/user_wise_permission.dart';

class FolderPermissionHome extends ConsumerStatefulWidget {
  const FolderPermissionHome({super.key});

  @override
  _FolderPermissionHomeState createState() => _FolderPermissionHomeState();
}

class _FolderPermissionHomeState extends ConsumerState<FolderPermissionHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Cabinet> cabinets = [];
  List<Folder> folders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ref.read(cabinetRepositoryProvider.notifier).fetchCabinets();
    ref.read(folderRepositoryProvider.notifier).fetchFolders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cabinets = ref.watch(cabinetRepositoryProvider);
    folders = ref.watch(folderRepositoryProvider);
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
                ),
                BulkFolderWisePermission(
                  cabinets: cabinets,
                  folders: folders,
                ),
                UserWisePermission(
                  cabinets: cabinets,
                  folders: folders,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
