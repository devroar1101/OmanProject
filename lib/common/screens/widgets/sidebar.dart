import 'package:flutter/material.dart';
import 'package:tenderboard/common/screens/widgets/dashboard.dart';

class CustomSidebar extends StatefulWidget {
  final Function(Widget)
      onNavigate; // Callback function to navigate to new widget

  CustomSidebar({required this.onNavigate});

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
      {'title': 'Inbox', 'icon': Icons.inbox, 'navigate': Dashboard()},
      {'title': 'Outbox', 'icon': Icons.outbox, 'navigate': Dashboard()},
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
        'navigate': Dashboard()
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
      {'title': 'Office', 'icon': Icons.home, 'navigate': Dashboard()},
    ]
  };

  // Function to handle when a category is clicked
  void _changeCategory(String category) {
    setState(() {
      _currentCategory = category;
    });
  }

  // Function to minimize/expand the sidebar
  void _minimizeSidebar() {
    setState(() {
      _isMinimized = !_isMinimized;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _isMinimized ? 60 : 250, // Width changes based on minimized state
      color: Colors.blueGrey[50],
      child: Column(
        children: [
          // Minimize/Maximize Button in the top-right corner
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(_isMinimized ? Icons.arrow_forward : Icons.arrow_back),
              onPressed: _minimizeSidebar,
            ),
          ),
          // Display menu items for the selected category
          Expanded(
            child: ListView.builder(
              itemCount: (_menuItems[_currentCategory]?.length ?? 0) +
                  1, // Add 1 for the "Admin/Office" button at the end
              itemBuilder: (context, index) {
                // If the last item, display the opposite category (Admin or Office)
                if (index == (_menuItems[_currentCategory]?.length ?? 0)) {
                  return ListTile(
                    leading: _isMinimized
                        ? Icon(Icons.folder)
                        : Icon(Icons.folder, size: 24),
                    title: _isMinimized
                        ? null
                        : Text(
                            _currentCategory == 'Office' ? 'Admin' : 'Office'),
                    onTap: () {
                      // Switch between categories
                      _changeCategory(
                          _currentCategory == 'Office' ? 'Admin' : 'Office');
                    },
                  );
                }
                final item = _menuItems[_currentCategory]![index];
                return ListTile(
                  leading: _isMinimized
                      ? Icon(item['icon']) // Show only icon for minimized mode
                      : Icon(item['icon'],
                          size: 24), // Use full icon in expanded mode
                  title: _isMinimized ? null : Text(item['title']!),
                  onTap: () {
                    // Navigate to the selected widget when clicked
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
