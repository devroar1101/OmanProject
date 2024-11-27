import 'package:flutter/material.dart';
import 'package:tenderboard/admin/department_master/screens/depatment_screen.dart';
import 'package:tenderboard/admin/dgmaster/screens/dgmaster_screen.dart';
import 'package:tenderboard/admin/external_locations_Master/screens/external_location_master_screen.dart';
import 'package:tenderboard/admin/letter_subject/screens/letter_subject_screen.dart';
import 'package:tenderboard/admin/listmaster/screens/listmaster_home.dart';
import 'package:tenderboard/admin/section_master/screens/section_master_screen.dart';
import 'package:tenderboard/admin/user_master/screens/user_master_screen.dart';
import 'package:tenderboard/common/screens/widgets/dashboard.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/office/document_search/screens/document_search_home.dart';
import 'package:tenderboard/office/inbox/screens/inbox_home.dart';
import 'package:tenderboard/office/outbox/screens/outbox_screen.dart';
import 'package:tenderboard/office/scan_index/screens/scan_index_screen.dart';

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
      {'title': 'Inbox', 'icon': Icons.inbox, 'navigate': const InboxHome()},
      {
        'title': 'Outbox',
        'icon': Icons.outbox,
        'navigate': const OutboxScreen()
      },
      {'title': 'CC', 'icon': Icons.mail, 'navigate': const Dashboard()},
      {'title': 'eJob', 'icon': Icons.business, 'navigate': const Dashboard()},
      {
        'title': 'Document Search',
        'icon': Icons.search,
        'navigate': const DocumentSearchHome(),
      },
      {
        'title': 'Circular',
        'icon': Icons.circle,
        'navigate': const ScanAndIndexScreen(),
      },
      {
        'title': 'Decision',
        'icon': Icons.check_circle,
        'navigate': const DocumentSearchHome(),
      },
    ],
    'Admin': [
      {
        'title': 'DG',
        'icon': Icons.account_balance,
        'navigate': const DgMasterScreen()
      },
      {
        'title': 'Department',
        'icon': Icons.business,
        'navigate': const DepartmentMasterScreen()
      },
      {
        'title': 'Section',
        'icon': Icons.folder,
        'navigate': const SectionMasterScreen()
      },
      {
        'title': 'ListMaster',
        'icon': Icons.list,
        'navigate': const ListMasterHome()
      },
      {
        'title': 'Cabinet',
        'icon': Icons.storage,
        'navigate': const Dashboard()
      },
      {
        'title': 'SubjectMaster',
        'icon': Icons.subject,
        'navigate': const LetterSubjectMasterScreen()
      },
      {
        'title': 'ExternalLocation',
        'icon': Icons.account_tree,
        'navigate': const ExternalLocationMasterScreen()
      },
      {
        'title': 'User',
        'icon': Icons.person,
        'navigate': const UserMasterScreen()
      },
    ]
  };

  // Function to handle category switching
  void _changeCategory(String category) {
    setState(() {
      _currentCategory = category;
      widget.onNavigate(ListMasterHome(), 'ListMasterHome', category);
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
      margin: const EdgeInsets.all(16), // Detached sidebar with margin
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Lighter background
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Smooth animation
        width: _isMinimized ? 60 : 220,
        child: Column(
          children: [
            // Sidebar items
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems[_currentCategory]!.length + 1,
                itemBuilder: (context, index) {
                  if (index == _menuItems[_currentCategory]!.length) {
                    final toggleCategory =
                        _currentCategory == 'Office' ? 'Admin' : 'Office';
                    return ListTile(
                      iconColor: Theme.of(context).iconTheme.color,
                      leading: const Icon(Icons.swap_horiz),
                      title: _isMinimized ? null : Text(toggleCategory),
                      onTap: () {
                        _changeCategory(toggleCategory);
                      },
                    );
                  }
                  final item = _menuItems[_currentCategory]![index];
                  final bool isActive = _activeItem == item['title'];

                  return ListTile(
                    leading: Icon(
                      item['icon'],
                      color: isActive ? Colors.blueAccent : AppTheme.iconColor,
                    ),
                    title: _isMinimized
                        ? null
                        : Text(
                            item['title'],
                            style: TextStyle(
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  isActive ? Colors.blueAccent : Colors.black87,
                            ),
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
                  );
                },
              ),
            ),
            // Toggle minimize button at the bottom
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  _isMinimized ? Icons.arrow_forward : Icons.arrow_back,
                ),
                onPressed: _toggleMinimize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
