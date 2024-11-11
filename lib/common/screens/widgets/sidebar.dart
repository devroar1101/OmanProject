import 'package:flutter/material.dart';
import 'package:tenderboard/common/screens/widgets/dashboard.dart';
import 'package:tenderboard/office/document_search/screens/document_search_home.dart';
import 'package:tenderboard/office/inbox/screens/inbox_home.dart';
import 'package:tenderboard/office/outbox/screens/outbox_screen.dart';

class CustomSidebar extends StatefulWidget {
  final Function(Widget)
      onNavigate; // Callback function to navigate to new widget

  const CustomSidebar({super.key, required this.onNavigate});

  @override
  _CustomSidebarState createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  bool _isMinimized = false; // Controls whether the sidebar is minimized
  String _currentCategory =
      'Office'; // Tracks the current category (Office or Admin)

  // Define the items for Office and Admin categories
  final Map<String, List<Map<String, dynamic>>> _menuItems = {
    'Office': [
      {'title': 'Inbox', 'icon': Icons.inbox, 'navigate': const InboxHome()},
      {'title': 'Outbox', 'icon': Icons.outbox, 'navigate': const OutboxScreen()},
      {'title': 'CC', 'icon': Icons.mail, 'navigate': Dashboard()},
      {'title': 'eJob', 'icon': Icons.business, 'navigate': Dashboard()},
      {
        'title': 'Document Search',
        'icon': Icons.search,
        'navigate': Dashboard()
      },
      {'title': 'Circular', 'icon': Icons.circle, 'navigate': Dashboard()},
      {
        'title': 'Decision',
        'icon': Icons.check_circle,
        'navigate': DocumentSearchHome()
      },
    ],
    'Admin': [
      {'title': 'DG', 'icon': Icons.account_balance, 'navigate': Dashboard()},
      {'title': 'Department', 'icon': Icons.business, 'navigate': Dashboard()},
      {'title': 'Section', 'icon': Icons.folder, 'navigate': Dashboard()},
      {'title': 'ListMaster', 'icon': Icons.list, 'navigate': Dashboard()},
      {'title': 'Cabinet', 'icon': Icons.storage, 'navigate': Dashboard()},
      {
        'title': 'ExternAllocation',
        'icon': Icons.account_tree,
        'navigate': Dashboard()
      },
      {'title': 'User', 'icon': Icons.person, 'navigate': Dashboard()},
    ]
  };

  // Function to handle category switching
  void _changeCategory(String category) {
    setState(() {
      _currentCategory = category;
    });
  }

  // Function to minimize/expand the sidebar
  void _toggleMinimize() {
    setState(() {
      _isMinimized = !_isMinimized;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the layout direction is RTL
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      width: _isMinimized ? 60 : 250, // Width changes based on minimized state
      color: Colors.blueGrey[50],
      child: Column(
        children: [
          // Minimize Button at top-left or top-right corner of sidebar based on RTL
          Align(
            alignment: isRtl ? Alignment.topLeft : Alignment.topRight,
            child: IconButton(
              icon: Icon(
                _isMinimized
                    ? (isRtl ? Icons.arrow_back : Icons.arrow_forward)
                    : (isRtl ? Icons.arrow_forward : Icons.arrow_back),
              ),
              onPressed: _toggleMinimize,
            ),
          ),
          // Display menu items for the selected category
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems[_currentCategory]!.length +
                  1, // Add 1 for the "Admin/Office" button at the end
              itemBuilder: (context, index) {
                // If this is the last item, show the toggle to switch between categories
                if (index == _menuItems[_currentCategory]!.length) {
                  final toggleCategory =
                      _currentCategory == 'Office' ? 'Admin' : 'Office';
                  return ListTile(
                    leading: const Icon(Icons.folder),
                    title: _isMinimized ? null : Text(toggleCategory),
                    onTap: () {
                      _changeCategory(toggleCategory);
                    },
                  );
                }
                // Render menu items normally
                final item = _menuItems[_currentCategory]![index];
                return ListTile(
                  leading: Icon(item['icon']),
                  title: _isMinimized ? null : Text(item['title']),
                  onTap: () {
                    widget.onNavigate(item['navigate']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
