import 'package:flutter/material.dart';
import 'package:tenderboard/admin/department_master/screens/depatment_screen.dart';
import 'package:tenderboard/admin/dgmaster/screens/dgmaster_screen.dart';
import 'package:tenderboard/admin/external_locations_Master/screens/external_location_master_screen.dart';

import 'package:tenderboard/admin/letter_subject/screens/letter_subject_screen.dart';
import 'package:tenderboard/admin/cabinets_folders/screens/cabinet_home.dart';
import 'package:tenderboard/admin/listmaster/screens/listmaster_home.dart';
import 'package:tenderboard/admin/section_master/screens/section_master_screen.dart';
import 'package:tenderboard/admin/user_master/screens/user_master_screen.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'package:tenderboard/office/document_search/screens/document_search_home.dart';
import 'package:tenderboard/office/ejob/screens/ejob_screen.dart';
import 'package:tenderboard/office/ejob_summary/screens/ejob_summary_screen.dart';
import 'package:tenderboard/office/inbox/screens/inbox_screen.dart';

import 'package:tenderboard/office/outbox/screens/outbox_screen.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_summary.dart';
import 'package:tenderboard/office/letter/screens/letter_index.dart';

class CustomSidebar extends StatefulWidget {
  final Function(Widget, String, String?)
      onNavigate; // Callback function to navigate to new widget

  const CustomSidebar({super.key, required this.onNavigate});

  @override
  _CustomSidebarState createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  bool _isMinimized = false; // Controls whether the sidebar is minimized
  String _currentCategory = 'Office'; // Tracks the current category
  String? _activeItem; // Tracks the currently active menu item

  // Define the items for Office and Admin categories
  final Map<String, List<Map<String, dynamic>>> _menuItems = {
    'Office': [
      {
        'title': getTranslation('Inbox'),
        'icon': Icons.inbox,
        'navigate': const InboxScreen()
      },
      {
        'title': getTranslation('Outbox'),
        'icon': Icons.outbox,
        'navigate': const OutboxScreen()
      },
      {
        'title': getTranslation('CC'),
        'icon': Icons.mail,
        'navigate': const LetterSummary('121212')
      },
      {
        'title': getTranslation('Ejob'),
        'icon': Icons.business,
        'navigate': const EjobScreen()
      },
      {
        'title': getTranslation('DocumentSearch'),
        'icon': Icons.search,
        'navigate': const DocumentSearchHome(),
      },
      {
        'title': getTranslation('ScanAndIndex'),
        'icon': Icons.circle,
        'navigate': const LetterIndex(),
      },
      {
        'title': getTranslation('Decision'),
        'icon': Icons.check_circle,
        'navigate': const EjobSummaryScreen(),
      },
    ],
    'Admin': [
      {
        'title': getTranslation('DG'),
        'icon': Icons.account_balance,
        'navigate': const DgMasterScreen()
      },
      {
        'title': getTranslation('Department'),
        'icon': Icons.business,
        'navigate': const DepartmentMasterScreen()
      },
      {
        'title': getTranslation('Section'),
        'icon': Icons.folder,
        'navigate': const SectionMasterScreen()
      },
      {
        'title': getTranslation('ListMaster'),
        'icon': Icons.list,
        'navigate': const ListMasterHome()
      },
      {
        'title': getTranslation('Cabinet'),
        'icon': Icons.storage,
        'navigate': const CabinetHome()
      },
      {
        'title': getTranslation('SubjectMaster'),
        'icon': Icons.subject,
        'navigate': const LetterSubjectMasterScreen()
      },
      {
        'title': getTranslation('ExternalLocation'),
        'icon': Icons.account_tree,
        'navigate': const ExternalLocationScreen()
      },
      {
        'title': getTranslation('Users'),
        'icon': Icons.person,
        'navigate': const UserMasterScreen()
      },
    ]
  };

  // Function to handle category switching
  void _changeCategory(String category) {
    setState(() {
      _currentCategory = category;
      widget.onNavigate(const ListMasterHome(), 'ListMasterHome', category);
    });
  }

  // Function to minimize/expand the sidebar
  void _toggleMinimize() {
    setState(() {
      _isMinimized = !_isMinimized;
    });
  }

  // Function to handle the navigation and hide sidebar if needed
  void _navigate(Widget screen, String name) {
    widget.onNavigate(screen, name, _currentCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Lighter background
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 10, 31, 61),
          Color.fromARGB(133, 10, 31, 61)
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Smooth animation
        curve: Easing.legacy,
        width: _isMinimized ? 70 : 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sidebar items
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems[_currentCategory]!.length + 1,
                itemBuilder: (context, index) {
                  if (index == _menuItems[_currentCategory]!.length) {
                    final toggleCategory =
                        _currentCategory == 'Office' ? 'Admin' : 'Office';
                    return Center(
                      child: ListTile(
                        iconColor: Theme.of(context).iconTheme.color,
                        leading: const Icon(Icons.swap_horiz),
                        title: _isMinimized
                            ? null
                            : Text(
                                toggleCategory,
                                style:
                                    const TextStyle(color: AppTheme.iconColor),
                              ),
                        onTap: () {
                          _changeCategory(toggleCategory);
                        },
                      ),
                    );
                  }
                  final item = _menuItems[_currentCategory]![index];
                  final bool isActive = _activeItem == item['title'];

                  return Center(
                    child: ListTile(
                      leading: Icon(
                        item['icon'],
                        color: isActive
                            ? AppTheme.activeColor
                            : AppTheme.iconColor,
                      ),
                      title: _isMinimized
                          ? null
                          : Text(
                              item['title'],
                              style: TextStyle(
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isActive
                                      ? AppTheme.activeColor
                                      : AppTheme.iconColor),
                            ),
                      tileColor: isActive ? Colors.blue.withOpacity(0.1) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onTap: () {
                        setState(() {
                          _activeItem = item['title'];
                        });
                        // For Document Search, hide sidebar on navigation
                        _navigate(item['navigate'], item['title']);
                      },
                    ),
                  );
                },
              ),
            ),
            // Toggle minimize button at the bottom
            IconButton(
              icon: Icon(
                  _isMinimized ? (Icons.arrow_forward) : (Icons.arrow_back),
                  color: AppTheme.iconColor),
              onPressed: _toggleMinimize,
            ),
          ],
        ),
      ),
    );
  }
}
