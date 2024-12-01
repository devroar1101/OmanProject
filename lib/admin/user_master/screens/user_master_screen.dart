import 'package:flutter/material.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';
import 'package:tenderboard/admin/user_master/screens/user_master_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class UserMasterScreen extends StatefulWidget {
  const UserMasterScreen({super.key});

  @override
  _UserMasterScreenState createState() => _UserMasterScreenState();
}

class _UserMasterScreenState extends State<UserMasterScreen> with SingleTickerProviderStateMixin {
  final UserMasterRepository _repository = UserMasterRepository();
  bool _isSearchFormVisible = false;
  late Future<List<UserMaster>> _userFuture;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _userFuture = _repository.fetchUsers();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),  // Duration for smooth transition
    );

    // Opacity animation (fade in/out)
    _opacityAnimation = Tween<double>(
      begin: 0.0,  // Start invisible
      end: 1.0,    // End fully visible
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Smooth transition
    ));

    // Scale animation (zoom in/out)
    _scaleAnimation = Tween<double>(
      begin: 0.8,  // Start at 80% scale
      end: 1.0,    // End at 100% scale (normal size)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Smooth transition
    ));
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
        _animationController.forward();  // Trigger animation forward (fade in & scale up)
      } else {
        _animationController.reverse();  // Trigger animation reverse (fade out & scale down)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Master"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _toggleSearchForm,
          ),
        ],
      ),
      body: Column(
        children: [
          // Combined Fade + Scale animation
          FadeTransition(
            opacity: _opacityAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _isSearchFormVisible ? const UsersSearchForm() : Container(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserMaster>>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items found'));
                } else {
                  final items = snapshot.data!;

                  // Define headers and data keys
                  final headers = [
                    'Login Id',
                    'Name',
                    'Role',
                    'Organization',
                    'LDAP Identifier',
                    'Designation',
                  ];
                  final dataKeys = [
                    'loginId',
                    'name',
                    'roleNameEnglish',
                    'dgNameEnglish',
                    'ldapIdentifier',
                    'designationNameEnglish',
                  ];

                  // Convert ListMasterItem list to map list with sno
                  final details = UserMaster.listToMap(items);

                  // Pass the converted list to DisplayDetails
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DisplayDetails(
                      detailKey: 'objectId',
                      headers: headers,
                      data: dataKeys,
                      details: details, // Pass the list of maps
                      expandable: true, // Set false to expand by default
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
