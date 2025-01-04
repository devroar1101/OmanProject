import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';

import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';
import 'package:tenderboard/admin/user_master/screens/add_user_master.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen>
    with SingleTickerProviderStateMixin {
  bool _isSearchFormVisible = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  // Pagination and search variables
  int pageNumber = 1;
  int pageSize = 15;
  String searchLoginId = '';
  String searchName = '';
  String searchDG = '';
  String searchDepartment = '';
  String searchSection = '';
  bool search = false;

  @override
  void initState() {
    super.initState();
    ref.read(UserRepositoryProvider.notifier).fetchUsers();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSearchForm() {
    setState(() {
      _isSearchFormVisible = !_isSearchFormVisible;
      if (_isSearchFormVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void onSearch(String loginId, String name, String dg, String department,
      String section) {
    setState(() {
      searchLoginId = loginId;
      searchName = name;
      searchDG = dg;
      searchDepartment = department;
      searchSection = section;
      pageNumber = 1;
      pageSize = 15; // Reset to first page on new search
      search = true;
    });
  }

  List<User> _applyFiltersAndPagination(List<User> users) {
    if (users.isEmpty) {
      return [];
    }

    List<User> filteredList = users.where((singleUser) {
      // final matchesLoginId = searchLoginId.isEmpty ||
      //     (singleUser.loginId.toLowerCase())
      // .contains(searchNameArabic.toLowerCase());
      final matchesName = searchName.isEmpty ||
          (singleUser.name.toLowerCase()).contains(searchName.toLowerCase());
      final matchesDg =
          searchDG.isEmpty || singleUser.dgId.toString() == searchDG;
      final matchesDepartment = searchDepartment.isEmpty ||
          singleUser.departmentId.toString() == searchDepartment;
      final matchesSection = searchSection.isEmpty ||
          singleUser.sectionId.toString() == searchSection;
      return matchesDg &&
          matchesSection &&
          matchesDepartment &&
          matchesName; // && matchesDg;
    }).toList();
    print('filters count : ${filteredList.length}');
    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(UserRepositoryProvider);
    final filteredAndPaginatedList = _applyFiltersAndPagination(users);

    final iconButtons = [
      {
        "button": Icons.edit,
        "function": (int id) {
          final User currentUser = users.firstWhere((user) => user.id == id);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddUserScreen(
                currentUser: currentUser,
              );
            },
          );
        },
      },
      {"button": Icons.delete, "function": (int id) {}},
    ];

    return Scaffold(
      body: Column(
        children: [
          /* UsersSearchForm(
            onSearch: onSearch,
          ),*/
          if (users.isNotEmpty)
            Pagination(
              totalItems:
                  search ? filteredAndPaginatedList.length : users.length,
              initialPageSize: pageSize,
              onPageChange: (pageNo, newPageSize) {
                setState(() {
                  pageNumber = pageNo;
                  pageSize = newPageSize;
                });
              },
            ), // Search form widget
          if (users.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const [
                    'LoginId',
                    'DisplayName',
                    'DG',
                    'Department',
                    'Section',
                    //'Designation',
                  ],
                  data: const [
                    'name',
                    'systemName',
                    'dgName',
                    'departmentName',
                    'sectionName',
                    //'designationNameEnglish',
                  ],
                  details: User.listToMap(filteredAndPaginatedList),
                  expandable: true,
                  iconButtons: iconButtons,
                  onTap: (id, {objectId}) {},
                  detailKey: 'id',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
