import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';
import 'package:tenderboard/admin/user_master/screens/user_master_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
class UserMasterScreen extends ConsumerStatefulWidget {
  const UserMasterScreen({super.key});

  @override
  _UserMasterScreenState createState() => _UserMasterScreenState();
}

class _UserMasterScreenState extends ConsumerState<UserMasterScreen>
    with SingleTickerProviderStateMixin {
  bool _isSearchFormVisible = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  // Pagination and search variables
  int pageNumber = 1;
  int pageSize = 10;
  String searchLoginId = '';
  String searchName = '';
  String searchRole = '';

  @override
  void initState() {
    super.initState();
    ref.read(UserMasterRepositoryProvider.notifier).fetchUsers();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(_animationController);
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

  

  void onSearch(String loginId, String name, String role) {
    setState(() {
      searchLoginId = loginId;
      searchName = name;
      searchRole = role;
      pageNumber = 1; // Reset to first page on new search
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(UserMasterRepositoryProvider);
    print('users122: $users');
    return Scaffold(
      body: Column(
        children: [
          const UsersSearchForm(),
          if (users.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const [
                    'Login Id',
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
                  details: UserMaster.listToMap(users),
                  expandable: true,
                  onTap: (int id) {},
                  detailKey: 'id',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
