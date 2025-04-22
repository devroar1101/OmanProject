import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';
import 'package:tenderboard/admin/user_master/screens/add_user_master.dart';
import 'package:tenderboard/admin/user_master/screens/user_master_form.dart';
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
  late Animation<Offset> _slideAnimation;

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start from off-screen (right)
      end: const Offset(0.0, 0.0), // Move to visible position
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
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
        print('iddddd$loginId');
    setState(() {
      searchLoginId = loginId;
      searchName = name;
      searchDG = dg;
      searchDepartment = department;
      searchSection = section;
      pageNumber = 1;
      pageSize = 15;
      search = true;
    });
  }

  List<User> _applyFiltersAndPagination(List<User> users) {
    if (users.isEmpty) {
      return [];
    }

    List<User> filteredList = users.where((singleUser) {
      print('single user id ${singleUser.loginId}');
      final matchesName = searchName.isEmpty ||
          (singleUser.name.toLowerCase()).contains(searchName.toLowerCase());
      final matchesDg =
          searchDG.isEmpty || singleUser.dgId.toString() == searchDG;
      final matchesLoginId = searchLoginId.isEmpty ||
          (singleUser.loginId.toLowerCase()).contains(searchLoginId.toLowerCase());
      final matchesDepartment = searchDepartment.isEmpty ||
          singleUser.departmentId.toString() == searchDepartment;
      final matchesSection = searchSection.isEmpty ||
          singleUser.sectionId.toString() == searchSection;
      return matchesDg && matchesSection && matchesDepartment && matchesName && matchesLoginId;
    }).toList();

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
              return AddUserScreen(currentUser: currentUser);
            },
          );
        },
      },
      {"button": Icons.delete, "function": (int id) {}},
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('User Master'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search),
      //       onPressed: _toggleSearchForm, // Show search form on click
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          Column(
            children: [
              if (users.isNotEmpty)
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align items
                  children: [
                    Pagination(
                      totalItems: search
                          ? filteredAndPaginatedList.length
                          : users.length,
                      initialPageSize: pageSize,
                      onPageChange: (pageNo, newPageSize) {
                        setState(() {
                          pageNumber = pageNo;
                          pageSize = newPageSize;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search,
                          color: Colors.black), // Adjust color as needed
                     onPressed: _toggleSearchForm, // Show search form on click
                    ),
                  ],
                ),
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
                      ],
                      data: const [
                        'name',
                        'systemName',
                        'dgName',
                        'departmentName',
                        'sectionName',
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
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimation,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.4, // 40% width of screen
                    height: double.infinity,
                    color: Colors.white, // Background color
                    padding: const EdgeInsets.all(16.0),
                    child: UsersSearchForm(
                      onSearch: onSearch,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
